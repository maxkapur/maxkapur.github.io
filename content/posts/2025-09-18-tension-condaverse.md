---
layout: post
title: Tensions rise in the condaverse
---

GitHub has a tool called Dependabot that automatically finds outdated package
versions pinned in project configuration files and issues a pull request to
update them. Support for conda `environment.yml` files has long been one of the
[most requested](https://github.com/dependabot/dependabot-core/issues/2227)
features in the Dependabot repo. At long last, GitHub has now added partial
support for conda to Dependabot, first as a
[beta announced last week](https://github.com/dependabot/dependabot-core/issues/2227#issuecomment-3274344175),
and now
[generally available](https://github.blog/changelog/2025-09-16-conda-ecosystem-support-for-dependabot-now-generally-available/).
But there have been some issues with the rollout.

The main appeal of conda over something like
[Poetry](https://python-poetry.org/), [uv](https://docs.astral.sh/uv/), or just
plain-old `requirements.txt` is that conda can manage arbitrary dependencies,
not just Python packages. You can
`conda create --no-default-packages git micro compilers` to set up a Fortran dev
environment if you want. Dependabot's conda support includes only Python
packages. A few folks grumbled about this limitation in the GitHub issue
comments, but it’s understandable: The space of "all conda installable packages"
is vast indeed, and the Dependabot devs had to start somewhere.

A more compelling criticism of the new feature stems from the fact that
Dependabot determines the latest versions of Python packages by looking up the
names given in `environment.yml` on PyPI. This is a problem because PyPI is an
entirely different package ecosystem from conda. Some package versions are
released on PyPI well before they appear in conda repos, and some packages have
different names between the two.

For a nasty example, [Ipopt](https://coin-or.github.io/Ipopt/) is a nonlinear
programming solver written in C, and
[cyipopt](https://cyipopt.readthedocs.io/en/stable/index.html) provides Python
bindings. `conda install ipopt` installs the C library, and
`conda install cyipopt` installs the Python wrapper. But `pip install ipopt`
actually refers to [cyipopt](https://pypi.org/project/ipopt/). The upshot, if I
understand correctly, is that if you pin `ipopt` in your `environment.yml`, then
Dependabot will check its version number against that of the latest version of
cyipopt, a flawed comparison.

Luckily, Ipopt/cyipopt is the only such case I could find in
[this Rosetta stone](https://github.com/regro/cf-graph-countyfair/blob/fd3061b427cc4b605d783ab40a115ff17e3dc1a7/mappings/pypi/grayskull_pypi_mapping.yaml)
(the fact that this exists …) mapping package names across ecosystems. But
[anyone(ish)](https://pypi.org/account/register/) can post packages on PyPI, so
the current behavior of Dependabot creates new opportunities for typo-squatting
attacks on conda users. As
[Jannis Leidel](https://github.com/dependabot/dependabot-core/issues/2227#issuecomment-3307935405)
(a conda maintainer) put it, “This premature rollout makes the conda ecosystem
less secure and shouldn't have occurred.”

I'm not sure what the right move is for Dependabot. For a start, they could use
the Rosetta stone to map conda packages to the correct PyPI names, but this
would only solve the naming issue, and not the possibility of different versions
between the two repositories.
