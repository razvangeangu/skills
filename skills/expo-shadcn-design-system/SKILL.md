---
name: expo-shadcn-design-system
description: >-
  Use when building, editing, or importing UI components from a shared React
  Native design-system package built by porting shadcn/ui to React Native.
  Always start from the shadcn docs/CLI reference before implementing in RN.
  Apply when touching the shared UI package, importing a design-system
  primitive, or when a user asks for a Button, Card, Input, or names any
  shadcn component. Triggers: shared UI package, new component, theme
  tokens, Typography, shadcn to React Native.
---

# React Native design system — porting shadcn/ui to RN

A shared workspace UI package (e.g. `packages/ui`) consumed by one or more
React Native apps in a monorepo. Components are built by **porting
[shadcn/ui](https://ui.shadcn.com/docs) to React Native** — the shadcn
component is the canonical reference for API shape, variants, and behavior,
not something rendered directly.

## Package structure

```
packages/ui/src/
├── components/   — React Native component primitives (one file per component)
├── theme/        — Tokens: palette, spacing, radii, typography, theme provider
├── lib/          — Utilities shared across components (helpers, hooks)
└── index.ts      — Public API: re-export everything components/theme expose
```

## Importing in the app

Always import from the package name, never via relative paths into the
package:

```ts
import { Button, useTheme } from '@myorg/ui';
```

## Adding a new component — the shadcn → React Native workflow

Every component should be built this way so the design system stays
aligned with shadcn/ui behavior on mobile.

### 1. Read the shadcn docs

Open the relevant page on [shadcn/ui](https://ui.shadcn.com/docs) (and
underlying Radix/primitive behavior where it matters):

- What variants does the component support?
- What compound parts exist (e.g. `Card` + `CardHeader` + `CardContent`)?
- What are the prop names, types, and defaults?
- Controlled or uncontrolled? What callbacks does it fire?
- What accessibility roles/attributes does the web version use?
- What states need styling: hover, focus, invalid, disabled?

### 2. Pull the shadcn component as a local reference

Add the component via the shadcn CLI into a gitignored scratch folder (a
minimal Next.js scaffold works) so you have the exact web source to read —
you port it, you don't ship it.

```bash
cd .shadcn-ref && npx shadcn@latest add <component-name> --yes; cd ..
```

Read the resulting file for structure, variant definitions, compound parts,
state machine, and class/style logic — it's a reference, not something to
copy verbatim.

### 3. Copy the API shape, not the DOM

Port **prop names**, **variant values**, **compound part names**, and
**behavior**. Do not copy:
- `className` or Tailwind utility strings
- HTML-only patterns (`<button>`, `<input>`, `role="…"` as an HTML
  attribute)
- CSS pseudo-selectors (`:hover`, `:focus`, `:disabled`) — replace with RN
  state callbacks and conditional `StyleSheet` rules

Goal: a developer switching between the web and mobile app sees the same
component API. `<Button variant="destructive">` means the same thing on
both.

### 4. Implement for React Native

| Web | React Native |
| --- | --- |
| `<div>` / layout | `View` |
| `<button>` | `Pressable` |
| `<input>` | `TextInput` |
| `<span>` / text | `Text` (or the design system's `Typography`) |
| CSS Flexbox | RN Flexbox (mostly the same; `flexDirection` default differs) |
| `:focus` ring | `borderColor` + `shadow*` / `elevation` |
| `opacity: 0.5` on disabled | `style={{ opacity: 0.5 }}` on the container |

**Prefer platform-native controls when they fit** — before hand-rolling
sliders, switches, date pickers, or other platform-heavy controls, check
whether a host-native wrapper (e.g. Expo UI / `@expo/ui`) already exists.
If a stable host component exists (SwiftUI on iOS, Jetpack Compose on
Android), wrap it and map theme colors to its props; keep a fallback `.tsx`
for web/unsupported platforms.

Platform-file pattern when needed:
```
packages/ui/src/components/switch.ios.tsx
packages/ui/src/components/switch.android.tsx
packages/ui/src/components/switch.tsx   ← fallback / web
```

### 5. Theme integration

Use `useTheme()` from the shared package for all visual tokens. Never
hard-code hex values, magic spacing numbers, or border-radius literals.

- **`palette.*`** — semantic colors mirroring shadcn's default CSS
  variables (`foreground`, `background`, `card`, `primary`, `secondary`,
  `muted`, `accent`, `destructive`, `border`, `ring`, `success`, `warning`,
  `info`)
- **`spacing(step)`** — function, 4px base unit
- **`radii.*`** — `sm` / `md` / `lg` / `xl` / `2xl` / `full`
- **`fonts`** — semantic weight names mapped to loaded font-family
  variants, loaded once via the app's font-loading hook before rendering

Where hooks aren't available (module-level `StyleSheet.create`), import a
standalone `spacing`/token helper instead of calling the hook.

Match shadcn semantics for shared state props:
- **`invalid`** — validation-error styling (border/focus-ring → destructive
  color)
- **`inGroup`** — when a control is nested inside a group that owns the
  border (e.g. an input group)
- Focus ring — theme's `ring` color, shown on focus/press state

### 6. Export and document

1. Re-export the new component from the package's component index.
2. Confirm the package's top-level entry re-exports both `components/` and
   `theme/`.
3. Add a row to the project's component table so agents and humans know the
   primitive exists.

### 7. Verify in the app

Import from the package in a real screen and exercise:
- Light and dark themes
- Validation (`invalid` state) if applicable
- Any platform-specific `.ios.tsx` / `.android.tsx` split

Run the repo's typecheck and lint for the app package before considering it
done.

## Icons

Pick one icon library for the whole app (e.g. `lucide-react-native`) and
match icon size to surrounding typography (roughly 12–16 inline, 20–24
standalone) rather than mixing icon sets.

## Related skills

| Skill | Role |
| --- | --- |
| `expo-router-composition` | Screen layout, navigation — this skill covers the primitives it composes |
| `expo-i18n` | User-visible strings on components belong in the message file |
| `anti-vibe-ui` | Visual polish still routes through theme tokens, never one-off colors |
