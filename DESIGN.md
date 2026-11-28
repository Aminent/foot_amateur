---
name: FootPro Admin
description: League and academy back office that reads like an organised stand on derby day.
colors:
  flare: "#ff5a1f"
  flare-deep: "#c8410e"
  flare-ink: "#a3330a"
  flare-wash: "#fdeee6"
  flare-wash-strong: "#fbdccb"
  charcoal-rail: "#1d2320"
  rail-active: "#2c3430"
  rail-text: "#a9ada4"
  rail-text-strong: "#e9e6dc"
  concrete: "#f1efe8"
  paper: "#ffffff"
  terrace-wash: "#ecebe4"
  hairline: "#dcd8cc"
  field-stroke: "#c8c3b5"
  stone-muted: "#6f6a5f"
  stone-secondary: "#57534a"
  pitch-green: "#2f7d4a"
  alert-red: "#dc2626"
  alert-red-ink: "#991b1b"
  card-yellow: "#f5c518"
  card-red: "#d32f2f"
  night-ground: "#171c1a"
  night-paper: "#1f2522"
  night-raised: "#29302c"
  night-line: "#39413c"
typography:
  display:
    fontFamily: "Barlow Condensed, Barlow, sans-serif"
    fontSize: "2.4rem"
    fontWeight: 700
    lineHeight: 1.05
    fontFeature: "tnum"
  headline:
    fontFamily: "Barlow Condensed, Barlow, sans-serif"
    fontSize: "2rem"
    fontWeight: 700
    letterSpacing: "0.01em"
  title:
    fontFamily: "Barlow Condensed, Barlow, sans-serif"
    fontSize: "1.35rem"
    fontWeight: 700
    letterSpacing: "0.01em"
  title-sm:
    fontFamily: "Barlow Condensed, Barlow, sans-serif"
    fontSize: "1.2rem"
    fontWeight: 700
    letterSpacing: "0.01em"
  score:
    fontFamily: "Barlow Condensed, Barlow, sans-serif"
    fontSize: "1.45rem"
    fontWeight: 700
    lineHeight: 1
    letterSpacing: "0.02em"
    fontFeature: "tnum"
  body:
    fontFamily: "Barlow, Segoe UI, system-ui, sans-serif"
    fontSize: "0.95rem"
    fontWeight: 400
    fontFeature: "tnum"
  body-sm:
    fontFamily: "Barlow, Segoe UI, system-ui, sans-serif"
    fontSize: "0.875rem"
    fontWeight: 400
    fontFeature: "tnum"
  button:
    fontFamily: "Barlow, Segoe UI, system-ui, sans-serif"
    fontSize: "0.875rem"
    fontWeight: 600
    lineHeight: "1.25rem"
    letterSpacing: "0em"
  label:
    fontFamily: "Barlow, Segoe UI, system-ui, sans-serif"
    fontSize: "0.72rem"
    fontWeight: 700
    letterSpacing: "0.06em"
rounded:
  scarf: "2px"
  sm: "6px"
  md: "8px"
  lg: "10px"
  xl: "12px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "16px"
  lg: "24px"
  xl: "28px"
components:
  button-primary:
    backgroundColor: "{colors.flare-deep}"
    textColor: "{colors.paper}"
    typography: "{typography.button}"
    rounded: "{rounded.lg}"
    padding: "10px 16px"
    height: "40px"
  button-primary-hover:
    backgroundColor: "{colors.flare-ink}"
    textColor: "{colors.paper}"
  button-secondary:
    backgroundColor: "{colors.paper}"
    textColor: "#3f3c36"
    typography: "{typography.button}"
    rounded: "{rounded.lg}"
    padding: "10px 16px"
    height: "40px"
  button-secondary-hover:
    backgroundColor: "{colors.concrete}"
  input-field:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.charcoal-rail}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.lg}"
  card-panel:
    backgroundColor: "{colors.paper}"
    rounded: "{rounded.lg}"
  kpi-tile:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.charcoal-rail}"
    typography: "{typography.display}"
    rounded: "{rounded.lg}"
    padding: "14px 18px"
  nav-rail:
    backgroundColor: "{colors.charcoal-rail}"
    textColor: "{colors.rail-text-strong}"
    width: "260px"
  nav-item:
    textColor: "{colors.rail-text-strong}"
    rounded: "{rounded.md}"
    height: "44px"
    padding: "0 12px"
  nav-item-active:
    backgroundColor: "{colors.rail-active}"
    textColor: "{colors.paper}"
  table-head:
    backgroundColor: "{colors.concrete}"
    textColor: "{colors.stone-secondary}"
    typography: "{typography.label}"
  chip-live:
    backgroundColor: "{colors.flare-wash}"
    textColor: "{colors.flare-ink}"
    rounded: "{rounded.md}"
    height: "22px"
  chip-scheduled:
    backgroundColor: "{colors.terrace-wash}"
    textColor: "{colors.stone-secondary}"
    rounded: "{rounded.md}"
    height: "22px"
  scarf-stripe:
    rounded: "{rounded.scarf}"
    width: "24px"
    height: "13px"
---

# Design System: FootPro Admin

## Overview

**Creative North Star: "Tribune & tifo"**

The admin panel reads like an organised stand on derby day. The ground is warm stand concrete, the navigation is a charcoal rail, and a single flare orange marks what the organiser can act on and what is live right now. Everything else that carries colour belongs to the clubs: each team wears its two real colours as a knitted scarf stripe, so a fixture list or a league table is recognised by colour before a name is read.

The system is dense and desk-first. Titles and big numbers speak in Barlow Condensed, the terrace-board voice; everything operational speaks in Barlow at small, steady sizes, with tabular figures everywhere so scores, dates and standings line up in columns. Panels are flat white sheets on hairline borders with modest radii; depth comes from tone (concrete under paper, charcoal beside both), not from shadow. Home and away sit symmetrically around a centre score column, the way a match is actually read.

Scope: this system covers the admin web panel (frontend/, admin routes and login). The scouting web app and the Flutter mobile app have not been redesigned yet and are not part of this system; bringing them into it is an open item.

Confirmed rejection: the grey-card SaaS dashboard with one blue accent, which this world replaced (the previous navy and teal look).

**Key Characteristics:**
- Warm concrete ground, white flat panels, charcoal rail.
- One UI accent, flare orange; club colours live only inside scarf stripes.
- Barlow Condensed for titles, KPIs and scores; Barlow for UI; tabular figures throughout.
- Home club right-aligned to a centre score, away club left-aligned from it.
- Live state is one recipe: orange dot, orange-tinted row, deep-orange score.

## Colors

A warm, near-neutral stand palette with one hot accent and club colours confined to their stripes.

### Primary
- **Flare Orange** (flare): the pure accent. Used where it is a mark, not text: the brand tile, the live dot, the global focus outline, the text caret, selection tint (at 22% alpha), the "Pro" in the wordmark, the active rail icon.
- **Flare Deep** (flare-deep): the working orange. Contained primary button fill, live scores, live round labels, outlined-button and selected-menu text. It holds legible contrast on white where pure flare does not.
- **Flare Ink** (flare-ink): primary button hover, text on live chips and orange washes.
- **Flare Wash** (flare-wash) and **Flare Wash Strong** (flare-wash-strong): background of live chips, selected menu items, outlined primary buttons and their hover. Live table rows use flare at 7% alpha.

### Neutral
- **Stand Concrete** (concrete): page background in light mode, table head background, secondary-button hover.
- **Paper** (paper): cards, dialogs, inputs, table bodies.
- **Charcoal Rail** (charcoal-rail): the navigation rail, primary text colour, tooltip fill, goal icons.
- **Rail Active** (rail-active): the active nav item block inside the rail. **Rail Text** (rail-text) and **Rail Text Strong** (rail-text-strong) are the rail's icon and label tones.
- **Terrace Wash** (terrace-wash): neutral chip fill (Planifié). Completed matches use a slightly deeper wash (#e3e0d6) with charcoal text.
- **Hairline** (hairline): every card, paper and table border, dividers.
- **Field Stroke** (field-stroke): input and secondary-button borders.
- **Stone Secondary** (stone-secondary) and **Stone Muted** (stone-muted): secondary text and helper text, table head labels.
- **Night set** (night-ground, night-paper, night-raised, night-line): the dark-mode equivalents of concrete, paper, input fill and hairline. Dark primary text is concrete.

### Semantic
- **Pitch Green** (pitch-green): active/positive state markers (active player dot, running match clock). **Alert Red** (alert-red) and **Alert Red Ink** (alert-red-ink): errors, destructive buttons, delete hover.
- **Card Yellow** (card-yellow) and **Card Red** (card-red): reserved for drawn disciplinary cards in match facts.

### Named Rules
**The One Flare Rule.** Flare orange is the only interface accent: primary actions, selection, focus, live. No second accent hue is introduced for UI chrome.

**The Club Colours Stay On The Scarf Rule.** A club's own colours appear only inside its scarf stripe (or its large scarf on the Live screen). They never tint a row, a chip, a heading or a button.

**The Flare Ink Rule.** Orange text and orange fills under white text use flare-deep or flare-ink. Pure flare is for dots, marks, outlines and tints.

## Typography

**Display Font:** Barlow Condensed 700 (with Barlow, sans-serif)
**Body Font:** Barlow 400 / 700 (with Segoe UI, system-ui, sans-serif)

Both families are self-hosted (latin and latin-ext woff2, weights 400 and 700, font-display swap). `font-variant-numeric: tabular-nums` is set on body, so every figure in the product is tabular.

**Character:** Condensed, sturdy terrace-board capitals for anything you read from across the room (page titles, KPIs, scores, section names) over a plain, friendly grotesque for the operational detail.

### Hierarchy
- **Display** (Condensed 700, 2.4rem, 1.05): KPI tile numbers.
- **Headline** (Condensed 700, 2rem, 0.01em): page title at the top of each admin section.
- **Title** (Condensed 700, 1.35rem): tournament group headings, dialog titles; **Title Small** (1.2rem) for section-card headers and round labels (1.1rem).
- **Score** (Condensed 700, 1.45rem, line-height 1, 0.02em): the centre score in match rows; kick-off times in the same column drop to 1.05rem in secondary text.
- **Body** (Barlow 400, 0.95rem): default text, rail labels; **Body Small** (0.875rem) for table cells, inputs, menus.
- **Label** (Barlow 700, 0.72rem, 0.06em, uppercase): table column heads, and at 0.75rem the section labels inside dialogs.
- **Button** (Barlow 600, 0.875rem, no transform, no tracking).

### Named Rules
**The Two Voices Rule.** Condensed speaks headings and numbers; Barlow speaks everything you operate. Never set body copy, labels or buttons in Condensed.

**The Tabular Rule.** Figures are always tabular so columns of scores, dates and standings align.

## Layout

A fixed charcoal rail on the left (260px expanded, 52px collapsed, toggled with Ctrl+B and auto-collapsed under 900px) and content on concrete to its right. The content opens with the page title and a top-right primary action, then a row of five KPI tiles, then a filter/action toolbar and the main tables.

Spacing runs on MUI's 8px base: 8px inside clusters, 16px between controls, 24px between blocks; dialogs pad at 28px horizontally. Tables are the main surface: column heads on concrete, 10px row padding, match rows symmetric around a fixed 96px centre score column, with home and away columns at equal widths (21%).

Desktop first. Under 600px, `.hide-mobile` content drops; mobile is a secondary concern for this panel.

## Elevation & Depth

Flat by default. Depth is tonal: paper sits on concrete, separated by a 1px hairline; the charcoal rail sits beside both. Cards and KPI tiles carry no shadow. Contained and outlined buttons carry a barely-there 1px shadow (`0 1px 2px rgba(29,35,32,0.05)`). Only things that float above the page cast a real shadow: dialogs (`0 24px 48px -12px rgba(29,35,32,0.35)`) over a charcoal scrim at 45%, plus menus and popovers.

### Shadow Vocabulary
- **Button rest** (`box-shadow: 0px 1px 2px rgba(29,35,32,0.05)`): contained and outlined buttons.
- **Dialog lift** (`box-shadow: 0 24px 48px -12px rgba(29,35,32,0.35)`): modal dialogs only.
- **Focus halo** (`box-shadow: 0 0 0 4px rgba(255,90,31,0.20-0.25)`): focused primary buttons and inputs.

### Named Rules
**The Flat Panel Rule.** Panels lie flat on hairlines. A shadow means the element floats above the page (dialog, menu, popover), never that it is important.

## Shapes

Gently rounded, never pill-shaped. Buttons, inputs, selects and cards use 10px; papers and dialogs 12px; rail items, icon buttons and alerts 8px; chips 8px in tables (theme default 6px), tooltips and menu items 6px. The scarf stripe has a near-square 2px corner, so it reads as knitted cloth rather than a badge. Live dots are full circles; drawn disciplinary cards are 11 by 15px rectangles with a 2px corner.

## Components

### Buttons
Standard, solid and quiet; the orange carries the weight.
- **Shape:** gently rounded (10px), heights 36 / 40 / 44px.
- **Primary:** flare-deep fill, white label, 1px same-colour border, 10px 16px padding. One per view, top right (Nouveau, Planifier un match).
- **Hover / Focus / Active:** hover deepens to flare-ink; focus adds a 4px flare halo at 25%; press nudges down 1px. Transitions 0.12 to 0.15s ease.
- **Secondary (outlined):** white fill, #3f3c36 text, field-stroke border, concrete hover. Outlined primary uses flare-wash fill with flare-ink text.
- **Destructive:** alert-red fill or red-bordered outline.

### Chips
- **Style:** 22px high, 0.72rem 600, no border, wash fill with ink text.
- **Status set:** Planifié (terrace-wash / stone-secondary), En direct and Mi-temps (flare-wash / flare-ink), Terminé (#e3e0d6 / charcoal), Reporté (amber wash), Annulé (red wash).

### Cards / Containers
- **Corner Style:** 10px.
- **Background:** paper on concrete.
- **Shadow Strategy:** none (see Flat Panel Rule).
- **Border:** 1px hairline.
- **Internal Padding:** section-card header 20px by 12px with a hairline under it; KPI tile 18px by 14px.

### KPI Tile
A white tile with a 16px muted icon and a 0.8rem 600 label in secondary text, then the value in Display Condensed. The value counts up on load.

### Inputs / Fields
- **Style:** white fill, field-stroke 1px border, 10px radius, 0.875rem text, small size by default.
- **Focus:** border turns flare-deep with a 4px flare halo at 20%; the label turns flare-ink.
- **Error / Disabled:** alert-red border and helper text; disabled fill is concrete.

### Navigation
The charcoal rail. Brand tile (34px flare square with white ball) and the FootPro wordmark in Condensed 1.45rem, "Pro" in flare. Ten section items, 44px high, 8px radius: rail-text icons and rail-text-strong labels at rest, a 6% concrete wash on hover, and when active a rail-active block, a flare icon and a white bold label. Focus draws a 2px flare ring. The footer holds the light/dark toggle and the user block separated by 8%-alpha hairlines. Collapsed, labels fade and tooltips take over.

### Match Row (signature)
The home club name right-aligned with its scarf to its right, the score centred in Condensed, then the away scarf and name left-aligned. The winner's name goes to 700. A live match tints the whole row with flare at 7%, sets the score in flare-deep, and its round heading gains a flare dot with "En direct". Scheduled matches show the kick-off time in the score column instead.

### Scarf Stripe (signature)
The club's two colours knitted as hard-stop vertical stripes (first colour three parts, second colour two), 24 by 13px (18 by 10 small, 34 by 18 large, 56 by 22 on the Live header), 2px corner, a 1px inset charcoal edge at 14% so pale club colours hold against white. Decorative (aria-hidden); the club name always accompanies it. Missing colours fall back to stone tones.

### Match Fact Icons
Goals, penalties, assists, substitutions and injuries use filled Material pictograms in charcoal, stone-secondary or red-ink. Yellow and red cards are drawn as real cards (11 by 15px rectangles) in card-yellow and card-red.

## Do's and Don'ts

### Do:
- **Do** keep flare orange the only interface accent, and write orange text in flare-deep (#c8410e) or flare-ink (#a3330a).
- **Do** give every club appearance a scarf stripe beside its name, in tables, standings, brackets and the Live header.
- **Do** set titles, KPIs and scores in Barlow Condensed 700 and keep every figure tabular.
- **Do** align home to the right of a centre score column and away to its left.
- **Do** mark live with the one recipe: flare dot, 7% flare row tint, flare-deep score, "En direct" chip.
- **Do** keep panels flat on 1px hairlines with 10px corners; reserve shadows for dialogs, menus and popovers.

### Don't:
- **Don't** use club colours outside the scarf stripe, and don't add a second UI accent hue.
- **Don't** use decorative gradients or glass on surfaces; the scarf's hard-stop knit is the only gradient in the world.
- **Don't** put flare orange (#ff5a1f) behind white text or use it for body-size text.
- **Don't** set buttons, labels or body copy in Condensed, or uppercase anything but small tracked labels (table column heads, dialog section labels).
- **Don't** use emoji as icons; use Material pictograms or the drawn cards.
- **Don't** return to the navy-and-teal, grey-card SaaS look this world replaced.
