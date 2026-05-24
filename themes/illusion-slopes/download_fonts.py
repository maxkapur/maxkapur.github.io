#!/usr/bin/env python
from io import BytesIO
from pathlib import Path
from zipfile import ZipFile

import requests

output_dir = Path(__file__).parent / "assets" / "fonts"

urls = {
    "ibm-plex-mono": "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip",
    "ibm-plex-math": "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-math%401.1.0/ibm-plex-math.zip",
    "ibm-plex-sans": "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip",
    "ibm-plex-sans-kr": "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-kr%401.1.0/ibm-plex-sans-kr.zip",
}


def should_extract(fname: str) -> bool:
    """Determine whether a file from the zip archive should be extracted."""
    # Plex CSS references both the .woff2 and .woff version of each font
    for suffix in [".min.css", ".woff2", ".woff"]:
        if fname.endswith(suffix):
            return True
    return False


def main():
    """Download/extract IBM Plex fonts from GitHub releases."""

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


if __name__ == "__main__":
    main()
