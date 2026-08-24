---
name: nextjs-design-system
description: >-
  Use when building or styling UI in a Next.js app: new components, layouts,
  Tailwind classes, shadcn-based primitives from a shared UI package, theme
  tokens, or motion. Prefers shared registry components over bespoke controls.
  Covers Tailwind v4, tokens in a shared globals.css, and adding missing
  shadcn blocks via the CLI. Apply alongside an i18n skill for copy and an
  App Router composition skill for feature UI placement.
---

# Next.js — UI & design system

## Stack (adapt names/paths to the actual project)

- **Components**: [shadcn/ui](https://ui.shadcn.com/) primitives, config in
  the app's `components.json`. Primitives typically live in a shared
  workspace package (e.g. `packages/ui/src/components/`) and are imported
  via a scoped alias (e.g. `@workspace/ui/components/…`).
- **Shared package**: a workspace UI package holding tokens/`globals.css`, a
  `cn` class-merge utility, and shared primitives.
- **Brand overrides**: an app-level CSS file for CSS-variable overrides
  (e.g. `--primary`) when the app needs to diverge from the shared theme.
- **Styling**: Tailwind CSS v4, imported once in the shared package's global
  stylesheet (`@import "tailwindcss"`, plus shadcn's base layer and any
  animation utility like `tw-animate-css`).
- **Motion**: add a motion library (e.g. `motion`/Framer Motion) only when
  the first animation actually needs it — don't add it preemptively.
- **Icons**: a single icon set (e.g. `lucide-react`) used consistently.

## Motion & animation

Use motion where it **meaningfully improves** feedback, hierarchy, or
delight — without slowing tasks or fighting existing primitives.

1. **Two layers (use both, pick the right one)**
   - **CSS-only animation utilities** — wired for shadcn overlays and
     primitives (enter/exit classes keyed off `data-open`/`data-closed`).
     Keep these for dialogs, popovers, selects, tooltips, and similar unless
     a product spec requires replacing them.
   - **A React motion library** — use for feature UI when CSS alone is
     awkward: staggered children, layout/shared-layout transitions,
     scroll/view-based reveals, gesture-driven UI, spring micro-interactions,
     coordinated sequences.

2. **When to reach for the motion library** — prefer it for hero/section
   entrance, list stagger, tab/step transitions, empty→content state
   changes, and interactions needing physics-like easing. Prefer CSS-only
   for simple hovers, skeleton pulse animations, and anything already
   covered by a component library's built-in state animations.

3. **Client boundary** — a React motion library runs only in client
   components. Keep animated islands small; pass data from Server
   Components as props. Extract a small client leaf component
   (`…-motion.tsx`) per the App Router composition skill rather than making
   a whole route client-only.

4. **Accessibility** — honor `prefers-reduced-motion` (e.g.
   `useReducedMotion()`) to shorten, skip, or replace motion; never gate
   critical information behind an animation-only cue.

5. **Taste & performance** — favor short durations (~150–350ms) for UI
   chrome, ease-out or calm spring configs. Prefer animating `transform`
   and `opacity`. Don't stack redundant library + CSS enter animations on
   the same node.

6. **Consistency** — reuse a small set of shared variants/transition objects
   (e.g. a colocated `(constants)/motion.ts`) instead of one-off magic
   numbers scattered across files.

## Theme & tokens

1. **Source of truth** — semantic colors and radius live as CSS variables on
   `:root` and `.dark` in the shared package's global stylesheet. Prefer
   Tailwind semantic tokens (`bg-background`, `text-foreground`,
   `bg-primary`, `text-primary-foreground`, `border-border`, `ring-ring`,
   `text-muted-foreground`, etc.) over ad-hoc colors.

2. **Primary/brand color** — use the semantic `primary`/`primary-foreground`
   tokens rather than hard-coded hex in components. If the palette changes,
   update the shared stylesheet once, not individual components.

3. **Radius** — use the scale (`rounded-sm`, `rounded-md`, `rounded-lg`,
   etc.) derived from the shared `--radius` variable; avoid magic pixel
   radii unless matching a specific asset.

## Typography

Pick and document a small type system per project (body font, heading font,
optional monospace for code/technical data), loaded via the framework's font
loader and exposed as CSS variables/Tailwind classes (e.g. `font-sans`,
`font-heading`, `font-mono`). Apply the heading class to `h1`–`h6` and major
section headers when display emphasis is wanted; keep body copy on the
default sans class. Don't hard-code font-family per component — route
through the shared token classes.

## shadcn / shared primitives

1. **Prefer shared primitives over bespoke UI** — before building buttons,
   dialogs, dropdowns, sheets, tabs, forms, tables, or similar patterns from
   raw HTML + Tailwind, check whether the shared UI package already ships
   it, or whether shadcn/ui has a registry block to add. Only build from
   scratch when no registry component fits, or after composing existing
   pieces.

2. **Location** — primitives live in the shared workspace package and are
   imported via the scoped alias. Use the shared `cn` utility for class
   merging rather than manual string concatenation.

3. **Missing primitive** — add it via the shadcn CLI targeting the actual
   app so config, aliases, and CSS path stay authoritative:

   ```bash
   pnpm dlx shadcn@latest add <component> -c apps/<app-name>
   ```

4. **Customization** — after `add`, adjust the generated file to match
   project patterns (`cn()`, `cva` variants, accessibility) and keep
   behavior accessible (labels, focus rings, disabled states).

5. **New feature UI** — colocate route-specific pieces under the route per
   the App Router composition skill. Keep shared chrome in the app's
   `src/components/`; keep primitives in the shared UI package.

## Tailwind usage

- Prefer utility-first composition on top of shared primitives; keep
  spacing and type scales consistent with existing screens.
- Use dark mode via a `.dark` class toggled by a theme provider
  (e.g. `next-themes`); avoid hard-coded light-only grays for elements that
  should adapt.

## Cross-skills

- **Copy** — all user-visible strings go through the project's i18n setup,
  never hard-coded (see an i18n skill).
- **Composition** — feature sections belong in `(components)/`; keep
  `page.tsx` thin (see an App Router composition skill).
