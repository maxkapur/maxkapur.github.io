---
layout: post
title: Conda updated?
---

Using a tip from
[Travis Hathaway](https://github.com/conda/conda/issues/14418#issuecomment-2513806325),
here is a shell one-liner to check if a conda environment is up to date:

```shell
conda update --all --dry-run --json | jq -e '.success and (.actions | length) == 0'
```

It exits (`-e`) with `0` if the environment is already updated and `1` if
updates are available.

I use this in CI so that I get an email if my `environment.yml` file is holding
any packages back.

Because this command actually executes the dependency solver, it won’t report
the environment as out of date unless a package both has an available update
*and* can be updated while satisfying all the other dependencies’ version
constraints.
