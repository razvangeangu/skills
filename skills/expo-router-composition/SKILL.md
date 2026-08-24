---
name: expo-router-composition
description: >-
  Use when building or refactoring Expo Router screens: extracting sections
  into colocated components under components/ using logical paths (no route-
  group parentheses), keeping route files thin, and using the @/ path alias
  for all app-local imports instead of relative paths. Triggers: extract
  screen, refactor route, colocated component, thin route file, @/ alias,
  relative import.
---

# Expo Router — screen composition and colocated components

## When to extract

If a route file is no longer a **thin composition layer** — multiple
logical sections, repeated layout, or a block you'd reasonably test or
reuse in isolation — move the UI into a `components/` tree.

**Heuristics:**
- **Route file** (`app/…`) should stay small — mostly navigation wiring, not
  a hard line count but a strong smell past ~40 lines.
- **Screen component** growing past ~200 lines → split into section
  components under the same feature folder.
- A monolithic 500+ line screen is a clear split candidate: break into
  section components, feature-local data hooks, and smaller presentational
  pieces.

Route files should primarily handle: navigation wiring, `Stack.Screen` /
`Tabs.Screen` options, and rendering the colocated screen component.

**Good thin route** (`app/(tabs)/(home)/index.tsx`):

```tsx
import { HomeScreen } from '@/components/tabs/home/home-screen';

export default function Home() {
  return <HomeScreen />;
}
```

## Path rule: logical mirror, no parentheses in `components/`

Expo Router **route groups** use parentheses in `app/` only — they affect
the URL/grouping, not the physical filesystem for imports. Under
`components/`, mirror the same logical segments as **plain folders**, no
`()`.

- Route (file on disk): `app/(tabs)/(settings)/index.tsx`
- Colocated UI: `components/tabs/settings/…` (e.g. `settings-screen.tsx`,
  section components, `hooks/`, `constants/`)

```ts
import { SettingsScreen } from '@/components/tabs/settings/settings-screen';
```

Keep `router.push` / `router.replace` paths in their route-group form (e.g.
`/(tabs)/(settings)/devices`) — those are URL paths, not import paths, and
must not be "flattened" to match the `components/` layout.

## What lives where

| Location | Holds |
| --- | --- |
| `app/(…)/` | Route files, minimal default exports, navigation wiring. |
| `components/…/` | Screen bodies, sections, feature-local hooks/constants. |
| Cross-cutting helpers | Only when used by multiple unrelated features; prefer feature-local first. |
| Feature data hooks | Prefer `lib/<feature>/` for network/query hooks shared by screens; keep UI-only hooks next to the screen when presentation-specific. |

Reuse a shared stack/tab-options helper (screen-options constants) in tab
layouts instead of duplicating header styling per screen.

## `@/` imports

Map `@/*` to the app root in `tsconfig.json` `paths`, and mirror that in the
test runner's module mapper.

1. **App-local modules** — any import resolving to code/assets inside the
   app must use `@/…` (`@/components/...`, `@/i18n/...`, `@/lib/...`). Never
   `./` or `../` for those targets.

   ```ts
   // Wrong
   import { HomeScreen } from '../components/tabs/home/home-screen';
   // Right
   import { HomeScreen } from '@/components/tabs/home/home-screen';
   ```

2. **Boundaries** — `@/` is for the app only. A shared workspace UI package
   uses relative imports internally; the app consumes it by package name
   (e.g. `@myorg/ui`), never by reaching into it via `@/`.

3. **Exceptions** — third-party packages, `node:` builtins, and paths
   outside the app are unaffected.

4. **Import order** (if enforced by a lint plugin): side-effect imports →
   `node:` builtins → `@/` and workspace-package imports → all other
   external packages.

5. **Bootstrap side effects** — app-wide init (e.g. i18n) should be imported
   once from a single providers/root entry point, not scattered across
   routes.

## Conventions

- Import path alias: `@/components/…`, never relative imports.
- UI primitives: use the shared design-system package when available;
  fall back to raw React Native primitives until it covers the need.
- Copy: user-visible strings belong in the message files, not inline
  literals (see an i18n skill).
- Extract only what the task needs — don't drive-by-refactor unrelated
  screens while touching one.
