#!/usr/bin/env bash
# Cut a new tagged release: validates skills, tags, pushes, and opens a
# GitHub Release with an auto-generated changelog.
#
# Usage: scripts/release.sh v0.2.0 ["Optional release title"]

set -euo pipefail

VERSION="${1:-}"
TITLE="${2:-$VERSION}"

if [[ -z "$VERSION" ]]; then
  echo "Usage: scripts/release.sh vX.Y.Z [\"Release title\"]" >&2
  exit 1
fi

if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Version must look like vX.Y.Z (got: $VERSION)" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree is not clean. Commit or stash changes first." >&2
  exit 1
fi

echo "Validating skill frontmatter..."
python3 scripts/lint-skills.py

echo "Tagging $VERSION..."
git tag -a "$VERSION" -m "$TITLE"
git push origin "$VERSION"

echo "Creating GitHub Release..."
gh release create "$VERSION" \
  --title "$TITLE" \
  --generate-notes

echo "Done: $VERSION released."
