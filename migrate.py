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

# Eager indicators that a page contains unmigrated Jekyll syntax. Exclude "{{%"
# and "{{<", which are Hugo markdown and standard shortcodes, respectively:
# https://gohugo.io/content-management/shortcodes/
jekyll_object_start = re.compile(r"{{[^%<]", re.MULTILINE)
jekyll_tag_start = re.compile(r"[^{]{%", re.MULTILINE)


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
        body = migrate_katex(body)
        assert "$$" not in body

    if (
        ("post_url" in body)
        or ("relative_url" in body)
        # False positive: meta post with relative_url in a code block/example
        and (path.name != "2024-12-26-server-side-katex.md")
    ):
        warnings.warn(f"{path} contains unmigrated Jekyll URL references")
        body = migrate_hrefs(body)
        assert ("post_url" not in body) and ("relative_url" not in body)

    if jekyll_object_start.search(body) or jekyll_tag_start.search(body):
        warnings.warn(f"{path} contains unmigrated Jekyll URL references")
        body = migrate_jekyll_syntax(body)
        attention_needed = True

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
    if "params" not in d:
        # Every post should have a params key to provide the id field
        d["params"] = {}

    # Construct aliases to maintain paths from Jekyll site
    if page_type == "page":
        # Every page in the Jekyll site had a permalink so there's no default
        # path to alias
        default_aliases = []
        # https://www.taguri.org/, note same form used in archetype
        id = f"tag:max@maxkapur.com,{date.today().isoformat()},pages:{d['title']}"
    elif page_type == "post":
        date_str = path.name[:10]
        slug = path.name[11:-3]  # strip date and ".md"
        assert date.fromisoformat(date_str)  # check format
        old_relpath = f"/{date_str.replace('-', '/')}/{slug}.html"
        default_aliases = [old_relpath]
        # This is the exact ID used in the old Atom feed: Absolute URL minus the
        # trailing .html. Bad, but we have to keep it
        id = f"https://maxkapur.com{old_relpath[:-5]}"
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

    if not d["params"].get("id"):
        d["params"]["id"] = id

    if "layout" in d:
        # Tech debt in Jekyll where I manually had to say every post was a post
        del d["layout"]

    # Handle custom keys

    # Used to have a KaTeX indicator to indicate whether the page has math on
    # it. Idea was that you could get faster page loads by skipping the KaTeX
    # CSS on pages that don't need it. But the *homepage* needs it, so there is
    # a good chance it's cached. Moreover, the key wasn't consistently, so just
    # drop it.
    if "katex" in d:
        del d["katex"]
    if "katex" in d.get("params", {}):
        del d["params"]["katex"]

    # Jekyll side used hidden key in a sort of overloaded way. For *posts,*
    # hidden suppressed inclusion on the homepage (but the post would still land
    # in Browse). Haven't decide how to implement this but for now, just move it
    # into params.
    if page_type == "post" and "hidden" in d:
        # Sanity check assumption that I only included this key if it was true
        assert d["hidden"]
        d["params"] = d.get("params", {}) | {"hidden": True}
        del d["hidden"]
    # For pages, hidden would suppress them from the top navigation. Hugo works
    # a little differently here: Inclusion is the marked case, not exclusion.
    # New site.Menus.main is autopopulated with a link to browse posts (and a
    # few others, see hugo.toml in the theme), then you add "main" to the menu
    # list for any content item that should be added to this menu.
    if page_type == "page" and (
        "menus" not in d  # Ensures idempotency
    ):
        was_hidden = False
        if "hidden" in d:
            assert d["hidden"]
            was_hidden = True
            del d["hidden"]
        if d.get("params", {}).get("hidden"):
            # Previous migration moved hidden key into params, before I understood hugo menus
            was_hidden = True
            del d["params"]["hidden"]

        if was_hidden:
            d["menus"] = []
        else:
            d["menus"] = ["main"]

    if sort_order := d.get("sort_order"):
        d["weight"] = int(sort_order)
        del d["sort_order"]


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
    r'<a\s+href="\{%\-?\s+post_url\s+(?P<slug>[0-9a-z\-]+?)\s+\-?%\}">(?P<disp>.*?)</a>',
    re.MULTILINE | re.DOTALL,
)

# example:
#
# [More sophisticated matching algorithms]({%- post_url 2021-03-07-stable-matching-planet-money -%})
jekyll_mdref = re.compile(
    # r"\[\s+(?P<disp>.*?)\s+\]\(\s+\{%\-?\s+post_url\s+(?P<slug>[0-9a-z\-]+?)\s+\-?%\}\s+\)",
    r"\[\s*(?P<disp>.*?)\s*\]\(\s*\{%\-?\s+post_url\s+(?P<slug>[0-9a-z\-]+?)\s+\-?%\}\s*\)",
    re.MULTILINE | re.DOTALL,
)


def hugo_post_href(slug: str, disp: str) -> str:
    # All post_urls point to posts as opposed to pages
    return f"[{disp.strip()}](/posts/{slug.strip()}/)"


def migrate_hrefs(body: str) -> str:
    body, _ = jekyll_href.subn(
        lambda m: hugo_post_href(m.group("slug"), m.group("disp")), body
    )
    body, _ = jekyll_mdref.subn(
        lambda m: hugo_post_href(m.group("slug"), m.group("disp")), body
    )
    return body


jekyll_site_url = re.compile(r"\{\{\s+site\.url\s+\}\}")
jekyll_site_email = re.compile(r"\{\{\s+site\.email\s+\}\}")
jekyll_site_github = re.compile(r"\{\{\s+site\.github\s+\}\}")
jekyll_site_linkedin_username = re.compile(r"\{\{\s+site\.linkedin_username\s+\}\}")


def migrate_jekyll_syntax(body: str) -> str:
    # Hardcode these for now. TODO: Develop shortcodes
    body, _ = jekyll_site_url.subn("https://maxkapur.com/", body)
    body, _ = jekyll_site_email.subn("max@maxkapur.com", body)
    body, _ = jekyll_site_github.subn("maxkapur", body)
    body, _ = jekyll_site_linkedin_username.subn("maxkapur", body)

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
