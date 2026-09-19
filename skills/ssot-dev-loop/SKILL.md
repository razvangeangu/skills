---
name: ssot-dev-loop
description: >-
  Enforces a single-source-of-truth development process: read core-spec, change
  pure behavior first, regenerate build products, verify with parity gates, then
  update shell UI. Use for any feature work, porting, or when the user wants AI
  to follow a strict build process / architecture loop. Triggers: SSOT loop,
  development process, always follow process, feature authoring, change
  behavior, port feature, reducer first, core before UI.
---

# SSOT development loop

When behavior or architecture is in scope, follow this loop **in order**. Do
not start in the shell UI. Do not claim done without the verify step.

Depends on [`core-spec`](../core-spec), [`feature-boundary`](../feature-boundary),
and [`parity-gates`](../parity-gates).

## Process checklist

```
SSOT loop:
- [ ] 0. Orient
- [ ] 1. Plan against the one-pager
- [ ] 2. Change the core (scenarios + reducer + schema)
- [ ] 3. Regenerate build products
- [ ] 4. Verify (parity gates)
- [ ] 5. Adapt the shell
- [ ] 6. Close out
```

### 0. Orient

1. Open `AGENTS.md` if present — follow its SoT map. (If a harness only
   loads a vendor-named file, that file should be a symlink to `AGENTS.md`;
   see this repo's `ports/README.md`.)
2. Locate the feature's one-pager, fixtures, and core package
   (`tools/<cli> scope <path>` when the project has a scope verb).
3. If no parity layout exists yet, propose adopting [`core-spec`](../core-spec)
   before inventing a parallel convention.

### 1. Plan against the one-pager

- Edit or create `parity/feature-specs/<feature>.md` from
  [`core-spec/template.md`](../core-spec/template.md).
- For greenfield product work: PRD / phase spec → decomposition → reducer
  sketch → phases — **then** code. Planning docs do not override recordings.
- List which recordings will be added/changed.

### 2. Change the core

- Edit scenario tests / reducer / ports in the **core** package only.
- Keep the reducer pure; put I/O behind workers invoked by effect *data*.
- Respect [`feature-boundary`](../feature-boundary): no UI framework imports
  in core.

### 3. Regenerate build products

Run the project's named verbs (examples — use what the repo documents):

```bash
# record / compile fixtures from scenarios
<parity-cli> record
# design tokens, mocks, serializers, project files — as applicable
<script> generate-… 
```

Never hand-edit fixtures, `Generated/`, or generated project files.

### 4. Verify

Run the local gate that mirrors CI ([`parity-gates`](../parity-gates)):

```bash
./scripts/checks.sh          # or make check / npm run check — project truth
# or at minimum:
<parity-cli> verify
<parity-cli> record --check
```

Fix failures before continuing. "Held" lanes (missing subject) are not green.

### 5. Adapt the shell

- Update Node / screens / routes to **project** core state and actions.
- Look-and-feel stays out of the feature one-pager unless the project puts
  presentation state in the reducer by contract.

### 6. Close out

- One-pager § Recordings lists every fixture (backticked).
- Manifest rows match new fixtures / mocks / schema.
- [`repo-hygiene`](../repo-hygiene) definition-of-done if this repo uses it.

## Failure workflow

1. Read the failing gate message (scope → which check owns the file).
2. Fix the **source** (scenario, reducer, schema, one-pager) — not the product.
3. Regenerate → re-verify.
4. Only if the gate itself is wrong, change the gate in the same PR with an
   explicit rationale.

## Anti-patterns

| Don't | Do |
| --- | --- |
| Patch UI to fake correct behavior | Fix the reducer + recording |
| Hand-edit a fixture JSON | Change the scenario, re-record |
| Skip verify because "it's a small change" | Always run the gate for core paths |
| Add a second prose SoT that contradicts fixtures | Point planning docs at the one-pager |
| Import UI kits into the core package | Put UI in the shell package |

## Related skills

- [`core-spec`](../core-spec) — what the SoT looks like
- [`feature-boundary`](../feature-boundary) — where code may live
- [`parity-gates`](../parity-gates) — how truth is checked
- [`repo-hygiene`](../repo-hygiene) — general definition of done
