---
layout: post
title: pipx install topgrade
---

Many Rust projects, such as [Topgrade](https://github.com/topgrade-rs/topgrade),
also publish themselves on PyPI. This means you can install them using `pip` or
`pipx` as follows:

```shell
pipx install topgrade
pipx install zizmor
```

This pulls a binary (wheel) directly from PyPI, which obviates the need to
compile from source—handy on low-powered machines where `cargo install` can take
a while to run or exhaust the memory (ask me how I know).

If you maintain a Rust project, it looks pretty easy to enable this installation
method using [Maturin](https://www.maturin.rs/bindings.html#bin).

Speaking of Topgrade: Topgrade is a helpful command-line tool that automatically
updates everything it can on your system (think `sudo apt update && sudo apt
upgrade && flatpak update && ...`). I recently got a [PR accepted](https://github.com/topgrade-rs/topgrade/pull/1047) that enables
Topgrade to run `conda clean`, which can free up gigabytes of space on a well-used
conda installation. I also have an [open PR](https://github.com/topgrade-rs/topgrade/pull/1048) (perhaps merged or rejected
by the time you read this) that lets you request additional conda environments
to upgrade besides `base`.

Speaking of conda: For better or worse, I have become something of a
[conda apologist]{% post_url 2024-11-29-rbenv-vs-conda %}. In the same way
Python gets called the “second-best language for everything,“ conda is not as
ambitious as [Nix](https://nixos.org/), nor as hip as [uv](https://docs.astral.sh/uv/),
nor as pretty as [Poetry](https://python-poetry.org/). But conda continues to
solve practical problems for me in a wide variety of different situations. It’s
a solid workhorse.
