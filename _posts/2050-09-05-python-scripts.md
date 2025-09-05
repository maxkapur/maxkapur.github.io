---
title: Python scripts
layout: post
---

I cleaned up a few utility Python scripts for the GitHub:

- [fetch_python_docs.py](https://github.com/maxkapur/fetch_python_docs.py) sets
  up a local mirror of [docs.python.org](https://docs.python.org/) on
  `http://localhost:8004` for offline reference. It can also provide and enable
  a systemd unit file, so you can run the script once, bookmark the local URL,
  and forget about it.
- [typography.py](https://github.com/maxkapur/typography.py) (which I mentioned
  [here]({% post_url 2025-07-02-tried-recently %})) checks for ASCII typography
  that can be better rendered as Unicode. For example, it recommends changing
  the hyphen in the page range `278-81` to an en dash.
- [dated.py](https://github.com/maxkapur/dated.py) applies my [obnoxious
  filename convention]({% post_url 2024-04-26-iso-dates-filenames %}) to create
  a dated working copy of a file—useful when collaborating with people who
  aren’t comfortable with version control systems.
