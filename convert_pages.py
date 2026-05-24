from pathlib import Path

import saneyaml
import toml
import tomllib


def process(page: Path):
    if page.name == "_index.md":
        print(f"Skipping {page}")
        return

    print(f"Processing {page}")
    original_text = page.read_text()

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

    # Every page in the Jekyll site had a permalink so there's no default path
    # to alias
    d["aliases"] = d.get("aliases", [])
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
        page.write_text(output)


if __name__ == "__main__":
    pages = list(Path("./content/pages/").glob("**.md"))
    for page in pages:
        process(page)
