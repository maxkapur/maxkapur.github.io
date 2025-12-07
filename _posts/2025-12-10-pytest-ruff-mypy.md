---
title: Pytest + Ruff + Mypy
layout: post
---

There is a [pytest-ruff](https://pypi.org/project/pytest-ruff/) plugin for
Pytest (a Python testing framework) that will automatically run
`ruff format --check` and `ruff check` as part of your test suite. The
[pytest-mypy](https://pypi.org/project/pytest-mypy/) plugin does the same thing
for Mypy. These plugins are handy, but for some reason , the tests they generate
are exempted from the `pytest -k ...` logic. Normally, you can use `-k` to
select a subset of tests to run, but if you install one of the plugins
mentioned, that plugin's tests run no matter what. This can slow you down if,
like me, you develop on a slow computer.

So, here's what I use instead of pytest-ruff and pytest-mypy: A humble
`test/test_qa.py` file with three functions.

```python
import subprocess
import sys
from pathlib import Path

import mypy.api

REPO_ROOT = Path(__file__).parent.parent


def test_mypy():
    stdout, stderr, returncode = mypy.api.run([str(REPO_ROOT)])
    sys.stdout.write(stdout)
    sys.stderr.write(stderr)
    assert returncode == 0


def test_ruff_format():
    subprocess.run(
        [sys.executable, "-m", "ruff", "format", "--check"],
        cwd=REPO_ROOT,
        check=True,
    )


def test_ruff_lint():
    subprocess.run(
        [sys.executable, "-m", "ruff", "check"],
        cwd=REPO_ROOT,
        check=True,
    )
```

(I run Mypy via its Python API instead of the command line to save a tiny bit of
`subprocess.run()` overhead, but it doesn't make a massive difference.)

This gets you all the functionality of the plugins, but with two fewer
dependencies, and the `-k` flag works:

```shell
# Run tests for an in-progress feature and skip QA
pytest -k test_some_feature

# Run only the QA tests
pytest -k test_qa

# Run all tests
pytest
```
