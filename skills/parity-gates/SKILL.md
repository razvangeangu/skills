---
name: parity-gates
description: >-
  Enforces automated verification for a core-spec / parity stack: local checks
  must match CI, build products must not be hand-edited, drift and empty-test
  runs fail. Use before claiming feature or architecture work is done, when
  regenerating fixtures/tokens/mocks, or when the user mentions parity, verify,
  record --check, checks.sh, drift, or local equals CI. Triggers: parity gates,
  verify, record check, drift check, build products, local equals CI, checks.sh,
  empty tests fail, codegen check.
---

# Parity gates — verify before "done"

Truth is what the gate accepts. Prose and chat agreement are not enough when
core behavior is involved.

Pairs with [`core-spec`](../core-spec) and [`ssot-dev-loop`](../ssot-dev-loop).
Also run [`repo-hygiene`](../repo-hygiene) for general lint/format/hooks.

## Local = CI

Prefer one entrypoint that CI jobs invoke by lane:

```bash
./scripts/checks.sh              # full local mirror when present
./scripts/checks.sh host         # core lint / verify / record --check
./scripts/checks.sh codegen      # mocks / serializers drift
./scripts/checks.sh ios|android  # host app trees when present
```

If the repo uses another name (`make check`, `npm run check`, `just parity`),
**that** is the gate — discover it from `AGENTS.md` or CI workflows, don't
invent a parallel script.

## Required properties of a good gate

| Property | Rule |
| --- | --- |
| Drift fails | Re-recording or regenerating differs from committed products → red |
| Empty tests fail | `swift test` / `*test` with zero executed tests → red, not green |
| Held ≠ green | Missing platform subject (no KMP tree yet, etc.) may be **held**; never report held as passed |
| Scopeable | A `scope <path>` (or docs table) maps a file → which checks govern it |
| Pins are intentional | Toolchain / package pins change only as reviewed gate changes |

## Build products (never hand-edit)

Treat these as compile outputs — change inputs, regenerate, commit the diff:

- Golden behavior fixtures (`parity/fixtures/**`)
- Anything under `Generated/`
- Generated serializers / mocks / design-token Swift|KT|TS
- Generated Xcode/Gradle project files when the source is YAML/DSL

If you are about to open a fixture in an editor to "tweak expectedState", stop —
edit the scenario and re-record instead.

## Minimum verify set for core changes

When any of one-pager, reducer, scenario, schema, or manifest changed:

1. Manifest / lint / doctor (project verbs)
2. `record --check` or equivalent fixture drift check
3. Schema validation if schemas exist
4. Unit/scenario tests for the touched core package
5. Codegen `--check` if mocks/tokens/serializers are in play

Shell-only copy/layout changes may skip record checks — still run the host
lane the project requires.

## Agent refusal rule

Do **not** say the work is complete, merge-ready, or "should be fine" if:

- the parity / check command was not run after core edits, or
- it failed and was not fixed, or
- fixtures were hand-edited to silence a drift check

Report the exact command run and its exit status when closing out.

## Related skills

- [`ssot-dev-loop`](../ssot-dev-loop) — when in the process to verify
- [`core-spec`](../core-spec) — what is being verified
- [`feature-boundary`](../feature-boundary) — which packages the host lane covers
- [`repo-hygiene`](../repo-hygiene) — broader definition of done
