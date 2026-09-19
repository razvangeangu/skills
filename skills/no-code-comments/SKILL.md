---
name: no-code-comments
description: >-
  Always-on coding constraint: do not write code comments when adding or
  editing source. Prefer clear names and structure over explanation. Use
  whenever generating, refactoring, or reviewing code. Triggers: no comments,
  don't comment, never write comments, code comments, uncomment, remove
  comments, explanatory comments.
---

# No code comments

Do **not** write code comments. Not for explanation, narration, section
banners, TODOs, or "clarifying" intent. Name things so the code stands alone.

## Rules

- Do not add `//`, `/* */`, `#`, `--`, or `///` / `/**` comments in source you
  write or edit.
- Do not leave commented-out code.
- Prefer renaming, smaller functions, and types over a comment that restates
  the obvious.
- When editing existing files, do not add new comments. Leave existing
  comments untouched unless the user explicitly asks to remove them.

## Allowed exceptions (only these)

- Machine-required annotations the toolchain already uses (e.g. codegen
  markers, `sourcery:` / equivalent, eslint/ruff ignore directives with a
  required rationale form the project demands)
- Language or file-format necessities (shebang, SPDX/license header **only
  when the project template already requires that header**)
- Doc comments **only when the user explicitly asks** for public API docs

If unsure whether something is an exception, omit the comment.

## Related

Pairs with [`ssot-dev-loop`](../ssot-dev-loop): behavior belongs in the
core-spec and recordings, not in inline commentary.
