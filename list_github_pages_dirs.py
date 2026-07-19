#!/usr/bin/env python
import requests

GH_USERNAME = "maxkapur"


def main():
    response = requests.get(f"https://api.github.com/users/{GH_USERNAME}/repos")
    pages_names = [entry["name"] for entry in response.json() if entry.get("has_pages")]
    pages_names.sort()
    print("\n".join(pages_names))


if __name__ == "__main__":
    main()
