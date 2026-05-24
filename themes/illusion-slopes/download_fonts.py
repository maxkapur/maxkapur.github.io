#!/usr/bin/env python
from io import BytesIO
from pathlib import Path
from zipfile import ZipFile

import requests

output_dir = Path(__file__).parent / "static" / "fonts"

urls = {
    "ibm_plex_mono": "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip",
    "ibm_plex_math": "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-math%401.1.0/ibm-plex-math.zip",
    "ibm_plex_sans": "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip",
    "ibm_plex_sans_kr": "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-kr%401.1.0/ibm-plex-sans-kr.zip",
}


def should_extract(fname: str) -> bool:
    if fname.endswith(".min.css"):
        return True
    if fname.endswith(".woff2"):
        return True
    return False


def main():
    """Download/extract IBM Plex fonts from GitHub releases."""

    for font_name, url in urls.items():
        outdir = output_dir / font_name

        if list(outdir.glob("**/*.css")) and list(outdir.glob("**/*.woff2")):
            relpath = outdir.relative_to(Path().absolute())
            print(f"{relpath} already looks good, skipping download")
            continue

        response = requests.get(url)
        assert response.ok

        with BytesIO() as buffer:
            buffer.write(response.content)
            with ZipFile(buffer) as zipfile:
                fnames = [
                    fname for fname in zipfile.namelist() if should_extract(fname)
                ]
                if not fnames:
                    raise ValueError(f"No files to extract. {zipfile.namelist()=}")

                outdir.mkdir(exist_ok=True, parents=True)
                zipfile.extractall(outdir, fnames)

        for fname in fnames:
            outfile = outdir / fname
            assert outfile.is_file()
            print(f"Extracted {outfile}")


if __name__ == "__main__":
    main()
