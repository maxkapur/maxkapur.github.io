from datetime import date
from pathlib import Path

import saneyaml
import toml
import tomllib


def process(path: Path):
    if path.parts[1] == "pages":
        page_type = "page"
    elif path.parts[1] == "posts":
        page_type = "post"
    else:
        raise ValueError

    if path.name == "_index.md":
        print(f"Skipping {path}")
        return

    print(f"Processing {path}")
    original_text = path.read_text()

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

    frontmatter = toml.dumps(d)
    body = body.strip()
    output = f"+++\n{frontmatter}+++\n\n{body}"
    if output != original_text:
        path.write_text(output)


if __name__ == "__main__":
    pages = list(Path("./content/pages/").glob("**.md")) + list(
        Path("./content/posts/").glob("**.md")
    )
    for page in pages:
        process(page)
