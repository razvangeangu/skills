# Core-spec format reference

Language-neutral shapes for a verifiable behavior kernel. Implementations may
use Swift, Kotlin, TypeScript, etc. — as long as they serialize to these
shapes and replay recordings identically.

## 1. Feature one-pager

Eight sections. Keep every section (write `none` rather than deleting).

| # | Section | Purpose |
| --- | --- | --- |
| 1 | Identity & config | Seeds: config, ids, clocks (reducer never calls the platform for these) |
| 2 | State | Every field the reducer owns (table: Field / Type / Notes) |
| 3 | Actions | User intents + environment reports by name |
| 4 | Transitions | Per action: guards, writes, effects (one list per transition) |
| 5 | Effects | Payloads, cancel/key ids, seam inventory (ingress → worker) |
| 6 | Delegates | Outbound notifications to parent/sibling features |
| 7 | Out of scope | Explicit non-goals (look-and-feel, auth, etc.) |
| 8 | Recordings | Every golden fixture name, backticked |

Blank template: [template.md](template.md).

## 2. Core type schema (JSON Schema sketch)

Each feature may publish `parity/schemas/<feature>.schema.json` describing
serializable values. Requirements:

- **No floats** in fixture-visible types (use integers, decimals as strings, or
  fixed-point ints — pick one project-wide rule and stick to it)
- **Sum types** encode as `{ "case": "<Name>", "value": <payload|null> }`
- State, Action, and Effect are plain data — no functions, no platform handles

Minimal feature schema envelope:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "parity/schemas/example.schema.json",
  "title": "ExampleFeature",
  "type": "object",
  "required": ["state", "action", "effect"],
  "properties": {
    "state": { "$ref": "#/$defs/State" },
    "action": { "$ref": "#/$defs/Action" },
    "effect": { "$ref": "#/$defs/Effect" }
  },
  "$defs": {
    "State": {
      "type": "object",
      "additionalProperties": false,
      "properties": {}
    },
    "Action": {
      "oneOf": [
        {
          "type": "object",
          "required": ["case", "value"],
          "properties": {
            "case": { "const": "Example" },
            "value": { "type": "null" }
          }
        }
      ]
    },
    "Effect": {
      "oneOf": [
        {
          "type": "object",
          "required": ["case", "value"],
          "properties": {
            "case": { "const": "Track" },
            "value": { "type": "object" }
          }
        }
      ]
    }
  }
}
```

Host languages map 1:1:

| Concept | Typical Swift | Typical Kotlin | Typical TS |
| --- | --- | --- | --- |
| State | `struct` + `Codable` | `data class` + `@Serializable` | `type` + zod/JSON Schema |
| Action | enum / tagged | sealed class | discriminated union |
| Effect | enum payload (no closures) | sealed class | discriminated union |
| Reducer | `(inout State, Action) -> [Effect]` | `(State, Action) -> Reduced` | `(State, Action) => [Effect]` |

Reducer purity: same inputs ⇒ same outputs. Time, RNG, I/O enter only as
**actions** (reports) or **effect data** executed by workers outside the core.

## 3. Behavior recording (fixture dialect)

Build products compiled from scenario tests — never hand-edited.

```json
{
  "dialect": 2,
  "feature": "example",
  "name": "example.refresh-empty",
  "initialState": {},
  "steps": [
    {
      "action": { "case": "Refresh", "value": null },
      "expectedState": { "status": { "case": "Loading", "value": null } },
      "expectedEffects": [
        { "case": "LoadCatalog", "value": { "requestId": "r1" } }
      ]
    }
  ]
}
```

Rules:

- `dialect` is an integer the project's recorder/verifier understands
- Every step is action → expected state → expected effects (ordered)
- Effect ordering obligations live **inside one payload**, not across two
  sibling effects, unless the project contract explicitly allows sequences
- Filename pattern: `<feature>.<name>.fixture.json` (or the repo's equivalent)

## 4. Manifest

Machine registry. Minimum fields per feature:

```yaml
features:
  example:
    id: example
    core_path: src/<host>/…/ExampleFeature   # or multi-host map
    state_type: ExampleState
    action_type: ExampleAction
    effect_type: ExampleEffect
    fixtures:
      - example.refresh-empty
      - example.refresh-success
```

The verifier uses this to:

- lint one-pager ↔ fixture mentions
- know which packages are "checked core"
- drive record / replay / drift checks

## 5. Shared-memory target (evolution)

Toward true multi-platform memory, prefer committing all of:

1. `feature-specs/` — LLM-readable porting map  
2. `schemas/` — type contract  
3. `fixtures/` — behavioral oracle  
4. `manifest.yaml` — index + lint targets  

Optional later: export the same bundle to Notion / a vector store for
cross-repo search — **git remains canonical**; external stores are mirrors.

## 6. Lint obligations (tooling or skill-enforced)

| Check | Fail when |
| --- | --- |
| Spec ↔ fixture | Fixture declared in manifest but not backticked in one-pager (or vice versa) |
| Schema ↔ fixture | Fixture JSON invalid against feature schema |
| Record drift | Re-recording differs from committed fixture without intentional change |
| Float ban | Number with fractional part in fixture-visible payload |
| Empty corpus | Feature has zero recordings / zero scenario tests |
