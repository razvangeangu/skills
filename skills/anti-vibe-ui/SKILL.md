---
name: anti-vibe-ui
description: >-
  Constrains and audits UI against the consensus AI-slop fingerprint (vibe-coded
  aesthetics). Use when building or polishing landing pages, marketing UI, or
  product chrome; when the user mentions vibe-coded, AI slop, anti-AI design,
  generic SaaS look, or asks to make a screen look less AI-generated. Companion
  to frontend-design: that skill picks a distinctive direction; this one kills
  default clusters and runs a pre-ship checklist.
---

# Anti-vibe UI

Stop shipping the statistical median of Tailwind + shadcn + Lucide + Framer demos. **Stack signs, never single ones**: one of Inter, Lucide, soft radius, or a purple brand color is fine; many unchosen defaults together is the fingerprint.

Companion to **frontend-design** (distinctive direction). This skill is the ban list + audit.

For the full catalog and false positives, read [reference.md](reference.md).

## Project override (do this first)

If the repo has a design-system skill or `AGENTS.md` that already fixes type, icons, or tokens (e.g. Lucide + Geist + Space Grotesk), **keep those**. Do not demand a font/icon swap. Break the rest of the cluster: color, layout, motion, copy, authenticity, and unmodified shadcn chrome.

## Modes

### Generate

Before writing UI:

1. Name the subject, audience, and the page’s one job.
2. Pick a visual direction that is not a known default cluster (see Hard bans and Second-wave defaults below).
3. Prefer real product UI, photography, or subject materials over decorative blobs.
4. After drafting, run the Audit checklist mentally and cut anything that only exists because models always emit it.

### Audit

Score an existing screen or diff. Report with this template:

```markdown
## Anti-vibe audit
**Cluster?** yes / no (≥3 Critical or ≥5 Contextual without brief justification)

### Critical
- …

### Contextual
- …

### Missing craft
- …

### Fixes (concrete)
- …
```

## Hard bans (do not ship unless the brief explicitly requires them)

- Purple / indigo / pink / rainbow / neon **gradient heroes**, gradient buttons, or **gradient text** (`bg-clip-text`)
- Decorative **aurora blobs**, **radio orbs**, **dot grids**, or glow blobs behind the hero
- **Emoji as UI chrome**; **Sparkles** (and the Lucide-five as decoration): Sparkles, Zap, Shield, Check, ArrowRight on every CTA
- **Liquid glass** / reflexive `backdrop-blur` with no overlay-on-image problem to solve
- **Colored left stripe** on cards (thick asymmetric accent border)
- Default **three equal feature cards** (icon + title + body, same height, `lg:grid-cols-3`)
- Uniform **fade-up on scroll** (`opacity: 0, y: 20` on every section)
- Uniform card hover: **`scale-105` + bigger shadow** on everything
- **Fake testimonials** (stock faces, invented titles, yellow five-star rows)
- Copy crutches: **em dashes** as clause breaks; **"it’s not X, it’s Y"**; vague “transform how you work”
- Pure **`#ffffff` / `#000000`** as the only atmosphere (no tint, texture, or subject image)
- Cookie-cutter page order with no hierarchy: hero → logo wall → 3 cards → testimonials → pricing → FAQ → 4-col footer

## Soft bans (justify against the brief, or skip)

- Bento grids used as default decoration
- Fake **terminal window** heroes (OK for real CLI products)
- Exactly **three pricing tiers** with middle “Most Popular” + checkmark filler
- Checkmark bullets as the only list pattern
- Soft **`rounded-2xl` + `shadow-md`** on every surface
- Hover animation for its own sake
- Decorative animated arrows
- Pastel / timid even-weight palettes with no committed accent
- Inter / Geist / Space Grotesk / Instrument Serif when **unchosen** (see project override)

## Second-wave defaults (also avoid as reflexes)

Models fled purple into new medians. Do not “fix” purple by landing on these without a brief:

- Warm cream (~`#F4F1EA`) + terracotta + oversized italic serif
- Near-black + single acid green / vermilion glow
- Broadsheet hairline / zero-radius newspaper columns applied to unrelated products
- Emerald (`#10B981`) as the automatic “not purple” accent
- Hero formula: eyebrow pill + huge H1 + dual CTA (“Get started” / “Learn more”)
- Decorative `01 / 02 / 03` markers
- Logo soup / fabricated “Trusted by”
- Implausible animated stat counters

## Required positives

- One subject-grounded visual anchor (real product, place, material, or atmosphere)
- Clear hierarchy: not three equal cards doing the same job
- Intentional type pairing **or** the project’s tokenized faces
- Async UI: skeletons or honest loading; real empty and error states
- `prefers-reduced-motion`, visible `:focus-visible`, non-default `::selection` when branding allows
- Public marketing surfaces: working **Privacy** and **Terms** (or equivalent) links; no fabricated trust badges

## Authenticity

- Prefer a real product screenshot or interactive demo over isometric filler
- No invented customers, counts, SOC badges, or press logos
- If you lack proof, cut the trust section rather than fabricating one

## Relationship to other skills

- **frontend-design**: choose a distinctive direction and signature; then pass this checklist
- **nextjs-design-system / nextjs-i18n / nextjs-app-router-composition** (web) and **expo-shadcn-design-system / expo-i18n / expo-router-composition** (mobile): win on stack and structure; this skill only strips vibe tells that those skills do not already own
- **copy-style**: align; never reintroduce em dashes or the Oxford comma in user-facing English
