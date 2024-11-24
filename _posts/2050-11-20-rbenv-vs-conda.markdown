---
layout: post
title: Replacing rbenv with conda
---

Too-long post in which I explain why I am using conda instead of rbenv to
install Ruby inside of the CI job that builds this static site.<!--more-->

# The problem

I wanted to make the GitHub Action that builds this static site more portable by
replacing the
[parade of third-party GitHub Actions](https://github.com/maxkapur/maxkapur.github.io/actions/runs/11923415581/workflow)
with simple shell scripts.

With a self-contained build process, I can match my local build workflow to the
one used to deploy the site from GitHub without going to (IMO) extremes like
[running the GitHub Actions Docker image locally](https://github.com/nektos/act).
It also makes it easier to migrate my hosting away from GitHub Pages if I ever
should desire to.

However, in my previous attempts to make a portable build script, I kept having
difficulty with what should be the easiest step: Installing a Ruby version of my
choice (currently v3.2) and pulling in all of Jekyll’s dependencies.

# The normal solution

Most of the guides I consulted recommend
[rbenv](https://github.com/rbenv/rbenv), which is a Ruby version manager that
lets you specify your desired Ruby version in a `.ruby-version` file and install
it with `rbenv install`.

Unfortunately, installing rbenv itself is not that simple: On Debian stable and
Ubuntu 22.04 (which is currently `ubuntu-latest` in GitHub Actions), the version
of rbenv in the repos is too far out of date to install the version of Ruby I
want. The rbenv developers recommend using the
[rbenv-installer](https://github.com/rbenv/rbenv-installer) script to install
the latest rbenv from Git instead, but then the rbenv-installer README advises
against usage in a CI pipeline, which is exactly what I want to do:

> For automating installation across machines it’s better to *avoid* using this
> script in favor of fine-tuning rbenv & ruby-build installation manually.

This gets at another difficulty with rbenv, which is that it builds Ruby *from
source* when you `rbenv install` a version that isn’t in your local cache. This
means installing `ruby-build` in addition to a bunch of dynamically linked
development libraries. On some of my workstations, I struggled and failed to put
together a functional `ruby-build` toolchain; on my laptop, I finally got it
working, only to have the build fail because I ran out of memory.

For those who have the time and computational resources to compile from source,
rbenv is a great tool, but for me, what I really needed was a precompiled
binary. (Thus, I also ruled out [RVM](https://rvm.io/), another popular
recommendation.)

# The conda solution

Enter [`conda-forge::ruby`](https://github.com/conda-forge/ruby-feedstock).
Conda is a cross-platform package management and virtual environment system that
is generally associated with the Python world (because it is written in Python)
but supports generic binary packages. I used to be skeptical of conda because
the most popular distributions (Anaconda and Miniconda) are proprietary, but
[Miniforge](https://github.com/conda-forge/miniforge) is an open-source
alternative that covers all my use cases.

After installing conda (and [mamba](https://github.com/mamba-org/mamba) because
why not), I created build scripts `configure.sh`, `build.sh`, and so on that
simply wrap `mamba create` and `mamba run`. The
[GitHub Action that builds the site](https://github.com/maxkapur/maxkapur.github.io/actions/runs/11923546983/workflow)
is now basically just this:

```shell
./configure.sh  # Create the conda environment and run bundle install
./info.sh       # Log package versions
./build.sh      # Build the site
./check.sh      # Lint scripts with ShellCheck; might add more checks
```

This workflow takes an average of two minutes to run on the GitHub cloud
runners, which makes it *faster,* on average, than the parade of GitHub Actions
I had before, which took about three minutes (except when running the workflow
several times in a row, in which case caching would bring the runtime down to 20
or 30 seconds).

# Alas

Alas, my GitHub Action workflow still has one third-party dependency: The
[Setup Miniconda](https://github.com/marketplace/actions/setup-miniconda)
action. Despite the name, it can set up either Miniconda or Miniforge, and it is
a little easier to work with than Miniforge’s interactive installer script.

I *think* this is a sustainable solution, although those are probably bold words
from the guy who just set all this up last week.
