---
name: expo-i18n
description: >-
  Use when adding or editing user-visible copy, labels, placeholders, toasts,
  accessibility strings, or navigation titles in an Expo/React Native app.
  Ensures strings live in a message JSON file and are read via react-i18next
  instead of inline literals. Prefer Trans (rich text) when copy combines
  multiple styled segments or needs locale-safe reordering with
  interpolation. Triggers: en.json, copy, label, placeholder, toast,
  accessibilityLabel, navigation title, react-i18next.
---

# Expo / React Native — internationalization (react-i18next)

Load strings from a per-locale message file (e.g. `messages/en.json`) and
initialize `i18next` once from a single side-effect import (e.g. `@/i18n`)
in the app root or providers entry point.

## Rules

1. **No user-facing string literals in screen code** — any copy shown to
   users (buttons, headings, labels, placeholders, validation messages,
   toast text, `accessibilityLabel` / `accessibilityHint`, stack/tab header
   `title` values) belongs in the message file, not hard-coded in TSX/TS.

2. **Copy style** — see the `copy-style` skill (no Oxford comma, no em
   dash); applies to all English user-facing copy here too.

3. **Retrieve copy with `useTranslation()`**:

   ```tsx
   import { useTranslation } from 'react-i18next';

   const { t } = useTranslation();
   // ...
   <Text>{t('some.namespace.key')}</Text>
   ```

   Use `t('key', { var: value })` for interpolation.

4. **Rich copy: prefer `Trans` only when needed** — use `Trans` when a
   single sentence mixes two or more styled spans (e.g. muted lead + bold
   name), embeds dynamic values sharing a tag's emphasis, or might need word
   order to change per locale. Plain single-style strings just need `t()`.
   Don't concatenate several `t()` results or interleave literals for rich
   cases.

   - Write lowercase XML-style tags in the message matching the
     `components` map keys (e.g. `"<lead>Good morning,</lead>
     <name>{{firstName}}</name>"`). Keep dynamic parts as `{{var}}` inside a
     tag when they share that tag's emphasis.
   - `Trans` must render under a text parent — prefer the shared design
     system's text component as `parent` and inside the `components` map so
     styles come from the design system, not one-off styling.
   - Supply empty elements for each tag in the `components` map; `Trans`
     injects the right children.
   - When the `components` map doesn't depend on hooks, build it once with
     `useMemo(..., [])` so translations don't recreate elements every
     render.

   ```tsx
   import { Typography } from '@myorg/ui';
   import { useMemo } from 'react';
   import { Trans, useTranslation } from 'react-i18next';

   const { t } = useTranslation();
   const richSlots = useMemo(
     () => ({
       muted: <Typography variant="muted" />,
       emphasis: <Typography variant="large" />,
     }),
     [],
   );

   <Trans
     components={richSlots}
     i18nKey="home.welcomeUserRich"
     parent={Typography}
     values={{ firstName }}
   />;
   ```

5. **Pluralization** — use i18next plural suffixes in the message file
   (`_one`, `_other`; add `_zero` when empty states need distinct copy).
   Pass `count` from code:

   ```tsx
   t('bands.members', { count: band.members.length })
   ```

   ```json
   "members_one": "{{count}} member",
   "members_other": "{{count}} members"
   ```

6. **Add keys to the message file first** — when introducing new UI text,
   add a nested key under an existing or new camelCase namespace and
   reference it from code. Keep JSON valid; prefer clear hierarchy over
   flat mega-keys. Namespace by feature/screen (`auth.*`, `home.*`,
   `settings.*`, `common.*` for shared labels).

7. **What stays out of the message file** — non-display constants are fine
   as code: URLs, enum/internal identifiers, route paths, design tokens,
   technical config. If a string is ever shown to the user, move it to
   messages.

8. **Navigation titles** — stack/tab titles from `options={{ title: '…' }}`
   must call `t('…')` inside a component so they stay translatable; avoid
   static title strings in layout files.

9. **Review step** — before finishing, scan the diff for user-visible
   string literals in JSX (`title=`, `placeholder=`, `<Text>`, subtitles).
   Watch for hard-coded counts, names, or placeholder copy sitting beside
   properly-keyed strings.

10. **Future locales** — adding a language means a new message file, a
   `resources` entry in the i18n init, and extending the locale-config list
   when locale switching is wired up.

## Related skills

| Skill | Role |
| --- | --- |
| `expo-router-composition` | Copy lives in screen/section components, not route files |
| `expo-shadcn-design-system` | Text/typography component to use as `Trans` parent |
| `copy-style` | No Oxford comma / no em dash, applied to all user-facing copy here |
