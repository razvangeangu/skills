# Feature spec: <feature>

The one-page platform-agnostic spec — the porting source of truth for this
feature across hosts. Keep every section (write `none` rather than deleting).
**Behavior recordings win any disagreement with this prose.** Every declared
recording must be mentioned below, backticked.

## 1. Identity & config

What the builder seeds (config, identity, clocks). If the feature mints time or
identity, say where the values come from — the reducer never calls the platform
for them. `none` is valid.

## 2. State

| Field | Type | Notes |
| --- | --- | --- |

Every field the reducer owns. Derived data is state when every host must agree
on it (a recording asserts it, or a badge/count/empty-state shows it). Keep
presentation-only projections in the shell.

## 3. Actions

User intents and environment reports, by name. Note which host/slot owns each
interactive-dismiss or navigation report — the view reports, state decides.

## 4. Transitions

Per action: guards, state writes, emitted effects (one list per transition).
Name deliberately inert repeat taps (latch guards) — they get recording
coverage.

## 5. Effects

| Effect | Ingress shape | Backing worker(s) |
| --- | --- | --- |
| `<payload>` | fire-and-forget + results-via-streams · tick-stream · keyed clock · sticky flag · pure env call | `<Worker>` / none |

## 6. Delegates

Outbound notifications to parents/siblings. `none` if the feature is a leaf.

## 7. Out of scope

Explicit non-goals (look-and-feel, auth, backend, etc.).

## 8. Recordings

- `` `<feature>.<scenario-name>` `` — one line each; must match manifest + fixtures
