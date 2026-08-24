# Anti-vibe UI — reference catalog

Tiered tells for generate and audit modes. **Stack signs, never single ones.** Flag a cluster when ≥3 Critical or ≥5 Contextual tells co-occur without brief justification.

Companion skill body: [SKILL.md](SKILL.md).

---

## Critical

High diagnostic weight when clustered. Do not ship unless the brief explicitly requires them.

| Tell | Why it reads as AI | False positive / when OK |
|------|--------------------|--------------------------|
| Harsh purple / indigo / pink / rainbow / neon **gradient heroes**, gradient buttons | Strongest color fingerprint; Tailwind demo median | Brand book mandates that exact gradient |
| **Gradient text** (`bg-clip-text` headlines) | Equally loud cousin of gradient heroes | Rare brand wordmark effects with restraint |
| Purple + black + glow | Strong in combo with Inter + 3 cards | Linear-era purple alone is not enough |
| Decorative **aurora blobs**, **radio orbs**, glow blobs behind hero | Default “atmosphere” with no subject | Real photographic bokeh / product light |
| **Dot grids** as background texture | Stock SaaS wallpaper | Technical diagrams that need a grid |
| **Emoji as UI chrome**; Sparkles in badges/CTAs | Decorative AI badge energy | Emoji in user-generated content |
| **Lucide-five as decoration**: Sparkles, Zap, Shield, Check, ArrowRight on every CTA | Icon soup without meaning | One purposeful icon per action |
| **Liquid glass** / reflexive `backdrop-blur` everywhere | Glass without an overlay-on-image problem | Frosted nav over a real photo/video |
| **Colored left stripe** on cards (thick asymmetric accent border) | Template card accent | Real editorial pull-quote rules |
| Default **three equal feature cards** (`lg:grid-cols-3`, icon + title + body) | Strongest layout tell (~70% of AI landings) | Three real, unequal offerings with distinct jobs |
| Uniform **fade-up on scroll** (`opacity: 0, y: 20` every section) | #1 motion fingerprint | One orchestrated entrance, not every block |
| Uniform card hover: **`scale-105` + bigger shadow** | Hover for its own sake | Focused interactive affordance on one control |
| **Fake testimonials** (stock faces, invented titles, yellow five-star rows) | Trust theater | Real named quotes you can defend |
| Em dashes as clause breaks; **"it's not X, it's Y"**; vague “transform how you work” | Copy crutches | `copy-style`; never reintroduce |
| Pure **`#ffffff` / `#000000`** as only atmosphere | Untinted void + gray-50 on gray-50 | High-contrast a11y surfaces with intentional tint elsewhere |
| Cookie-cutter page order: hero → logo wall → 3 cards → testimonials → pricing → FAQ → 4-col footer | Macrostructure autopilot | Same sections only when content truly needs them, with hierarchy |

---

## Contextual

Ban the reflex, not the tool. Justify against the brief or skip.

| Tell | Why it clusters | When it is OK |
|------|-----------------|---------------|
| **Lucide** as the icon set | Weak alone; library ≠ fingerprint | Project stacks standardize on it; ban decorative Lucide-five overuse |
| Soft **corner radius** as a token | Weak alone | Fine as design token; bad when every surface is `rounded-2xl` |
| Soft **`rounded-2xl` + `shadow-md` on every surface** | Strong combo with equal cards | One elevated surface, flat elsewhere |
| **Hover animations** generally | Weak alone | Purposeful feedback; kill uniform card scale |
| **Checkmark bullets** as only list pattern | Pricing/feature filler | Real feature lists with varied structure |
| **Bento grids** as default decoration | Rising AI default | Asymmetric, content-led mosaic |
| Fake **terminal window** heroes | CLI cosplay | Real CLI / docs products showing real output |
| Exactly **three pricing tiers** with middle “Most Popular” | SaaS template | Real plans that happen to be three, with honest differentiation |
| **Animated arrows** / ArrowRight on every link | CTA chrome | One primary CTA treatment |
| **Pastel / timid even-weight palettes** | No committed accent | Soft brand with one decisive hue |
| Inter / Geist / Space Grotesk / Instrument Serif when **unchosen** | Mono-font stack tell | **Project override**: keep if design-system / AGENTS already chose them |
| Untouched **shadcn** radius/color/type | Theme never customized | Themed tokens matching the brief |
| Genre-blind SaaS nav + Product/Company/Resources/Legal footer | Generic IA | Real IA for that product |

---

## Second-wave defaults

Models fled purple into new medians. Do not “fix” purple by landing here without a brief.

| Tell | Notes |
|------|--------|
| Warm cream (~`#F4F1EA`) + terracotta + oversized italic serif | Post-purple default; also flagged by frontend-design |
| Near-black + single acid green / vermilion glow | Second median “bold” look |
| Broadsheet hairline / zero-radius newspaper columns on unrelated products | Legitimate for some briefs; default for none |
| Emerald (`#10B981`) as automatic “not purple” accent | Fallback hue swap |
| Hero formula: eyebrow pill + huge H1 + dual CTA (“Get started” / “Learn more”) | Structure without thesis |
| Decorative `01 / 02 / 03` markers | OK only when order is real information |
| Logo soup / fabricated “Trusted by” | Vague or fake logos |
| Implausible animated **stat counters** | Fake social proof |

---

## Craft floor (missing craft ≠ visual slop, still required)

| Requirement | Why |
|-------------|-----|
| Subject-grounded **visual anchor** (product, place, material, atmosphere) | Decorative gradients do not count as the main idea |
| Clear **hierarchy** (not three equal cards doing one job) | Structure is information |
| Intentional **type pairing** or project tokenized faces | Personality without unchosen mono-stack |
| Async UI: **skeletons** or honest loading; real empty and error states | Polish floor |
| `prefers-reduced-motion`, visible `:focus-visible`, non-default `::selection` when branding allows | a11y + craft |
| Public marketing: working **Privacy** and **Terms** (or equivalent); no fabricated trust badges | Legitimacy |

---

## Authenticity

| Do | Don't |
|----|--------|
| Real product screenshot or interactive demo | Isometric filler, abstract blobs as “the product” |
| Cut trust sections when you lack proof | Invented customers, counts, SOC badges, press logos |
| Honest empty/error copy | Fake five-star rows and stock avatars |

---

## Generate — quick checks

Before shipping UI:

1. Subject, audience, and one page job named?
2. Direction avoids Critical + Second-wave clusters unless brief demands them?
3. Visual anchor is subject-real, not decorative atmosphere?
4. Project design-system fonts/icons kept; rest of cluster broken?
5. Motion: orchestrated, not uniform fade-up / scale-105 everywhere?
6. Copy: no em dashes, no “it's not X, it's Y”, no vague transform-speak?
7. Trust: only real proof; Privacy/Terms present on public marketing?

---

## Audit — cluster rule

- **Cluster?** yes if ≥3 Critical **or** ≥5 Contextual without brief justification.
- Report Critical / Contextual / Missing craft / Fixes (concrete replacements). See template in [SKILL.md](SKILL.md).

---

## Not standalone bans

Do **not** flag these alone:

- Lucide as a dependency
- Hover motion in general (kill uniform card hover only)
- Soft radius as an intentional design token
- Skeleton loaders as a “vibe” marker (still require them for async UI)

---

## Sources

Consensus distilled from:

- [febbhav/signs-of-ai-design](https://github.com/febbhav/signs-of-ai-design) — stacked visual/copy tells
- [Nutlope/hallmark anti-patterns](https://github.com/Nutlope/hallmark/blob/main/skills/hallmark/references/anti-patterns.md) — generation anti-patterns (adopt tells, not the full macrostructure system)
- Companion positive craft: personal **frontend-design** skill; project **nextjs-web-design-system** wins on intentional stack choices
