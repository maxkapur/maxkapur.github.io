---
layout: post
title: How I self-host fonts on this blog
---

I recently transitioned this blog to self-host its fonts (IBM Plex Sans, Sans
KR, and Mono) from within the GitHub Pages artifact instead of calling the
Google Fonts API. This makes the site a little more “static” by eliminating the
need for your browser to download font files from an external domain. Here, I
explain the self-hosting approach I chose and why.<!--more-->

The easiest way to self-host fonts with a static site generator like Jekyll is
to store the `.ttf` or `.woff2` font files and their CSS inside of the `assets/`
folder of the source repo. But I wanted to avoid bringing an external dependency
into my source tree: I have an (admittedly puristic) desire for my repo to
consist only of code I wrote myself. And I wanted to try automating the process
of downloading and installing a dependency *without* using a package manager
like conda or apt.[^packagemanager]

My source repo already has a `configure.sh` script that installs Ruby, Jekyll
and so on to the local workstation so that it can build and preview the static
site. To this script, I added `curl` and `unzip` commands to automatically
download the latest IBM Plex release and extract the fonts to the `assets/`
directory (where they are `.gitignore`d).

Now, as long as IBM follows semantic versioning in its font releases, updating
to a new version of IBM Plex requires no more than changing the version number
in these lines from `configure.sh`:

```text
IBM_PLEX_MONO_SRC="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip"
IBM_PLEX_SANS_SRC="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip"
IBM_PLEX_SANS_KR_SRC="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-kr%401.1.0/ibm-plex-sans-kr.zip"
```

<!--
    TODO: Explain GitHub URL trick that automatically grabs the latest release
    instead of pinning version. Link to documentation

    (I could also use the `latest`)
-->

[^packagemanager]: I already use conda as part of my `configure.sh` script, so installing a
    font with conda wouldn’t be a heavy lift, but only the Sans variant of IBM
    Plex is available in conda-forge, and I need the KR and Mono variants, too.
    These fonts *are* available in the Ubuntu apt repositories, but then my
    build script would no longer function on other Linux distros. \<--TODO:
    double check these claims, provide link, also I think the conda-forge
    version was missing CSS? -->
