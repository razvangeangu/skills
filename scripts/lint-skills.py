#!/usr/bin/env python3
"""Validate every skills/<name>/SKILL.md has well-formed frontmatter."""

import glob
import re
import sys

REQUIRED_KEYS = ("name", "description")


def parse_frontmatter(text):
    match = re.match(r"^---\n(.*?)\n---\n", text, re.DOTALL)
    if not match:
        return None
    return match.group(1)


def check_file(path):
    errors = []
    with open(path, encoding="utf-8") as f:
        text = f.read()

    frontmatter = parse_frontmatter(text)
    if frontmatter is None:
        return [f"{path}: missing YAML frontmatter (--- ... ---) at top of file"]

    for key in REQUIRED_KEYS:
        if not re.search(rf"^{key}:\s*\S", frontmatter, re.MULTILINE):
            errors.append(f"{path}: frontmatter missing required key '{key}'")

    name_match = re.search(r"^name:\s*(\S+)", frontmatter, re.MULTILINE)
    if name_match:
        folder = path.split("/")[-2]
        if name_match.group(1) != folder:
            errors.append(
                f"{path}: frontmatter name '{name_match.group(1)}' "
                f"does not match folder name '{folder}'"
            )

    return errors


def main():
    files = sorted(glob.glob("skills/*/SKILL.md"))
    if not files:
        print("No skills/*/SKILL.md files found.")
        sys.exit(1)

    all_errors = []
    for path in files:
        all_errors.extend(check_file(path))

    if all_errors:
        print(f"Found {len(all_errors)} issue(s):\n")
        for e in all_errors:
            print(f"  - {e}")
        sys.exit(1)

    print(f"OK: {len(files)} skill(s) validated.")


if __name__ == "__main__":
    main()
