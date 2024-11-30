---
layout: post
title: How I self-host fonts on this blog
---

I recently transitioned this blog to self-host its fonts (IBM Plex Sans, Sans
KR, and Mono) from within the GitHub Pages artifact instead of calling the
Google Fonts API. This makes the site a little more “static” by eliminating the
need for your browser to download font files from an external domain. Here, I
explain how (and why) I self-host fonts without bringing them into the source
tree.<!--more-->

The easiest way to self-host fonts with a static site generator like Jekyll is
to store the `.ttf` or `.woff2` font files and their CSS inside of the `assets/`
folder of the source repo. But this turns the font into an in-tree dependency,
which I wanted to avoid: Although IBM’s
[SIL Open Font License](https://github.com/IBM/plex/blob/4b8acbebe10a52a14d3a80b3f95cc9ff0ec9b39b/LICENSE.txt)
appears to permit this sort of vendoring, I have an (admittedly puristic) desire
for my repo to consist only of code I wrote myself. And I wanted to try
automating the process of downloading and installing a dependency *without*
using a package manager like conda or apt.[^packagemanager]

My source repo already has a `configure.sh` script that installs Ruby, Jekyll
and so on to the local workstation so that it can build and preview the static
site. To this script, I added `curl` and `unzip` commands to
[automatically download the latest IBM Plex release and extract](https://github.com/maxkapur/maxkapur.github.io/blob/f6521d7800c2e8a3111de226767e808f97f50572/configure.sh#L99-L132)
the fonts to the `assets/` directory (where they are `.gitignore`d).

Now, as long as IBM follows semantic versioning in its font releases, updating
to a new version of IBM Plex requires no more than changing the version number
in these lines from `configure.sh`:

```text
IBM_PLEX_MONO_SRC="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip"
IBM_PLEX_SANS_SRC="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip"
IBM_PLEX_SANS_KR_SRC="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-kr%401.1.0/ibm-plex-sans-kr.zip"
```

(It is also possible to modify these URLs to automatically
[pull the latest release](https://docs.github.com/en/repositories/releasing-projects-on-github/linking-to-releases)
instead of pinning a version.)

[^packagemanager]: I [already use conda]( {% post_url 2024-11-29-rbenv-vs-conda %} ) as part
    of my `configure.sh` script, so installing a font with conda wouldn’t be a
    heavy lift, but only the Sans variant of IBM Plex is
    [available in conda-forge](https://anaconda.org/conda-forge/font-ttf-ibm-plex-sans),
    and I need the KR and Mono variants, too. (The conda package also doesn’t
    include CSS font definitions.)

    These fonts *are* available
    [in the Ubuntu apt repositories](https://packages.ubuntu.com/oracular/all/fonts-ibm-plex/filelist),
    but then my build script would no longer function on other Linux distros,
    and I’d still have to use `./configure.sh` to copy the files from
    `/usr/share/` to my site’s `assets/` directory.
