---
name: nextjs-i18n
description: >-
  Use when adding or editing user-visible copy, labels, placeholders, toasts,
  accessibility strings, metadata, or navigation titles in a Next.js app.
  Ensures strings live in message JSON files and are read via next-intl
  (useTranslations / getTranslations with namespaces) instead of inline
  literals. Prefer rich-text translation helpers when copy combines multiple
  styled segments or needs locale-safe reordering with interpolation.
  Triggers: en.json, copy, i18n, next-intl, translations, aria-label,
  generateMetadata.
---

# Next.js — internationalization (next-intl)

Locale is typically taken from a `[locale]` App Router segment (see the
project's i18n routing config for `locales`, `defaultLocale`, and locale
prefix behavior). Messages load from `messages/<locale>.json` via the
project's i18n request config. `next-intl` is wired through its Next.js
plugin in `next.config.ts`.

The locale layout wraps the tree in `NextIntlClientProvider`. Prefer
locale-aware navigation helpers (e.g. a `Link` re-export from the project's
i18n navigation module) over the raw `next/link`.

## Rules

1. **No user-facing string literals in UI code** — any copy shown to users
   (buttons, headings, form labels, placeholders, validation messages, toast
   text, `aria-label`/`aria-description`, document titles) belongs in
   `messages/<locale>.json` for each supported locale, not hard-coded in
   TSX/TS.

2. **Copy style** — see the `copy-style` skill (no Oxford comma, no em
   dash); applies to all English user-facing copy here too.

3. **Client components: `useTranslations("namespace")`** — call
   `useTranslations` with the JSON top-level namespace used for that UI
   (e.g. `"homePage"`, `"error"`). Use short camelCase keys inside that
   namespace (`title`, `toggleTheme`).

   ```tsx
   import { useTranslations } from "next-intl";

   const t = useTranslations("homePage");

   return <h1>{t("title")}</h1>;
   ```

   Use `t("key", { var: value })` for interpolation.

   **Per component:** any Client Component that needs copy should call
   `useTranslations("namespace")` inside that component. Don't pass `t`
   through props just to reuse the hook from a parent — call the hook again
   in the child. Multiple calls in one file (parent + local subcomponents)
   are fine.

   **Threading `t` only when needed:** pass a translator as an argument only
   for a concrete reason (a non-component module, tests with an injected
   mock, or a callback factory that can't call hooks).

4. **Server components & metadata: `getTranslations`** — in async Server
   Components, `generateMetadata`, and route handlers, use
   `await getTranslations("namespace")` after `setRequestLocale(locale)`, or
   `await getTranslations({ locale, namespace: "namespace" })` when building
   metadata before/alongside locale setup.

   ```tsx
   import { getTranslations, setRequestLocale } from "next-intl/server";

   setRequestLocale(locale);
   const t = await getTranslations("homePage");
   ```

   Validate `locale` with `hasLocale(routing.locales, locale)` before
   rendering or returning metadata.

5. **Rich copy: prefer `t.rich()` over stitching multiple `t()` calls** —
   when a single sentence mixes different styles, links, or might need word
   order to change per locale, use one message with XML-like tags and render
   with `t.rich()`.

   ```tsx
   const t = useTranslations("legalPage");

   t.rich("terms", {
     link: (chunks) => <Link href="/privacy">{chunks}</Link>,
   });
   ```

   Don't concatenate several `t()` results or interleave raw string
   literals for these cases.

6. **Add keys to message files first** — when introducing new UI text, add
   keys under an existing or new camelCase namespace matching the default
   locale's message file. Keep JSON valid; prefer clear hierarchy over flat
   mega-keys.

7. **What stays out of `messages/`** — non-display constants are fine as
   code: URLs, enum/internal identifiers, route paths, design tokens,
   technical config. If a string is ever shown to the user, move it to
   messages. Route-scoped non-copy config belongs in `(constants)/`, not
   message files (see the App Router composition skill).

8. **Metadata and titles** — use `getTranslations` in `generateMetadata` so
   titles and descriptions stay translatable, rather than hard-coding meta
   copy.

9. **Adding locales** — adding a language means: a new
    `messages/<locale>.json` with the same key structure as the default
    locale file; updating the routing config's locale list (and any types
    that narrow locale codes); and making sure static params generation and
    any locale-detecting middleware cover the new locale.

## Related skills

| Skill                              | Role                                                                          |
| ------------------------------------ | -------------------------------------------------------------------------------- |
| `nextjs-app-router-composition`      | Copy lives in components/screens, not as string literals in `(constants)/`   |
| `nextjs-design-system`               | Visual primitives; still no hard-coded user-facing strings in UI             |
| `copy-style`                         | No Oxford comma / no em dash, applied to all user-facing copy here           |
