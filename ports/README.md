# Harness ports

Skills in `skills/` are the **canonical** artifact: one `SKILL.md` format,
no vendor lock-in. The default project install path is:

```
.agents/skills/<skill-name>/
```

A **port** is only needed when a coding harness does not load that path by
default. Ports map the same skill folder into the harness's expected
location (usually a symlink). Prefer ports over rewriting skill bodies.

## Ports

| Port id | Install path | When to use |
| --- | --- | --- |
| `agents` (default) | `.agents/skills/<name>/` | Harnesses that already follow the Agents skill layout; also fine as a shared convention even if you also port elsewhere |
| `cursor` | `.cursor/skills/<name>/` | Cursor project skills |
| `claude` | `.claude/skills/<name>/` | Claude Code / Anthropic skill discovery |

Install via:

```bash
./scripts/install-skill.sh <skill-name> <project-root> --port <agents|cursor|claude>
```

Use `--mode copy` instead of the default `--mode link` when the target cannot
follow symlinks (rare; CI checkout mirrors, etc.).

### Installing several skills

```bash
for s in core-spec ssot-dev-loop parity-gates feature-boundary no-code-comments; do
  ./scripts/install-skill.sh "$s" /path/to/project --port agents
done
```

Install the same skill into more than one port when you use multiple harnesses
on one repo:

```bash
./scripts/install-skill.sh core-spec /path/to/project --port agents
./scripts/install-skill.sh core-spec /path/to/project --port cursor
```

## Agent front door (`AGENTS.md`)

Canonical project instructions live in **`AGENTS.md`** at the repo root.

Some harnesses still look for a vendor filename (e.g. `CLAUDE.md`). Do **not**
maintain two copies. Port with a symlink:

```bash
# from the project root, after AGENTS.md exists
ln -s AGENTS.md CLAUDE.md
```

Add further vendor names the same way. Skills that say "open `AGENTS.md`"
are correct for every harness; the symlink is the port.

## What does *not* belong in a port

- Rewriting skill prose to name a model vendor
- Duplicating checklists per harness
- Harness-specific business logic (that stays in the project)

If a harness needs a different *file format* (not just a different folder),
add a thin adapter under `ports/<port-id>/` that documents the transform —
keep the source of truth in `skills/`.

## Adding a port

1. Pick a short `port id` (kebab-case).
2. Document the install path in the table above.
3. Teach `scripts/install-skill.sh` the new `--port` value (one `case` arm).
4. Keep skill `SKILL.md` files free of that path — they should say
   `.agents/skills/` or "the project's skill directory" only when they must
   mention install location at all.
