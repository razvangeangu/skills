---
name: core-spec
description: >-
  Defines and maintains a language-neutral single source of truth for product
  behavior: feature one-pagers, serializable State/Action/Effect schemas, golden
  behavior recordings, and a manifest. Use when designing shared memory across
  platforms, porting a feature to another language, authoring or changing core
  business logic, or when the user mentions core spec, SSOT, parity fixtures,
  behavior recordings, portable kernel, or single source of truth. Triggers:
  core-spec, feature one-pager, golden fixtures, behavior recordings, portable
  kernel, shared memory, multi-platform SoT, language-neutral spec.
---

# Core spec — language-neutral source of truth

Build and keep a **portable kernel** the LLM can read and a toolchain can
verify. Host UI (SwiftUI, Compose, React, etc.) is a projection — never the
source of truth.

For the full format, templates, and JSON Schema shapes, read
[format.md](format.md) and [template.md](template.md).

## Authority (highest wins)

1. **Behavior recordings** (golden fixtures) — byte-identical oracle
2. **Core type schema** — serializable State / Action / Effect
3. **Feature one-pager** — prose porting map; must mention every recording
4. **Product plans** (PRD, phase specs) — planning only; must not contradict 1–3

Standing rule: if prose and a recording disagree, **the recording wins**. Update
the one-pager to match, or regenerate the recording from an intentional scenario
change — never "fix the JSON by hand" to match wishful prose.

## Default layout (adapt names, keep the roles)

```
parity/
  manifest.yaml                 # machine registry of features + fixtures
  feature-specs/<feature>.md    # one-pagers (see template.md)
  fixtures/<feature>.*.json     # golden recordings (build products)
  schemas/<feature>.schema.json # optional JSON Schema for core types
AGENTS.md                       # points agents at this stack + verify verb
```

If the repo already uses this layout (or a Duet/parity equivalent), **follow the
repo**, not this default naming.

## What belongs in the core

| In core (must agree across hosts) | Out of core (shell / host) |
| --- | --- |
| State fields a recording asserts | Localized copy, layout, typography |
| Actions (intents + environment reports) | Pixel manner, animation curves |
| Transitions + emitted effect *data* | Concrete HTTP / DB / sensor calls |
| Effect payloads (ids, keys, no closures) | View hierarchy, navigation chrome |
| Pure reducer: same input ⇒ same output | Impure workers behind ports |

## Agent checklist when touching behavior

Copy and track:

```
Core-spec progress:
- [ ] Read the feature one-pager + listed recordings
- [ ] Change scenarios / reducer / schema — not fixtures by hand
- [ ] Update one-pager sections (keep all eight; write "none" if empty)
- [ ] Backtick every fixture name in § Recordings
- [ ] Regenerate recordings / schemas via the project's named verbs
- [ ] Run parity / verify gate (see parity-gates skill)
- [ ] Only then change shell UI to match new routes/state
```

## Related skills

- [`ssot-dev-loop`](../ssot-dev-loop) — mandatory process around this SoT
- [`parity-gates`](../parity-gates) — local=CI verification + build products
- [`feature-boundary`](../feature-boundary) — core package vs shell package
