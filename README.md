# Illusion Slopes

This repository holds my personal blog, Illusion Slopes, which can be viewed at
[maxkapur.com](https://maxkapur.com).

It also used to host several one-off essays, but these have have now been moved
to separate repos, namely
[cyborgs-and-ciphers](https://github.com/maxkapur/cyborgs-and-ciphers),
[esl-data](https://github.com/maxkapur/esl-data), and
[how-do-we](https://github.com/maxkapur/how-do-we).

My blog is on a CC BY-SA 4.0 license. Comments and suggestions are welcome via
[email](mailto:max@maxkapur.com) or GitHub pull request.

## Workstation setup

`./configure.sh` installs all dependencies using `mamba` (to install Ruby) then
`bundler` (to install Jekyll and other Ruby dependencies). On first run, the
script creates a conda environment (`mamba create`); on subsequent runs, it
updates the environment in place (`mamba update`). If you think your environment
is corrupt, run `git stash; git clean -fidx` then rerun `./configure.sh`.

I use `conda` to install Ruby because, in my tests, it provided the most
reliable way to install a fixed Ruby version across platforms without requiring
you to build Ruby from source (as with `rbenv`).

You preview the site by running `./serve.sh`, or just build it to the `_site/`
directory with `./build.sh`.

`./check.sh` runs ShellCheck on the build scripts.

`./info.sh` logs package versions.
