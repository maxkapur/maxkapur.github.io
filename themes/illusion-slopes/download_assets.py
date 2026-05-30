#!/usr/bin/env python
from io import BytesIO
from pathlib import Path
from zipfile import ZipFile

import requests
import tinycss2

assets_dir = Path(__file__).parent / "assets"


def main():
    ibm_plex_fonts()
    katex_css()


def ibm_plex_fonts():
    """Download/extract IBM Plex fonts from GitHub releases."""

    output_dir = assets_dir / "fonts"

    urls = {
        "ibm-plex-mono": "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip",
        "ibm-plex-math": "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-math%401.1.0/ibm-plex-math.zip",
        "ibm-plex-sans": "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip",
        "ibm-plex-sans-kr": "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-kr%401.1.0/ibm-plex-sans-kr.zip",
    }

    def should_extract(fname: str) -> bool:
        """Determine whether a file from the zip archive should be extracted."""
        # Plex CSS references both the .woff2 and .woff version of each font
        for suffix in [".css", ".woff2", ".woff"]:
            if fname.endswith(suffix):
                return True
        return False

    for font_name, url in urls.items():
        # Plex .zips have a top-level directory; we extract into just output_dir
        # to prevent double nesting but need the font name here to make sure we check
        # against the right font
        expected_outdir = output_dir / font_name

        if list(expected_outdir.glob("**/*.css")) and list(
            expected_outdir.glob("**/*.woff2")
        ):
            relpath = expected_outdir.relative_to(Path().absolute())
            print(f"{relpath} already looks good, skipping download")
            continue
        del expected_outdir  # Avoid misuse

        print(f"Downloading {font_name}.zip ...", end="")
        response = requests.get(url)
        assert response.ok
        print("OK")

        with BytesIO() as buffer:
            buffer.write(response.content)
            with ZipFile(buffer) as zipfile:
                fnames = [
                    fname for fname in zipfile.namelist() if should_extract(fname)
                ]
                if not fnames:
                    raise ValueError(f"No files to extract. {zipfile.namelist()=}")

                output_dir.mkdir(exist_ok=True, parents=True)
                zipfile.extractall(output_dir, fnames)

        for fname in fnames:
            outfile = output_dir / fname
            assert outfile.is_file()
            print(f"Extracted {outfile}")


def katex_css():
    """Download/extract `katex.css` and `katex-stripped.css` from GitHub.

    We only want the CSS: No JS because Hugo converts KaTeX to MathML as part of
    the site build, and no fonts because we replace them (in our CSS) with IBM
    Plex Math anyway. Thus, we postprocess `katex.css` into `katex-stripped.css`
    to remove all font declarations, which prevents a build error when Hugo
    cannot follow the path URLs pointing to KaTeX fonts.
    """
    url = "https://github.com/KaTeX/KaTeX/releases/download/v0.17.0/katex.zip"

    # katex.css as extracted from download
    katex_css_path = assets_dir / "katex" / "katex.css"

    # Postprocessed version with font declarations removed. If merged, https://github.com/KaTeX/KaTeX/issues/4119 will eliminate the need for this
    katex_stripped_css_path = assets_dir / "katex" / "katex-stripped.css"

    if katex_css_path.is_file() and katex_stripped_css_path.is_file():
        print(
            f"{katex_css_path.name} and {katex_stripped_css_path.name} already exist, nothing to do"
        )
        return
    print(f"Downloading {url} ...", end="")
    response = requests.get(url)
    assert response.ok
    print("OK")

    with BytesIO() as buffer:
        buffer.write(response.content)
        with ZipFile(buffer) as zipfile:
            # assets.mkdir(exist_ok=True, parents=True)
            zipfile.extractall(assets_dir, ["katex/katex.css"])

    assert katex_css_path.is_file()
    print(f"Extracted {katex_css_path}")

    rules = tinycss2.parse_stylesheet(katex_css_path.read_text())
    rules = [
        rule for rule in rules if not getattr(rule, "at_keyword", None) == "font-face"
    ]
    katex_stripped_css_path.write_text(tinycss2.serialize(rules))
    print(f"Extracted {katex_stripped_css_path}")


if __name__ == "__main__":
    main()
