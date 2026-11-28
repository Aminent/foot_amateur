---
version: 1
slug: "frontend-src-pages-admindashboard-js"
primary_target: "frontend/src/pages/AdminDashboard.js"
related_targets: ["frontend/src/components/Layout/AdminLayout.js","frontend/src/pages/TournamentDetails.js","frontend/src/pages/LiveMatch.js"]
---

# Surface: admin web panel (frontend/)

Mode: Operate. Audience: league/academy organiser at a desk, large screen. Tasks (all frequent): follow matches (today, Live Mode, results), organise tournaments (fixtures, bracket, delegates, referees), manage records (teams, players, coaches, stats). Constraint: same content and features; desktop first. Failure to avoid: generic SaaS dashboard.

## Direction contract

THESIS: The admin reads like an organised stand on derby day: every club carries its real colours as a knitted scarf stripe, so a table of matches or a league table is recognisable at a glance. Refuses the grey-card SaaS dashboard with one blue accent.

OWN-WORLD: Stand concrete ground (warm light grey #f1efe8), charcoal rail (#1d2320), flare orange (#ff5a1f) as the only UI accent (primary actions, selection, live), club colours only inside scarf stripes. Barlow for UI, Barlow Condensed for titles and big numbers; tabular figures everywhere. Flat panels on hairline borders, 8-10px radius, no gradients, no glass.

STORY: The organiser sees what is live and what is next, recognises clubs by colour before reading names, acts (plan, edit, enter result, open Live) from standard buttons and tables.

FIRST VIEWPORT: Charcoal rail left (brand, ten sections, active item marked by an orange inset bar). Content on concrete: page title in condensed caps-weight, KPI tiles with big condensed numbers, then the main table. Match rows: home club right-aligned to a centre score column, away club left, each with its scarf stripe; live match tinted and marked by the orange live dot. Primary action (Nouveau / Planifier) top right in orange.

FORM: Tribune & tifo, position 7 of 7 on the grounded list, seed:07bf9c4ae35d6f23. Raises: home/away symmetry around a centre line (labanotation); two hard halves in match timelines (cassette j-card); dense tabular figures (datamatics); stats bars on one shared scale (botanical folio); selected row lifts, others recede (streaming wall).

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
