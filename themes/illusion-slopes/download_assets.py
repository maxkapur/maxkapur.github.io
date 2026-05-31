#!/usr/bin/env python
from io import BytesIO
from pathlib import Path
from zipfile import ZipFile

import requests

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
    """Download/extract `katex.css` from GitHub release.

    We only want the CSS: No JS because Hugo converts KaTeX to MathML as part of
    the site build, and no fonts because we replace them (in our CSS) with IBM
    Plex Math anyway.
    """
    url = "https://github.com/KaTeX/KaTeX/releases/download/v0.17.0/katex.zip"

    if (
        list(assets_dir.glob("katex/katex.css"))
        and list(assets_dir.glob("katex/fonts/*.ttf"))
        and list(assets_dir.glob("katex/fonts/*.woff2"))
        and list(assets_dir.glob("katex/fonts/*.woff"))
    ):
        print("KaTeX files already look good, skipping download")
        return

    print(f"Downloading {url} ...", end="")
    response = requests.get(url)
    assert response.ok
    print("OK")

    def should_extract(fname: str) -> bool:
        """Determine whether a file from the zip archive should be extracted."""
        # Plex CSS references both the .woff2 and .woff version of each font
        for suffix in [".ttf", ".woff2", ".woff"]:
            if fname.endswith(suffix):
                return True
        if fname == "katex/katex.css":
            return True
        return False

    with BytesIO() as buffer:
        buffer.write(response.content)
        with ZipFile(buffer) as zipfile:
            fnames = [fname for fname in zipfile.namelist() if should_extract(fname)]
            if not fnames:
                raise ValueError(f"No files to extract. {zipfile.namelist()=}")
            zipfile.extractall(assets_dir, fnames)

    print("Extracted KaTeX CSS and fonts")


if __name__ == "__main__":
    main()
