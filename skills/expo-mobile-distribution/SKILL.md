---
name: expo-mobile-distribution
description: >-
  Use when distributing or releasing an Expo/React Native app to TestFlight or
  Google Play: local EAS builds, credentials setup, store console bootstrap,
  and metadata/screenshot upload (via Fastlane or eas submit + EAS Metadata).
  Triggers: distribute, release, ship, TestFlight, Play Store, EAS build, eas
  submit, Fastlane, store listing.
---

# Expo mobile — distribution to TestFlight / Play

Local EAS builds on your machine, then upload to beta tracks. Two equivalent
toolchains exist — pick whichever the project already uses (or default to
plain `eas submit` for a new project, it needs less setup):

- **Fastlane**: EAS builds, Fastlane lanes handle upload + store metadata.
- **`eas submit` + EAS Metadata**: no Fastlane; `eas submit` uploads binaries,
  `eas metadata` (iOS) and a small script (Android) push store listings.

## Prerequisites (either toolchain)

1. Decrypt secrets (however the project stores them — encrypted files in the
   repo decrypted via a script, or a secrets manager).
2. Install tooling: package manager install, `eas-cli`, Xcode (iOS), Android
   SDK + JDK (Android). Fastlane toolchain also needs `bundle install`.
3. An EAS account authenticated via `EXPO_TOKEN` (`eas whoami` should
   succeed).
4. iOS credentials on EAS (`eas credentials -p ios`) — signing cert + App
   Store provisioning profile.
5. Android upload keystore on EAS (`eas credentials -p android`), or a
   Google Play service-account JSON key with **Release manager** permission.

Verify the whole chain with a `distribute:verify`-style script before
trying a real build, if the project has one.

## One-time store console setup

### iOS — App Store Connect

- Note the bundle ID, App Store Connect team ID, and Apple developer team ID
  — these go in `fastlane/Appfile` (Fastlane) or `eas.json`
  `submit.production.ios` (`ascAppId`) for the plain `eas submit` path.
- Create the app manually in App Store Connect if it doesn't exist yet — App
  Store Connect → My Apps → + → New App.

### Android — Google Play Console

- Note the package name.
- **Play apps cannot be created via API** — create it manually first: Play
  Console → Create app → fill name/language/type/declarations → complete the
  initial setup checklist (app access, ads, target audience, etc.).
- Play Console → Setup → API access → link the GCP project for the service
  account → grant **Release manager**.
- Until the Play app exists, an Android build succeeds but upload fails with
  "Package not found" — this is expected, not a bug in the build.

## Commands (adapt names to the project's actual scripts)

```bash
<pkg-manager> run secrets:decrypt   # if secrets aren't on disk yet
<pkg-manager> run distribute:ios      # → TestFlight
<pkg-manager> run distribute:android  # → Play internal testing
<pkg-manager> run distribute          # both (parallel or sequential per project)
```

## Store listing metadata

- **Fastlane toolchain**: metadata/screenshots live under `fastlane/metadata/`,
  uploaded via a `store-listing:upload`-style script.
- **`eas submit` toolchain**: iOS listing lives in a `store.config.json`, pulled
  live with `eas metadata:pull` and pushed with a `store:upload:ios` script;
  Android listing is plain text files under a metadata directory per locale,
  pushed with a `store:upload:android` script.

Either way: screenshots should be staged/captured first (often via Maestro
driving the app), then uploaded before running the beta build+submit step —
metadata review doesn't block a binary upload, but it's cleaner to have both
ready together.

**iOS listing upload** needs an App Store Connect API key with **App
Manager** (or Admin) access — a Developer-only key can upload TestFlight
builds but not metadata/screenshots.

## Release model

Decide explicitly whether the project ships OTA updates (`expo-updates` /
EAS Update channels) alongside native builds, or is native-build-only (every
release, including JS-only fixes, goes through the store). Document which
model applies — don't assume OTA is available if the project never wired an
update channel.

## After upload

- **TestFlight**: wait for Apple processing (5–30 min), then add
  internal/external testers in App Store Connect → TestFlight.
- **Play internal**: Play Console → Testing → Internal testing → add
  testers.

## Version bumps

Bump `version` in `app.json`; let EAS auto-increment build numbers
(`appVersionSource: remote` in `eas.json`) rather than hand-tracking build
numbers per platform.

## Public release checklist

- [ ] Store screenshots staged for both platforms
- [ ] Description, subtitle, keywords in every supported locale
- [ ] Support + privacy policy URLs live and correct
- [ ] Age rating / content rating questionnaire completed
- [ ] App Privacy (iOS) / Data safety (Android) sections completed — no API
      for these, always manual in each console
- [ ] Submit the processed build for App Review (iOS) / promote internal →
      production (Android)

Public release is manual in each console; there's no API/CLI path for the
review submission itself.

## Troubleshooting

- **EAS auth failing**: check the `EXPO_TOKEN` env var.
- **iOS keychain issues on newer macOS**: some projects need a keychain
  patch script to run automatically before iOS builds — check for one
  before debugging signing from scratch.
- **Play "package not found"**: the Play app hasn't been created yet — do
  that manually first (see above).
- **ASC listing upload fails but binary upload works**: the API key role is
  Developer-only; it needs App Manager for metadata (`deliver`/`eas
  metadata`).
