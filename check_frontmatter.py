#!/usr/bin/env python
"""Check that frontmatter obeys my conventions."""

import csv
import re
import subprocess
from pathlib import Path

import toml


def main():
    res = subprocess.run(
        ["hugo", "list", "all"], capture_output=True, text=True, check=True
    )
    head, *body = csv.reader(res.stdout.split("\n"))

    exceptions = []
    exceptions.extend(check_date_slug_collisions(exceptions, head, body))

    if exceptions:
        raise ExceptionGroup("One or more frontmatter issues", exceptions)


class DateSlugConflictError(ValueError):
    pass


def check_date_slug_collisions(
    exceptions: list[Exception],
    head: list[str],
    body: list[list[str]],
):
    """Ensure no content gives slug and date via both filename and frontmatter.

    In my posts, the filename is Jekyll-style (2025-12-31-post-slug.md) and
    should split cleanly into a date and slug. Don't use a `date = ` frontmatter
    key with a datetime to try to control post sort order; use `weight = ` for
    that instead.

    Reference: https://github.com/gohugoio/hugo/issues/14971
    """

    pathcol = head.index("path")

    problematic = []
    for row in body:
        if not row:
            # Empty last row
            continue

        path = Path(row[pathcol])
        if path.name == "index.md":
            # Leaf bundle
            relevant_part = path.parts[-2]
        else:
            # Normal page
            relevant_part = path.name

        if not re.match(r"\d{4}\-\d{2}\-\d{2}", relevant_part):
            # Not a Jekyll-style filename, irrelevant
            continue

        frontmatter_s = path.read_text().split("+++", maxsplit=3)[1]
        frontmatter = toml.loads(frontmatter_s)
        if "date" in frontmatter or "slug" in frontmatter:
            problematic.append(row)

    return [DateSlugConflictError(row[pathcol]) for row in problematic]


if __name__ == "__main__":
    main()
