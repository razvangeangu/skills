---
name: repo-hygiene
description: >-
  Use before claiming any repo work is complete: a definition-of-done checklist
  covering lint/format checks, git hooks (pre-commit + commit-msg), and how to
  document intentional lint suppressions. Triggers: done checklist, definition
  of done, lint, format, pre-commit, commit hooks, lefthook, commitlint, ready
  to commit, is this done.
---

# Repo hygiene — definition of done

Before claiming repo work is complete, run through this checklist. Adapt the
exact commands to whatever this project actually wires up (`npm run check`,
`make check`, `just check`, etc.) — the shape below is the pattern, not a
literal script name to assume exists.

## 1. Lint and format

Prefer a changed-files-only check when you only touched a few files, and a
full check before anything broader:

```bash
<pkg-manager> run check:changed   # scoped to touched files, if the project has it
# or
<pkg-manager> run check           # full repo check
```

If format checks fail, run the formatter and re-check rather than hand-fixing
formatting:

```bash
<pkg-manager> run format
<pkg-manager> run check
```

## 2. Git hooks (local)

Many repos wire local git hooks (e.g. via Lefthook) rather than relying only
on CI:

- **pre-commit** — formats staged files, then runs a scoped check
- **commit-msg** — a commit-message linter (e.g. commitlint) enforcing a
  type/scope convention (`feat:`, `fix:`, `docs:`, or project-specific scopes)

Skip a hook only when the human doing the commit explicitly intends to
(`git commit --no-verify`) — never reach for this as a default way past a
failing check.

## 3. Document intentional suppressions

If you disabled a lint rule or skipped a check on purpose, say why in the
commit message — don't leave a bare disable comment with no rationale.

If a project has both a CLI-facing lint config and an editor-extension config
for the same tool (e.g. a `.rumdl.toml` for the CLI/hooks and a
`.markdownlint.yaml` for an editor extension), check whether the CLI config
takes precedence and silently ignores the other — if so, keep both in sync
by hand.

## 4. Tooling reference (generalize to the project's actual stack)

| File type                | Formatter       | Linter              |
| ------------------------- | ---------------- | -------------------- |
| `.md`                     | e.g. `oxfmt`     | e.g. `rumdl`         |
| `.json`, `.yaml`, `.yml`  | e.g. `oxfmt`     | schema/shape checks if applicable |
| `.sh`                     | `shfmt`          | `shellcheck`         |
| `.py`                     | `ruff format`    | `ruff check`         |
| `.ts`, `.tsx`, `.js`      | project formatter | project linter (eslint/oxlint/biome) |

If a required binary is missing, run the project's setup script
(`npm run setup` or equivalent) before assuming the check is broken.

## 5. Schema/data validation (when relevant)

If the change touched structured data, schemas, or templates that have a
validator script, run it as part of "done" — don't rely solely on the
generic lint/format check to catch structural regressions in data files.
