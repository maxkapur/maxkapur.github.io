#!/usr/bin/env python
"""Jekyll migration script.

This script tries to automate the migration of posts from the Jekyll version
of the site, flagging areas that need manual attention manually.

Workflow is to manually copy all the top level pages (`about.md` etc.) from
Jekyll into `content/pages/`, and all the posts (`_posts/*.md`) into
`content/posts/`, commit, then run this script and examine the diff.
"""

import re
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

    if "$$" in body:
        assert d["params"]["katex"]
        body = migrate_katex(body)
        assert "$$" not in body

    if "post_url" or "relative_url" in body:
        warnings.warn(f"{path} contains unmigrated Jekyll URL references")
        body = migrate_hrefs(body)

    output = f"+++\n{frontmatter}+++\n\n{body}\n"
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


display_math = re.compile(
    r"(\r?\n)+\r?\n\$\$(?P<expr>(?:(?!\r?\n\r?\n).)*?)\$\$(\r?\n)+\r?\n",
    re.MULTILINE | re.DOTALL,
)
inline_math = re.compile(
    r"\$\$(?P<expr>(?:(?!\r?\n\r?\n).)*?)\$\$",
    re.MULTILINE | re.DOTALL,  # Even inline needs DOTALL due to line wrapping
)


def display_shortcode(expr: str) -> str:
    return "\n\n{{< math >}}\n" + expr.strip() + "\n{{< /math >}}\n\n"


def inline_shortcode(expr: str) -> str:
    # For inline math (only), collapse whitespace since Hugo shortcodes
    # don't support multiline strings
    return '{{< math "' + re.subn(r"\n+", " ", expr.strip())[0] + '" />}}'


def migrate_katex(body: str) -> str:
    """Replace old KaTeX delimiters with new shortcode."""

    after = body
    while True:
        # Make replacements one at a time to prevent overlap since delims are
        # symmetric
        before = after

        # Eagerly match display math since its pattern is a superset of inline
        after = display_math.sub(lambda m: display_shortcode(m.group("expr")), before)
        if after != before:
            continue

        after = inline_math.sub(lambda m: inline_shortcode(m.group("expr")), before)
        if after != before:
            continue

        return after


# example:
#
# <a href="{% post_url 2018-08-25-a-thing-here %}">Things that are a thing
# here</a>
jekyll_href = re.compile(
    # r'<a\s+href="(?P<slug>.*?)">(?P<disp>.*?)</a>',
    r'<a\s+href="\{%\-?\s+post_url\s+(?P<slug>[0-9a-z\-]+?)\s+\-?%\}">(?P<disp>.*?)</a>',
    re.MULTILINE | re.DOTALL,
)


def hugo_post_href(slug: str, disp: str) -> str:
    # All post_urls point to posts as opposed to pages
    return f"[{disp.strip()}](/posts/{slug.strip()}/)"


def migrate_hrefs(body: str) -> str:
    body, _ = jekyll_href.subn(
        lambda m: hugo_post_href(m.group("slug"), m.group("disp")), body
    )
    return body


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
