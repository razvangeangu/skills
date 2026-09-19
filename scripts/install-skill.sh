#!/usr/bin/env bash
# Install a skill into a project with one source of truth.
#
# Project SSOT:  <project>/.agents/skills/<skill-name>
# Other ports:   symlink → that .agents path (never a second copy)
# Library:       this repo's skills/<skill-name> (upstream when linking)
#
# Usage:
#   scripts/install-skill.sh <skill-name> <project-root> [options]
#
# Options:
#   --port agents|cursor|claude|all   default: agents
#   --mode link|copy                  default: link (copy is discouraged; see --i-know-copy-breaks-ssot)
#   --i-know-copy-breaks-ssot         required together with --mode copy
#   --from <path>                     override library skills root (default: this repo's skills/)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  cat >&2 <<'EOF'
Usage: scripts/install-skill.sh <skill-name> <project-root> [options]

  --port agents|cursor|claude|all   default: agents
  --mode link|copy                  default: link
  --i-know-copy-breaks-ssot         required for --mode copy
  --from <skills-root>              library folder containing <skill-name>/

One source of truth:
  - Always materializes .agents/skills/<name> first
  - cursor/claude ports symlink to ../../.agents/skills/<name> (relative)
  - Prefer --mode link so edits and upstream refreshes stay single-copy
EOF
  exit 1
}

relpath() {
  # relpath <from_dir> <to_abs_path> → relative path from from_dir to to_abs_path
  local from="$1" to="$2"
  python3 - "$from" "$to" <<'PY'
import os, sys
print(os.path.relpath(sys.argv[2], sys.argv[1]))
PY
}

ensure_not_diverged_copy() {
  local path="$1"
  if [[ -e "$path" && ! -L "$path" ]]; then
    echo "Refusing to replace a real directory (diverged copy?): $path" >&2
    echo "Remove it manually after confirming nothing unique lives there, then re-run." >&2
    exit 1
  fi
}

install_agents_ssot() {
  local dest="$AGENTS_SKILL"
  mkdir -p "$AGENTS_DIR"

  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest")"
    # Already a symlink — refresh if --mode link and source differs
    if [[ "$MODE" == "link" ]]; then
      rm -f "$dest"
    else
      echo "SSOT already present (symlink): $dest → $current" >&2
      return 0
    fi
  elif [[ -d "$dest" ]]; then
    if [[ "$MODE" == "copy" ]]; then
      echo "SSOT already a directory (copied earlier): $dest — leaving in place" >&2
      return 0
    fi
    echo "Refusing to overwrite existing directory SSOT: $dest" >&2
    echo "It is not a symlink. Convert manually or delete after review." >&2
    exit 1
  fi

  case "$MODE" in
    link)
      ln -s "$(relpath "$AGENTS_DIR" "$SRC")" "$dest"
      echo "SSOT linked: $dest → $(readlink "$dest")"
      ;;
    copy)
      cp -R "$SRC" "$dest"
      echo "SSOT copied (breaks single-copy refresh): $dest" >&2
      echo "Prefer reinstalling with --mode link when you can use symlinks." >&2
      ;;
  esac
}

install_harness_port() {
  local port="$1"
  local dest_dir dest
  case "$port" in
    cursor) dest_dir="$PROJECT_ROOT/.cursor/skills" ;;
    claude) dest_dir="$PROJECT_ROOT/.claude/skills" ;;
    *)
      echo "internal error: not a harness port: $port" >&2
      exit 1
      ;;
  esac
  dest="$dest_dir/$SKILL_NAME"
  mkdir -p "$dest_dir"

  if [[ ! -e "$AGENTS_SKILL" ]]; then
    echo "SSOT missing at $AGENTS_SKILL — install agents first (bug)" >&2
    exit 1
  fi

  ensure_not_diverged_copy "$dest"
  rm -f "$dest"
  # Relative link into project SSOT — portable across machines/checkouts
  ln -s "$(relpath "$dest_dir" "$AGENTS_SKILL")" "$dest"
  echo "Port $port linked: $dest → $(readlink "$dest")"
}

SKILL_NAME="${1:-}"
PROJECT_ROOT="${2:-}"
shift 2 || true

PORT="agents"
MODE="link"
COPY_ACK=""
FROM_ROOT="$ROOT/skills"

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
    --i-know-copy-breaks-ssot)
      COPY_ACK=1
      shift
      ;;
    --from)
      FROM_ROOT="${2:-}"
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

if [[ "$MODE" == "copy" && -z "$COPY_ACK" ]]; then
  echo "--mode copy duplicates files and breaks one-source-of-truth maintenance." >&2
  echo "Re-run with --i-know-copy-breaks-ssot if you truly cannot symlink." >&2
  exit 1
fi

if [[ "$MODE" != "link" && "$MODE" != "copy" ]]; then
  echo "Unknown mode: $MODE" >&2
  exit 1
fi

SRC="$FROM_ROOT/$SKILL_NAME"
if [[ ! -f "$SRC/SKILL.md" ]]; then
  echo "Skill not found: $SRC (expected SKILL.md)" >&2
  exit 1
fi
SRC="$(cd "$SRC" && pwd)"
PROJECT_ROOT="$(cd "$PROJECT_ROOT" && pwd)"

AGENTS_DIR="$PROJECT_ROOT/.agents/skills"
AGENTS_SKILL="$AGENTS_DIR/$SKILL_NAME"

case "$PORT" in
  agents)
    install_agents_ssot
    ;;
  cursor | claude)
    install_agents_ssot
    install_harness_port "$PORT"
    ;;
  all)
    install_agents_ssot
    install_harness_port cursor
    install_harness_port claude
    ;;
  *)
    echo "Unknown port: $PORT (expected agents|cursor|claude|all)" >&2
    echo "See ports/README.md" >&2
    exit 1
    ;;
esac
