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
