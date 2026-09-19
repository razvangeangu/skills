#!/usr/bin/env bash
# Verify a project's harness skill installs keep one source of truth.
#
# Rules:
#   - Canonical path: <project>/.agents/skills/<name>
#   - .cursor/skills/<name> and .claude/skills/<name>, if present, must be
#     symlinks that resolve to the same path as .agents/skills/<name>
#   - Real directories under cursor/claude skill trees are errors (diverged copies)
#
# Usage:
#   scripts/verify-ports.sh <project-root>
#   scripts/verify-ports.sh <project-root> --strict   # also require every
#       cursor/claude entry to have a matching .agents SSOT entry

set -euo pipefail

PROJECT_ROOT="${1:-}"
STRICT=""
shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict) STRICT=1; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$PROJECT_ROOT" ]]; then
  echo "Usage: scripts/verify-ports.sh <project-root> [--strict]" >&2
  exit 1
fi

PROJECT_ROOT="$(cd "$PROJECT_ROOT" && pwd)"
AGENTS="$PROJECT_ROOT/.agents/skills"
ERRORS=0

resolve() {
  python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$1"
}

check_port_tree() {
  local label="$1" tree="$2"
  [[ -d "$tree" ]] || return 0

  local entry name agents_entry
  shopt -s nullglob
  for entry in "$tree"/*; do
    name="$(basename "$entry")"
    [[ "$name" == .* ]] && continue
    agents_entry="$AGENTS/$name"

    if [[ ! -L "$entry" && -d "$entry" ]]; then
      echo "ERROR [$label]: $entry is a real directory (diverged copy). Replace with a symlink to .agents/skills/$name" >&2
      ERRORS=$((ERRORS + 1))
      continue
    fi

    if [[ ! -e "$agents_entry" ]]; then
      if [[ -n "$STRICT" ]]; then
        echo "ERROR [$label]: $entry has no SSOT at $agents_entry" >&2
        ERRORS=$((ERRORS + 1))
      else
        echo "WARN [$label]: $entry has no SSOT at $agents_entry" >&2
      fi
      continue
    fi

    if [[ "$(resolve "$entry")" != "$(resolve "$agents_entry")" ]]; then
      echo "ERROR [$label]: $entry resolves to $(resolve "$entry")" >&2
      echo "       expected same as SSOT $(resolve "$agents_entry")" >&2
      ERRORS=$((ERRORS + 1))
    fi
  done
  shopt -u nullglob
}

if [[ ! -d "$AGENTS" ]]; then
  echo "WARN: no project SSOT directory at $AGENTS" >&2
fi

check_port_tree "cursor" "$PROJECT_ROOT/.cursor/skills"
check_port_tree "claude" "$PROJECT_ROOT/.claude/skills"

# Also flag accidental real dirs under .agents that look like accidental
# copies when a sibling port exists — soft check only via listing.
if [[ -d "$AGENTS" ]]; then
  echo "SSOT skills:"
  shopt -s nullglob
  for entry in "$AGENTS"/*; do
    name="$(basename "$entry")"
    if [[ -L "$entry" ]]; then
      echo "  $name → $(readlink "$entry")"
    elif [[ -d "$entry" ]]; then
      echo "  $name (directory — ok if vendored; prefer symlink to library for refresh)"
    fi
  done
  shopt -u nullglob
fi

if [[ "$ERRORS" -gt 0 ]]; then
  echo "verify-ports: $ERRORS error(s)" >&2
  exit 1
fi
echo "verify-ports: ok"
