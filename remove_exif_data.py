#!/usr/bin/env python
"""t"""

import subprocess
import argparse
from pathlib import Path

import sys

DIR = Path(__file__).parent / "static"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    options = parser.parse_args()

    files = list(DIR.glob("**/*.jpg"))

    # https://exiftool.org/faq.html#Q32
    command = [
        "exiftool",
        "-ext",
        "jpg",
        "-all=",
        "--icc_profile:all",
        "-tagsfromfile",
        "@",
        "-colorspacetags",
        "-recurse",
    ]
    command += [str(path) for path in files]
    subprocess.run(command, check=True)

    altered_files = []
    maybe_originals = [path.parent / f"{path.name}_original" for path in files]
    for path, maybe_original in zip(files, maybe_originals, strict=True):
        maybe_original = path.parent / f"{path.name}_original"
        if not maybe_original.exists():
            continue
        need_to_delete = True
        before = maybe_original.read_bytes()
        after = path.read_bytes()
        # Sometimes exiftool writes a file even though no changes made. This
        # makes it unreliable, unfortunately, to only check if .jpg_original
        # exists or inspect the "n files unchanged" output of the tool itself.
        if before != after:
            altered_files.append(path)
            if options.dry_run:
                # Put the original back into place
                maybe_original.move(path)
                need_to_delete = False
        if need_to_delete:
            maybe_original.unlink()

    if not altered_files:
        sys.exit()

    msg = "Would remove" if options.dry_run else "Removed"
    sys.stderr.write(f"{msg} EXIF data from the following files:\n")
    sys.stderr.write("\n".join(str(path) for path in altered_files) + "\n")
    sys.exit(1)


if __name__ == "__main__":
    main()
