---
name: feature-boundary
description: >-
  Enforces strict core-vs-shell architecture: pure behavior packages stay free
  of UI/host frameworks; shells project state and report actions; workers sit
  behind ports. Use when adding packages, importing dependencies, scaffolding
  features, or when the user mentions host lane, core boundary, Node vs Feature,
  package graph, or architecture rules. Triggers: feature boundary, host lane,
  core vs shell, package boundary, no UI in core, reducer purity, workers and
  ports, architecture rules.
---

# Feature boundary — core vs shell

Keep a hard line between **checked core** (portable behavior) and **shell**
(host UI + impure adapters). Crossing it silently kills multi-platform parity.

Use with [`core-spec`](../core-spec) and [`ssot-dev-loop`](../ssot-dev-loop).

## Geometry (default)

```
<Feature>/
  <Feature>Core/     # or *Feature — pure state/action/effect/reducer + ports
  <Feature>Shell/    # or *Node — UI, routing chrome, host wiring
```

Names vary by stack (`TherapyRecordFeature` + `TherapyRecordNode`,
`feature-foo` + `feature-foo-ui`). Preserve the **split**, not the spelling.

## Dependency rules

| Package | May depend on | Must not depend on |
| --- | --- | --- |
| Core | Kernel/framework family, shared ports/services contracts, stdlib | UI kits (SwiftUI/Compose/React), app theme, navigation hosts |
| Shell | Core, UI kits, theming, host app composition | (avoid) re-implementing reducer logic |
| Workers | Platform APIs, networking, DB | Being imported *into* the reducer body |

Enforce via package manager graph + CI meta-checks when available. If a core
`Package.swift` / `build.gradle` / `package.json` gains a UI dependency, that
is a boundary break — fix it before adding features on top.

## Purity rules (core)

- Reducer: `(State, Action) → (State, [Effect])` — deterministic
- Effects are **data** (ids, keys, payloads) — no closures, no `Task`, no
  `DispatchQueue`, no React effects inside the reducer
- Time, randomness, and I/O arrive as **actions** (reports) or leave as
  **effects** executed by workers
- No `#if os(…)` / platform guards used to smuggle host-only types into core

## Shell responsibilities

- Render from state; send user intents as actions
- Own look-and-feel unless the project's presentation contract puts route/sheet
  stage in reducer state (then shell still owns manner/pixels)
- Wire environment: map effect payloads → workers → report results as actions
- Lifecycle / analytics sinks as the project documents (often shell emits
  lifecycle; reducer emits domain `.track` effects that recordings check)

## Workers and ports

- Declare ingress shapes on the one-pager (see core-spec § Effects)
- Test workers with worker/unit tests — not with behavior recordings
- Fakes/mocks for ports live at the composition root or test doubles package;
  regenerate committed mocks via the project script, don't hand-edit

## Scaffolding

When creating a feature:

1. Emit core + shell siblings (project scaffold / MCP verb if present)
2. Register the feature in `parity/manifest.yaml`
3. Add a one-pager from [`core-spec/template.md`](../core-spec/template.md)
4. Mount only at documented composition markers / root DI sites

Do not dump a new screen into the app target with inline business rules.

## Quick review questions

- Can this core package build without the UI framework linked?
- Would a second host (Android/web) need to rewrite this file, or only the shell?
- Is there a closure or platform type inside an Effect payload?
- Did a "quick fix" put formatting/locale logic into the reducer?

If any answer is wrong, move the code before adding more behavior.

## Related skills

- [`core-spec`](../core-spec) — what the core must express
- [`ssot-dev-loop`](../ssot-dev-loop) — process that respects this boundary
- [`parity-gates`](../parity-gates) — verifies host-lane packages
