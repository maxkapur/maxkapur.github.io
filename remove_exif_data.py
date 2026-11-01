#!/usr/bin/env python
"""Remove EXIF data from JPG images.

Use the default options recommended in the `exiftool` FAQ:
https://exiftool.org/faq.html#Q32
"""

import argparse
import subprocess
import sys
from hashlib import file_digest
from pathlib import Path
from tempfile import TemporaryDirectory

DIR = Path(__file__).parent / "static"
"Directory to glob for .jpg images."


def main():
    options = get_options()

    # Put temp directory adjacent to DIR to avoid cross-filesystem issues with
    # Nix store and path.replace().
    with TemporaryDirectory(dir=DIR.parent) as td:
        working_directory = Path(td)
        cloned_paths = []
        before_checksums = []
        for path in DIR.glob("**/*.jpg"):
            dest = working_directory / path.relative_to(DIR)
            dest.parent.mkdir(parents=True, exist_ok=True)
            path.copy(dest)
            cloned_paths.append(dest)

        if not cloned_paths:
            sys.stderr.write(f"No .jpg files found in {DIR!s}\n")
            sys.exit(1)

        before_checksums = [checksum(path) for path in cloned_paths]

        command = [
            "exiftool",
            "-ext",
            "jpg",
            "-all=",
            "--icc_profile:all",
            "-tagsfromfile",
            "@",
            "-colorspacetags",
            "-overwrite_original",
        ]
        command += [str(path) for path in cloned_paths]
        subprocess.run(command, check=True)

        after_checksums = [checksum(path) for path in cloned_paths]

        altered_paths: list[Path] = [
            path
            for path, before, after in zip(
                cloned_paths, before_checksums, after_checksums, strict=True
            )
            if before != after
        ]

        if not altered_paths:
            return

        if not options.dry_run:
            for path in altered_paths:
                path.replace(DIR / path.relative_to(working_directory))

    msg = "Would update" if options.dry_run else "Updated"
    sys.stderr.write(f"{msg} the following files to remove EXIF data:\n")
    sys.stderr.write("\n".join(str(path) for path in altered_paths) + "\n")
    sys.exit(1)


def get_options():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def checksum(path: Path) -> str:
    with open(path, "rb") as f:
        return file_digest(f, "sha1").hexdigest()


if __name__ == "__main__":
    main()
