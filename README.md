# skills

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Skill count](https://img.shields.io/badge/skills-10-blue)
[![Lint](https://github.com/razvangeangu/skills/actions/workflows/lint.yml/badge.svg)](https://github.com/razvangeangu/skills/actions/workflows/lint.yml)

A personal, portable library of [Claude Code](https://claude.com/claude-code)
skills — conventions and workflows worth reusing across projects, at work,
or sharing with other devs.

## What is a skill?

A skill is a markdown file (`SKILL.md`) with a small YAML header —
`name` and `description` — followed by whatever guidance an AI coding agent
needs to do a specific job well: a checklist, a set of conventions, a
worked example, a list of things to avoid. The `description` field doubles
as the trigger: Claude Code reads it to decide whether a skill is relevant
to what you're currently asking for, and pulls in the full body only when
it is. That keeps a large library of skills cheap to keep around — nothing
loads until it's actually needed.

Skills are portable by design. The same `SKILL.md` format works whether
it's sitting in this repo, in a project's `.claude/skills/`, or in a
project's `.agents/skills/` — see [Using a skill elsewhere](#using-a-skill-elsewhere)
below.

## Layout

Flat directory, one skill per folder:

```
skills/<skill-name>/SKILL.md
```

Each `SKILL.md` uses the standard skill format: YAML frontmatter (`name`,
`description`) followed by a markdown body. This is the same format Claude
Code reads from `.claude/skills/` and the `npx skills` CLI reads from its
own registry — a skill here can be copied or symlinked straight into any
project's `.claude/skills/` (or `.agents/skills/`) without conversion.

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
| [`anti-vibe-ui`](skills/anti-vibe-ui) | Ban list + audit checklist against the AI-slop UI fingerprint |
| [`nextjs-app-router-composition`](skills/nextjs-app-router-composition) | Colocated route groups — `(components)`, `(hooks)`, `(constants)` — for thin App Router pages |
| [`nextjs-design-system`](skills/nextjs-design-system) | Tailwind + shadcn-based UI conventions, tokens, motion |
| [`nextjs-i18n`](skills/nextjs-i18n) | next-intl conventions for translatable copy |
| [`expo-router-composition`](skills/expo-router-composition) | Colocated components + `@/` imports for thin Expo Router screens |
| [`expo-i18n`](skills/expo-i18n) | react-i18next conventions for translatable copy |
| [`expo-shadcn-design-system`](skills/expo-shadcn-design-system) | Porting shadcn/ui components to React Native |
| [`expo-mobile-distribution`](skills/expo-mobile-distribution) | EAS build + Fastlane/eas submit → TestFlight/Play |

The `nextjs-*` and `expo-*` skills are deliberately parallel by concern
(composition / i18n / design-system) rather than merged — same naming
convention, separate files, because the underlying mechanics (route groups
vs plain folders, next-intl vs react-i18next, web shadcn vs RN-ported
shadcn) diverge enough that one branching doc would be worse than two clear
ones.

## Using a skill elsewhere

Copy or symlink the folder into the target project:

```bash
cp -r skills/repo-hygiene /path/to/project/.claude/skills/
# or
ln -s "$(pwd)/skills/repo-hygiene" /path/to/project/.claude/skills/repo-hygiene
```

## Contributing

Adding a skill or improving one? See [CONTRIBUTING.md](CONTRIBUTING.md) for
the format conventions and a pre-PR checklist. A GitHub Action lints every
`SKILL.md`'s frontmatter on push and PR.

## License

[MIT](LICENSE)
