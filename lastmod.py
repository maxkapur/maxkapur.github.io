#!/usr/bin/env python
"""Output a `lastmod = ` timestamp for pasting into post metadata."""

import datetime as dt

if __name__ == "__main__":
    now = dt.datetime.now(dt.UTC)
    print(f"lastmod = {now.isoformat(timespec='seconds')}")
