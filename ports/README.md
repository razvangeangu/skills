# Harness ports

Skills in `skills/` are the **upstream** artifact in this library. In a
**project**, one path is the source of truth; other harness folders are ports
onto that path — symlinks, never copies.

```
this-repo/skills/<name>/          # upstream library
        │  (symlink, --mode link)
        ▼
project/.agents/skills/<name>/    # PROJECT SSOT — only real install
        ▲
        ├── .cursor/skills/<name> ──┘  relative symlink
        └── .claude/skills/<name> ──┘  relative symlink
```

Edit or refresh the skill once under `.agents/skills/`. Every harness that
follows a port sees the same bytes. Do not maintain parallel trees.

## Ports

| Port id | Path | Role |
| --- | --- | --- |
| `agents` (default) | `.agents/skills/<name>/` | Project SSOT |
| `cursor` | `.cursor/skills/<name>/` | Symlink → `.agents/skills/<name>` |
| `claude` | `.claude/skills/<name>/` | Symlink → `.agents/skills/<name>` |
| `all` | agents + cursor + claude | One command, still one SSOT |

```bash
# Install / refresh project SSOT from this library
./scripts/install-skill.sh repo-hygiene /path/to/project

# Also expose to Cursor (still one copy — agents is SSOT)
./scripts/install-skill.sh repo-hygiene /path/to/project --port cursor

# Every supported harness port
./scripts/install-skill.sh core-spec /path/to/project --port all
```

`--mode link` is the default and the supported maintenance model.

`--mode copy` requires `--i-know-copy-breaks-ssot`. It freezes a duplicate and
will drift; only use it when the environment cannot follow symlinks. Prefer
fixing the environment.

### Verify

```bash
./scripts/verify-ports.sh /path/to/project
./scripts/verify-ports.sh /path/to/project --strict
```

Fails if `.cursor/skills/*` or `.claude/skills/*` is a real directory, or if a
port symlink resolves to a different path than `.agents/skills/<name>`.

### Pack example

```bash
for s in core-spec ssot-dev-loop parity-gates feature-boundary no-code-comments; do
  ./scripts/install-skill.sh "$s" /path/to/project --port all
done
./scripts/verify-ports.sh /path/to/project --strict
```

## Agent front door (`AGENTS.md`)

Canonical project instructions: **`AGENTS.md`** at the repo root.

Harnesses that only load a vendor filename get a symlink port — same rule as
skills:

```bash
ln -s AGENTS.md CLAUDE.md
```

Never duplicate the file body.

## What does *not* belong in a port

- A second copy of a skill tree
- Rewriting skill prose for a vendor
- Harness-specific business logic (stays in the project)

If a harness needs a different *file format* (not just a different folder),
document a transform under `ports/<port-id>/` — generated output must be
reproducible from `skills/` and checked by a verify step. Prefer not to need
this.

## Adding a port

1. Pick a short `port id` (kebab-case).
2. Document it in the table above as **symlink → `.agents/skills/`**.
3. Teach `scripts/install-skill.sh` (always ensure agents SSOT first).
4. Extend `scripts/verify-ports.sh` so diverged copies fail CI/local checks.
5. Keep skill bodies free of vendor install paths.
