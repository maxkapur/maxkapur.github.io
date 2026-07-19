#!/usr/bin/env python
"""Check that Hugo build is free of collisions with reserved GitHub Pages paths.

The main site is hosted at `maxkapur.com` via GitHub Pages, but I also have Pages
set up for other repos, which automatically get mapped to paths like
`maxkapur.com/jekyll-related`.

This script queries the GitHub API to get any repos that have Pages configured,
then checks that the site build doesn't have any content at the corresponding
paths.
"""

import argparse
from pathlib import Path

import requests

GH_USERNAME = "maxkapur"


def main():
    hugo_build_dir = get_build_dir()
    if not (sentinel := hugo_build_dir / "index.html").exists():
        raise FileNotFoundError(sentinel)

    print("Querying GitHub API for reserved paths")
    response = requests.get(f"https://api.github.com/users/{GH_USERNAME}/repos")
    pages_names = [entry["name"] for entry in response.json() if entry.get("has_pages")]

    print(
        f"Checking build at {hugo_build_dir} against {len(pages_names)} reserved paths"
    )
    for name in pages_names:
        if (directory := hugo_build_dir / name).exists():
            raise IsADirectoryError(directory)
        print(f"Reserved path {directory} does not exist")


def get_build_dir():
    parser = argparse.ArgumentParser()
    parser.add_argument("--build-dir", default=Path(__file__).parent / "public")
    return Path(parser.parse_args().build_dir)


if __name__ == "__main__":
    main()
