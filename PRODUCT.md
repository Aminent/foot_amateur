# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

The repository ships three surfaces: two React web apps (admin panel, scouting space) and one Flutter mobile app distributed as an Android APK (coach, player and match-delegate profiles). The `web` value covers the admin and scouting apps; mobile work should load Android guidance.

## Users

FootPro serves four confirmed user groups, all treated as primary:

- **Organiser (admin, web):** a league or academy that runs competitions: creates tournaments, teams, players, coaches, referees and match delegates, schedules fixtures, assigns delegates and validates results.
- **Scout (web):** a recruiter who searches, compares, follows and evaluates amateur players using match-derived data.
- **Coach (mobile):** manages a club's squad, line-ups, trainings and attendance, follows standings and player statistics, applies to tournaments.
- **Player (mobile):** follows personal statistics, matches, trainings, rewards and badges.

A fifth role, the **match delegate (mobile)**, records the facts of an assigned match live, from the pitch side (clock, goals, assists, cards, substitutions).

## Product Purpose

Run amateur football competitions end to end and turn what happens on the pitch into reliable, shared data: scores, standings, brackets, player statistics and scouting profiles, all kept consistent across every app.

## Positioning

- **Everything comes from the pitch.** Facts recorded live by the delegate are the single source of truth: score, winner (shoot-outs included), bracket progression, league table and player statistics are derived from them automatically and appear everywhere at once.
- **A bridge to scouting.** The same match data makes amateur talent visible to recruiters, with searchable, comparable player profiles.

## Operating Context

- Interface language: French. Data is Moroccan amateur football (Casablanca clubs, academies, local venues).
- Tournament formats: league, knockout, groups then knockout. Statuses: registrations open, active, finished.
- Match flow: scheduled → kick-off → half-time → second half → full time; live updates pushed in real time (sockets).
- The admin works at a desk; the delegate works outdoors at the pitch side on a phone; coaches and players use the mobile app on the go.

## Capabilities and Constraints

- **Redesign constraint (confirmed):** keep the same content and the same features. A redesign changes the look and the experience, not what the product does or says.
- Stack in place: Express + PostgreSQL backend; admin and scouting in React with MUI; mobile in Flutter. Admin and scouting are served by the backend (`/` and `/scout`).
- Statistics such as goals, assists, cards, minutes, clean sheets and matches played are derived from match facts and are read-only in the UI; detailed stats (shots, passes, tackles…) are entered by the admin.
- Referees have no app; they are managed by the admin only.
- Undecided: whether the redesign covers all three surfaces at once or one at a time.

## Brand Commitments

- Product name: FootPro (logo mark in the admin and scouting sidebars, "Foot Amateur" title on the mobile login screen).

## Evidence on Hand

- Real test dataset (3 tournaments, 16 clubs, 288 players, match facts) in `database/football_amateur.sql`.
- Current screenshots of admin and scouting in `captures/` (git-ignored) with an English walkthrough `captures/FootPro-guide.html`.
- No testimonials, client logos, usage figures or press exist; do not fabricate them.

## Product Principles

1. **One truth, shown everywhere.** Any number on screen must match the same number on every other screen; derived data is never editable by hand.
2. **The live moment matters most.** Recording and following a match in real time must be fast, legible and unmistakable.
3. **Data makes players visible.** Statistics and profiles should help a scout notice talent, not just list numbers.
4. **Same product, better experience.** Improve clarity and craft without removing or renaming features.
