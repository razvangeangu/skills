#!/usr/bin/env bash
# Install a skill from this repo into a project's harness skill directory.
#
# Usage:
#   scripts/install-skill.sh <skill-name> <project-root> [--port agents|cursor|claude] [--mode link|copy]
#
# Default port: agents  →  <project>/.agents/skills/<skill-name>
# Default mode: link    →  symlink into this repo's skills/<skill-name>

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  echo "Usage: scripts/install-skill.sh <skill-name> <project-root> [--port agents|cursor|claude] [--mode link|copy]" >&2
  exit 1
}

SKILL_NAME="${1:-}"
PROJECT_ROOT="${2:-}"
shift 2 || true

PORT="agents"
MODE="link"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --port)
      PORT="${2:-}"
      shift 2
      ;;
    --mode)
      MODE="${2:-}"
      shift 2
      ;;
    -h | --help)
      usage
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      ;;
  esac
done

if [[ -z "$SKILL_NAME" || -z "$PROJECT_ROOT" ]]; then
  usage
fi

SRC="$ROOT/skills/$SKILL_NAME"
if [[ ! -f "$SRC/SKILL.md" ]]; then
  echo "Skill not found: $SRC (expected SKILL.md)" >&2
  exit 1
fi

PROJECT_ROOT="$(cd "$PROJECT_ROOT" && pwd)"

case "$PORT" in
  agents)
    DEST_DIR="$PROJECT_ROOT/.agents/skills"
    ;;
  cursor)
    DEST_DIR="$PROJECT_ROOT/.cursor/skills"
    ;;
  claude)
    DEST_DIR="$PROJECT_ROOT/.claude/skills"
    ;;
  *)
    echo "Unknown port: $PORT (expected agents|cursor|claude)" >&2
    echo "See ports/README.md" >&2
    exit 1
    ;;
esac

DEST="$DEST_DIR/$SKILL_NAME"
mkdir -p "$DEST_DIR"

if [[ -e "$DEST" || -L "$DEST" ]]; then
  echo "Removing existing: $DEST"
  rm -rf "$DEST"
fi

case "$MODE" in
  link)
    ln -s "$SRC" "$DEST"
    echo "Linked $SKILL_NAME → $DEST (port=$PORT)"
    ;;
  copy)
    cp -R "$SRC" "$DEST"
    echo "Copied $SKILL_NAME → $DEST (port=$PORT)"
    ;;
  *)
    echo "Unknown mode: $MODE (expected link|copy)" >&2
    exit 1
    ;;
esac
