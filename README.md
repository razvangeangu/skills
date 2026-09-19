# skills

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Skill count](https://img.shields.io/badge/skills-15-blue)
[![Lint](https://github.com/razvangeangu/skills/actions/workflows/lint.yml/badge.svg)](https://github.com/razvangeangu/skills/actions/workflows/lint.yml)

A personal, portable library of agent skills — conventions and workflows worth
reusing across projects, models, and coding harnesses.

## What is a skill?

A skill is a markdown file (`SKILL.md`) with a small YAML header —
`name` and `description` — followed by whatever guidance an AI coding agent
needs to do a specific job well: a checklist, a set of conventions, a
worked example, a list of things to avoid. The `description` field doubles
as the trigger: the harness uses it to decide whether a skill is relevant
to the current request, and loads the full body only when it is. That keeps
a large library cheap to keep around — nothing loads until it's needed.

Skills are **model-agnostic** and **harness-portable**. This repo's canonical
project install path is `.agents/skills/`. The same `SKILL.md` files work
unchanged in harnesses that already understand that layout; for harnesses
that expect a different folder, use a [port](ports/README.md).

## Layout

Flat directory, one skill per folder:

```
skills/<skill-name>/SKILL.md
```

Optional harness adapters live under [`ports/`](ports/README.md). Skill
bodies stay free of vendor-specific install paths.

Skills here are triggered, situational guidance (composition patterns,
distribution workflows, audit checklists). Small always-on constraints that
should apply every time regardless of context (e.g. copy style) are still
kept as compact skills rather than a separate rules mechanism, since this
repo has no runtime that distinguishes the two — but they're written short
and unconditional on purpose.

## Skills

| Skill | What it's for |
| --- | --- |
| [`repo-hygiene`](skills/repo-hygiene) | Definition-of-done checklist: lint/format, git hooks, documenting suppressions |
| [`copy-style`](skills/copy-style) | No Oxford comma, no em dash, in user-facing copy |
| [`no-code-comments`](skills/no-code-comments) | Never write explanatory code comments; prefer clear names |
| [`anti-vibe-ui`](skills/anti-vibe-ui) | Ban list + audit checklist against the AI-slop UI fingerprint |
| [`core-spec`](skills/core-spec) | Language-neutral SSOT: one-pagers, schemas, golden behavior recordings, manifest |
| [`ssot-dev-loop`](skills/ssot-dev-loop) | Mandatory process: core before UI, regenerate products, verify, then shell |
| [`parity-gates`](skills/parity-gates) | Local=CI verification; drift / empty-test / build-product discipline |
| [`feature-boundary`](skills/feature-boundary) | Strict core vs shell package rules (pure reducer, ports, no UI in core) |
| [`nextjs-app-router-composition`](skills/nextjs-app-router-composition) | Colocated route groups — `(components)`, `(hooks)`, `(constants)` — for thin App Router pages |
| [`nextjs-design-system`](skills/nextjs-design-system) | Tailwind + shadcn-based UI conventions, tokens, motion |
| [`nextjs-i18n`](skills/nextjs-i18n) | next-intl conventions for translatable copy |
| [`expo-router-composition`](skills/expo-router-composition) | Colocated components + `@/` imports for thin Expo Router screens |
| [`expo-i18n`](skills/expo-i18n) | react-i18next conventions for translatable copy |
| [`expo-shadcn-design-system`](skills/expo-shadcn-design-system) | Porting shadcn/ui components to React Native |
| [`expo-mobile-distribution`](skills/expo-mobile-distribution) | EAS build + Fastlane/eas submit → TestFlight/Play |

### SSOT / parity pack

`core-spec`, `ssot-dev-loop`, `parity-gates`, and `feature-boundary` are a
matched set: format → process → gates → package geometry. Use them together
when you want AI-assisted work to maintain a portable behavior kernel (any
host language) instead of drifting into UI-first edits. Generalized from
reducer-first / parity-corpus patterns; follow a project's own `AGENTS.md` +
`parity/` paths when present.

The `nextjs-*` and `expo-*` skills are deliberately parallel by concern
(composition / i18n / design-system) rather than merged — same naming
convention, separate files, because the underlying mechanics (route groups
vs plain folders, next-intl vs react-i18next, web shadcn vs RN-ported
shadcn) diverge enough that one branching doc would be worse than two clear
ones.

## Using a skill elsewhere

Canonical install (any harness that reads `.agents/skills/`):

```bash
./scripts/install-skill.sh repo-hygiene /path/to/project
# same as:
./scripts/install-skill.sh repo-hygiene /path/to/project --port agents
```

For harnesses that expect a different directory, pass a port (see
[ports/README.md](ports/README.md)):

```bash
./scripts/install-skill.sh repo-hygiene /path/to/project --port cursor
./scripts/install-skill.sh repo-hygiene /path/to/project --port claude
```

Or symlink by hand:

```bash
mkdir -p /path/to/project/.agents/skills
ln -s "$(pwd)/skills/repo-hygiene" /path/to/project/.agents/skills/repo-hygiene
```

Project agent front door: prefer a single `AGENTS.md` at the repo root. If a
harness only loads a vendor-named file, add a port shim (symlink) rather than
duplicating content — see [ports/README.md](ports/README.md).

## Contributing

Adding a skill or improving one? See [CONTRIBUTING.md](CONTRIBUTING.md) for
the format conventions and a pre-PR checklist. A GitHub Action lints every
`SKILL.md`'s frontmatter on push and PR.

## License

[MIT](LICENSE)
