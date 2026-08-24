# Contributing

## Adding a new skill

1. Create a folder: `skills/<skill-name>/`. Use kebab-case, and prefer a
   name specific enough to be self-explanatory in a flat directory listing
   (`nextjs-i18n`, not just `i18n`).
2. Add `SKILL.md` with YAML frontmatter:

   ```markdown
   ---
   name: skill-name
   description: >-
     One dense paragraph: when to use this skill, what it covers, and a
     "Triggers:" list of keywords/phrases that should surface it.
   ---

   # Skill title

   Body content.
   ```

   - `description` is what a model uses to decide relevance — write it for
     that, not for a human skimming a README. Include concrete trigger
     words, not just a category name.
   - Keep the body practical: concrete rules, code examples, a "where to
     look" section pointing at real file paths (or a placeholder pattern
     like `apps/web/src/...` when the skill is stack-specific but
     project-agnostic).

3. If the skill needs supporting files (a reference doc, a checklist,
   images), put them alongside `SKILL.md` in the same folder and link to
   them with a relative path.

## Generalizing a skill from a real project

Most skills here started life as a project-specific `.agents/skills/` or
`.claude/skills/` file. When porting one in:

- Strip client/project names, brand tokens, and business-specific paths.
  Replace concrete package names with a placeholder pattern
  (`@myorg/ui` instead of `@vidra/ui`) and note where the project should
  adjust it.
- Keep the underlying mechanics — the whole point is the pattern, not a
  sanitized restatement.
- Cross-check "Related skills" sections still point at names that exist in
  this repo, not the source project's names.
- Don't touch the source project. This repo is a read-and-generalize
  target, never a place you refactor the original from.

## Platform-paired skills (e.g. `nextjs-*` / `expo-*`)

When a concern exists on more than one stack (composition, i18n, design
system), prefer **separate, parallel-named skills** over one skill with
platform branches, unless the mechanics are genuinely identical. Two clear
skills beat one skill full of "if this platform, else that platform."

## Always-on rules vs. triggered skills

A skill should describe a process or judgment call the model applies when
relevant. A one-line constraint that should basically always apply when
writing user-facing copy (e.g. `copy-style`) still lives as a `SKILL.md`
here for portability, but keep it short and unconditional — don't pad a
simple rule into workflow-shaped prose just to match other skills' length.

## Checklist before opening a PR

- [ ] `SKILL.md` has valid YAML frontmatter with `name` and `description`
- [ ] No leftover client/project-specific names, URLs, or IDs
- [ ] Cross-references to other skills use this repo's actual folder names
- [ ] Added to the table in `README.md`
