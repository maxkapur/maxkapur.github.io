import warnings
from datetime import date
from pathlib import Path

import saneyaml
import toml
import tomllib


def process(path: Path) -> tuple[bool, bool]:
    """Migrate a page or post.

    Return whether anything changed and whether manual attention needed.
    """
    attention_needed = False
    if path.parts[1] == "pages":
        page_type = "page"
    elif path.parts[1] == "posts":
        page_type = "post"
    else:
        raise ValueError

    if path.name == "_index.md":
        print(f"Skipping {path}")
        return False, attention_needed

    print(f"Processing {path}")
    original_text = path.read_text()

    d, body = extract_parts(original_text)
    migrate_frontmatter_keys(path, page_type, d)

    frontmatter = toml.dumps(d)
    body = body.strip()

    katex_detected = "$$" in body
    assert katex_detected == d.get("params", {}).get("katex", False)
    if katex_detected:
        warnings.warn(f"{path} has unmigrated KaTeX delimiters")
        attention_needed = True

    output = f"+++\n{frontmatter}+++\n\n{body}"
    if output != original_text:
        path.write_text(output)
        return True, attention_needed
    return False, attention_needed


def extract_parts(original_text: str) -> tuple[dict, str]:
    """Extract the dictionary of frontmatter data and the body."""

    if original_text.strip().startswith("---"):
        print("yaml frontmatter")
        _, frontmatter, body = original_text.split("---", maxsplit=2)
        d = saneyaml.load(frontmatter)
    elif original_text.strip().startswith("+++"):
        print("toml frontmatter")
        _, frontmatter, body = original_text.split("+++", maxsplit=2)
        d = tomllib.loads(frontmatter)
    else:
        print("no frontmatter")
        body = original_text
        d = {}

    return d, body


def migrate_frontmatter_keys(path: Path, page_type: str, d: dict):
    """Migrate the frontmatter keys dictionary `d`, in place."""
    # Construct aliases to maintain paths from Jekyll site
    if page_type == "page":
        # Every page in the Jekyll site had a permalink so there's no default
        # path to alias
        default_aliases = []
    elif page_type == "post":
        date_str = path.name[:10]
        slug = path.name[11:-3]  # strip date and ".md"
        assert date.fromisoformat(date_str)  # check format
        default_aliases = [f"/{date_str.replace('-', '/')}/{slug}.html"]
    else:
        raise ValueError

    d["aliases"] = d.get("aliases", default_aliases)
    if permalink := d.get("permalink"):
        # Jekyll permalink
        d["aliases"].append(permalink)
        del d["permalink"]
    if redirects := d.get("redirect_from"):
        d["aliases"].extend(redirects)
        del d["redirect_from"]

    if "layout" in d:
        # Tech debt in Jekyll where I manually had to say every post was a post
        del d["layout"]

    # Move custom keys into params
    if "katex" in d:
        # Sanity check assumption that I only included this key if it was true
        assert d["katex"]

        # Indicates whether the page has math on it. Idea was that you could
        # get faster page loads by skipping the KaTeX CSS on pages that don't
        # need it. But the *homepage* needs it, so there is a good change it's
        # cached and this doesn't really matter
        d["params"] = d.get("params", {}) | {"katex": True}
        del d["katex"]

    if "hidden" in d:
        # Sanity check assumption that I only included this key if it was true
        assert d["hidden"]
        d["params"] = d.get("params", {}) | {"hidden": True}
        del d["hidden"]


if __name__ == "__main__":
    change_detected = False
    attention_needed = False
    pages = list(Path("./content/pages/").glob("**.md")) + list(
        Path("./content/posts/").glob("**.md")
    )
    for page in pages:
        change_detected_page, attention_needed_page = process(page)
        change_detected |= change_detected_page
        attention_needed |= attention_needed_page

    if change_detected or attention_needed:
        warnings.warn("Migrations needed; see diff")
        exit(1)
