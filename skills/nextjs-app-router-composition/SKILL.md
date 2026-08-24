---
name: nextjs-app-router-composition
description: >-
  Use when building or refactoring Next.js App Router screens: extracting UI,
  hooks, constants, and other feature-local modules into colocated route
  groups — (components), (hooks), (constants), etc. — at the same route
  segment as page.tsx / layout.tsx. Apply alongside an i18n skill for copy and
  a design-system skill for shared UI primitives. Triggers: colocate, route
  group, thin page, (components), screen composition, section, App Router.
---

# Next.js App Router — screen composition and colocated route groups

Route groups live under **`src/app/`** (adjust the root if the app doesn't
use `src/`), usually inside a locale or other dynamic segment if the project
is internationalized.

## When to extract

If a route file is no longer a **thin composition layer** — multiple logical
sections, repeated layout, or logic you'd reasonably test or reuse in
isolation — move code into **sibling route groups** next to that route's
**`page.tsx`** or **`layout.tsx`**:

- **UI** → **`(components)/`**
- **Route-scoped hooks** → **`(hooks)/`**
- **Route-scoped constants** (and similar static config) → **`(constants)/`**
- Add **`(types)/`**, **`(lib)/`**, etc. the same way when a segment needs a
  dedicated bucket — always as **parenthesized folders** at that segment so
  they stay out of the URL.

Route files should primarily handle: **data loading** (Server Components),
**metadata** (`generateMetadata`), **locale setup** if applicable, and
**wiring** imports from the colocated groups above.

## Path rule: same segment, parenthesized folders

Next.js **route groups** use parentheses in **`src/app/`** only and never
appear in the URL.

At a given URL segment, colocated feature code lives in **parallel** folders
such as **`(components)`**, **`(hooks)`**, **`(constants)`** — at the same
depth as **`page.tsx`**, not under a separate top-level tree for that
feature.

**Example** (paths relative to the app root):

- `src/app/dashboard/page.tsx`
  Colocated: `src/app/dashboard/(components)/…`, `src/app/dashboard/(hooks)/…`,
  `src/app/dashboard/(constants)/…`

**Nested routes:** each segment that owns a `page.tsx` can have its own
`(components)/`, `(hooks)/`, `(constants)/`, … Don't flatten unrelated
features into a single global `app/(components)/` unless they truly belong
to one segment.

## Imports

- **From `page.tsx` / `layout.tsx`** — use a path alias (e.g. `@/`) into
  colocated route groups rather than long relative paths:

  ```tsx
  import { DashboardScreen } from "@/app/dashboard/(components)/dashboard-screen";
  import { PAGE_SIZE } from "@/app/dashboard/(constants)/dashboard";
  ```

- The alias root maps to the app's `src/` (or root) — use it for **shared**
  app code (`src/components`, `src/lib`, `src/i18n`, `src/config`). Avoid
  importing another route's `(hooks)` / `(components)` across unrelated
  segments; extract to a shared location when truly shared.

- Shared UI primitives live wherever the design-system skill/package points
  (e.g. a shared `ui` workspace package) — not duplicated per route.

- **URL paths** (`href`, `redirect`, `Link`) stay normal App Router paths —
  none of `(components)`, `(hooks)`, `(constants)`, … ever appear in URLs.

## What lives where

| Location                    | Holds                                                                        |
| ---------------------------- | ----------------------------------------------------------------------------- |
| `src/app/…/`                 | `page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx`, route handlers — minimal composition and wiring. |
| `src/app/…/(components)/`    | Screen layout, sections, presentational pieces tied to that route.          |
| `src/app/…/(hooks)/`         | Custom hooks used only (or primarily) by that segment's UI.                 |
| `src/app/…/(constants)/`     | Magic numbers, static maps, config literals scoped to that route (not user-facing copy). |
| `src/components/`            | Cross-route chrome and helpers (providers, theme toggle, header/footer).    |
| shared UI package/workspace  | Shared primitives, `cn`-style utility, design tokens.                       |
| `src/lib/`, `src/config/`    | Cross-cutting helpers and site config used from many features.              |

**Cross-cutting code** — only promote to `src/components/`, `src/lib/`, etc.
when used by **multiple unrelated** routes. Prefer segment-local
`(components)` / `(hooks)` / `(constants)` first.

**User-facing copy** stays in message files, not as string literals in
`(constants)/` — see an i18n skill for the project's translation setup.

## Conventions

- **Copy:** each component that shows user-facing strings should read
  translations locally rather than having a translator function threaded
  through props from a parent, unless there's a concrete reason (non-component
  module, injected test mock, callback factory that can't call hooks).

- **Primitives:** compose from the shared UI package where a primitive
  exists rather than reinventing buttons/dialogs/forms from raw markup.

- **Server vs client:** keep `page.tsx` as a Server Component when possible.
  Put `'use client'` on `(components)/` files (or subtrees) that need hooks,
  browser APIs, or event handlers. `(hooks)/` modules using React hooks must
  be imported from Client Components. `(constants)/` can be consumed from
  either as long as they stay free of client-only imports.

- **Naming:** clear file names (`*-screen.tsx`, `*-section.tsx`, `use-*.ts`,
  or domain names like `hero.tsx`) consistent with the route's purpose.
