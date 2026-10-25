---
name: GRUP
description: Group event scheduling where every event answers "who's coming?"
colors:
  harbour-navy: "#415E91"
  harbour-navy-container: "#D7E3FF"
  on-harbour-navy-container: "#284777"
  lagoon-teal: "#00A4B8"
  lantern-olive: "#CCCB76"
  lantern-olive-container: "#4A4900"
  pitch-green: "#00623F"
  yes-green: "#2E7D32"
  no-red: "#BA1A1A"
  no-red-night: "#FFB4AB"
  day-surface: "#F9F9FF"
  day-ink: "#191C20"
  day-ink-muted: "#44474E"
  day-container: "#EDEDF4"
  day-container-high: "#E7E8EE"
  day-container-highest: "#E2E2E9"
  day-outline: "#74777F"
  night-surface: "#14140C"
  night-ink: "#E6E3D5"
  night-ink-muted: "#CAC7B6"
  night-container: "#202018"
  night-container-high: "#2B2A22"
  night-container-highest: "#36352C"
  night-outline: "#939181"
typography:
  wordmark:
    fontFamily: "Sniglet, Cabin, sans-serif"
    fontSize: "32sp"
    fontWeight: 400
    lineHeight: 1.25
  headline:
    fontFamily: "Cabin, sans-serif"
    fontSize: "28sp"
    fontWeight: 400
    lineHeight: 1.29
  title:
    fontFamily: "Cabin, sans-serif"
    fontSize: "22sp"
    fontWeight: 400
    lineHeight: 1.27
  title-small:
    fontFamily: "Cabin, sans-serif"
    fontSize: "16sp"
    fontWeight: 500
    lineHeight: 1.5
    letterSpacing: "0.15sp"
  body:
    fontFamily: "Cabin, sans-serif"
    fontSize: "16sp"
    fontWeight: 400
    lineHeight: 1.5
    letterSpacing: "0.5sp"
  body-small:
    fontFamily: "Cabin, sans-serif"
    fontSize: "14sp"
    fontWeight: 400
    lineHeight: 1.43
    letterSpacing: "0.25sp"
  label:
    fontFamily: "Cabin, sans-serif"
    fontSize: "14sp"
    fontWeight: 500
    lineHeight: 1.43
    letterSpacing: "0.1sp"
rounded:
  sm: "12dp"
  md: "16dp"
  lg: "28dp"
  full: "999dp"
spacing:
  xs: "8dp"
  md: "16dp"
  xl: "32dp"
components:
  reply-yes-active:
    backgroundColor: "{colors.yes-green}"
    textColor: "#FFFFFF"
    rounded: "{rounded.full}"
    size: "40dp"
  reply-no-active:
    backgroundColor: "{colors.no-red}"
    textColor: "#FFFFFF"
    rounded: "{rounded.full}"
    size: "40dp"
  reply-unanswered:
    textColor: "{colors.day-ink-muted}"
    rounded: "{rounded.full}"
    size: "40dp"
  headcount:
    typography: "{typography.headline}"
    padding: "4dp 16dp 8dp"
  answer-header:
    backgroundColor: "{colors.day-surface}"
    typography: "{typography.title-small}"
    padding: "0 16dp"
  fab-extended:
    backgroundColor: "{colors.harbour-navy-container}"
    textColor: "{colors.on-harbour-navy-container}"
    typography: "{typography.label}"
    rounded: "{rounded.md}"
    height: "56dp"
  button-filled:
    backgroundColor: "{colors.harbour-navy}"
    textColor: "#FFFFFF"
    typography: "{typography.label}"
    rounded: "{rounded.full}"
    height: "40dp"
    padding: "0 24dp"
  group-row:
    typography: "{typography.title}"
    rounded: "20dp"
    padding: "8dp 16dp"
  feedback-card:
    backgroundColor: "{colors.day-container}"
    rounded: "{rounded.md}"
    padding: "16dp"
---

# Design System: GRUP

## Overview

**Creative North Star: "The Roll Call"**

GRUP is the clipboard at the start of practice: names, and a tick or a cross next to each. Every screen exists to answer one question, "who's in?", and the design's job is to put that answer on screen before anything else. Organisers glance at it minutes before the activity starts, often on a phone, so the system values instant legibility over decoration: counts, names and answers lead, and the chrome stays out of the way.

The world is **quiet Material 3 utility with one wink**. Structure, components and motion are stock Material 3 (`package:material_ui`) on Android, iOS and web, themed through two seed colours and the Cabin typeface. The personality lives in exactly one place: the rounded, cheerful **Sniglet** wordmark "GRUP", and the few onboarding and feedback moments that name it. Everything else is a well-made tool.

Day and night are two moods of the same brand, not an inversion. By day it's a harbour: navy and lagoon teal on a cool, near-white surface. At night it becomes a floodlit pitch: lantern olive and deep greens on a warm near-black. Both come from the brand palette in `lib/app.dart`.

**Key Characteristics:**
- The answer leads: the headcount is the largest text on an event, and yes/no marks are the most saturated things on any screen.
- Stock Material 3 components, themed, never re-invented; `.adaptive()` controls where the OS has trained users.
- One typeface for the UI (Cabin), one wink for the brand (Sniglet).
- Separate day (navy/teal) and night (olive/green) identities.
- Big, friendly group names; small, factual everything else.

## Colors

Two seeded Material 3 schemes, built with `ColorScheme.fromSeed`, plus one fixed attendance green. Widgets read colour **roles** (`colorScheme.primary`, `surfaceContainerHigh`, …). The hexes in the frontmatter are what those roles resolve to today. The seeds in `lib/app.dart` are the source; if a seed changes, regenerate these values.

### Primary
- **Harbour Navy** (day `primary`, seed #34558B): the brand voice by day. The Sniglet wordmark, brand mentions in onboarding copy, filled buttons, the default profile ring. 6.2:1 on the day surface.
- **Harbour Navy Container** (day `primaryContainer`): the extended FAB ("Create or join group", "Manage group").
- **Lantern Olive** (night `primary`, seed #93920B): the same roles at night. A warm, lamplit khaki, 10.9:1 on the night surface.

### Secondary
- **Lagoon Teal** (day `secondary`): rings around group avatars and the group-details picture. It is decorative only, at 2.9:1 on the day surface.
- **Pitch Green** (night `secondary`): the same avatar rings at night. Weak at 2.5:1 on the night surface; see Don'ts.

### Tertiary
- **Meadow Green** (#8BE585 day tertiary, #257F1F night) is set in the theme but no screen uses it. Its generated `tertiaryContainer` resolves to an off-brand pink (#FAD8FD), because only `tertiary` is overridden.

### Neutral
- **Day Surface / Day Ink** (`surface` / `onSurface`): a cool near-white page with near-black text.
- **Day containers** (`surfaceContainerLow` → `Highest`): the resting surface of lifted cards (groups, events), the flat tonal groups ("You" on an event, settings sections, notices like the analytics and feedback cards), and the fill of text fields.
- **Night Surface / Night Ink**: a warm near-black with parchment text. Night containers step the same way.
- **Outlines** (`outline`): the borders of unanswered reply buttons.

### Attendance
- **Yes Green** (#2E7D32, `Colors.green.shade800`, `yesColor` in `reply_button.dart`): an active "yes", a usual "yes" (as an outline), and the thumb on the Yes header. White icons on it (`onYesColor`) pass at 5.1:1, and it stays visible as an outline on both surfaces (3.6:1 at night).
- **No Red** (`colorScheme.error`): an active "no". The theme keeps its accessible pairing (`onError`).

### Named Rules
**The Answer Colour Rule.** Yes Green and the error red mean *yes* and *no*, and nothing else. No decorative green, no red for anything but "no" and real errors. When colour appears on a screen, it should be telling the organiser who is coming.

**The Role, Not Hex Rule.** Widgets take colour from `ColorScheme` roles so day and night resolve on their own. `yesColor` and its `onYesColor` are the only raw colours, chosen to work on both themes.

**The Night Shift Rule.** Night is its own identity (olive and green on warm black). Don't derive it by darkening the navy, and don't "fix" it towards blue.

## Typography

**Display Font:** Sniglet (with Cabin fallback), bundled in `assets/google_fonts/`; runtime fetching is off.
**Body Font:** Cabin, applied app-wide through `ThemeData.fontFamily` and on the Material 3 type scale.

**Character:** Cabin is a humanist sans with slightly soft terminals: friendly but businesslike, and legible at list sizes. Sniglet is round and bubbly, a one-word signature, never a working typeface.

### Hierarchy
Sizes come from the Material 3 type scale in `sp`, so they follow the system font-size setting.
- **Wordmark** (Sniglet 400, `headlineLarge` 32sp, in `primary`): "GRUP" in the home app bar. Inline Sniglet spans in `primary` mark the brand name in onboarding and feedback copy, and the feedback card's title is Sniglet at 24.
- **Headline** (Cabin 400, 28sp): at 600 weight, the headcount on an event ("5 coming").
- **Title** (Cabin 400, 22sp): group names on their home cards (big enough to read as a place, small enough for "Tuesday Five-a-side" on one line at phone width), and app-bar titles: the group's name on the group screen, the event's name on the event screen.
- **Title small** (Cabin 500, 16sp): list-tile titles. Event names, member names, the Yes / No reply yet / No headers.
- **Body** (Cabin 400, 16sp): onboarding and descriptive copy, centred in empty states.
- **Body small** (Cabin 400, 14sp): list-tile subtitles. Event time and headcount ("10:00 AM · **5 coming** +2 usually", the count in Label weight when it isn't zero), a member's usual answer.
- **Label** (Cabin 500, 14sp): buttons, the FAB and badges.

### Named Rules
**The One Wink Rule.** Sniglet appears only for the GRUP name and the feedback card's title. Never use it for buttons, labels, data, headings or numbers.

**The Scale Rule.** Text maps to a Material 3 role (`theme.textTheme.*`). Don't hand-pick font sizes per screen; the wordmark's base size comes from the scale too.

## Layout

Single column on every size, built from Material slivers. A pinned or floating `SliverAppBar` sits on top, lists scroll underneath, and the one primary action is an extended FAB at bottom right.

- **Gutter:** 16dp around blocks of content, plus `ListTile`'s own 16dp insets.
- **Rhythm:** 8dp between list rows (group list, reply buttons), 16dp inside blocks, 16dp above each answer section on an event.
- **Events by day:** a group's events are shown one day at a time, under a date row (‹ date ›) pinned in the app bar; swiping sideways also moves days (`DayPager`). Opened without a date, a group lands on its next event, not on an empty today. An empty day says so and offers "Next: {event}, {date}".
- **Event detail:** the headcount block leads (group · date · time, then "**5 coming** +2 usually", then "3 no reply · 2 out"), then "You", then members grouped Yes → No reply yet → No. Each group's header pins only while its own members scroll by (`SliverMainAxisGroup` + `PinnedHeaderSliver`), so headers hand over instead of stacking.
- **Text size:** no fixed heights on headers; the date row grows with the text scale. Short count phrases are kept on one line (`keepTogether`).
- **Pull to refresh** on the group's day list and on the event, with the empty states scrollable so it works there too.
- **Edge-to-edge:** content clears system bars with `SafeArea` and the bottom view padding (Android 15 enforces edge-to-edge).
- **Wide screens:** chosen by window width, never by platform (iPad split view and browser windows resize). From Material's expanded width (840dp) a group is two panes (`TwoPane`): the day's list on the left (40% of the window, 360–480dp) and the open event on the right, capped at 640dp and centred in its pane so answers stay near the names, under one outer `Scaffold` so a snackbar shows once. The group's address opens its first event of the day; an event's address keeps its URL and opens next to its day, with no page transition, and the list's back button leaves the group. The open event's row sits on `secondaryContainer`, without recolouring its answer buttons. Every other page, and a group or event below 840dp, is one column capped at 640dp and centred (`ReadableWidth`). Sheets stay modal bottom sheets, centred at their 640dp maximum.

## Elevation & Depth

Depth comes from Material 3 tonal surfaces and stock component elevation, never custom shadows. The things an organiser acts on rest on level 1: each group on home and each event in a group's day is a `Card()` (`surfaceContainerLow`, 20dp corners, 16dp side margins, ripple clipped to the shape). The FAB keeps level 3; sheets and dialogs keep theirs. Groupings that aren't one tappable unit use flat `Card.filled`: the "You" row on an event, settings sections, the analytics card and the first-run example.

Lift is structural (it separates units of action), never decorative glow. The roster's member rows stay flat: only some are tappable, and a dozen cards is noise.

### Named Rules
**The Material Levels Rule.** Elevation uses the Material 3 levels (0, 1, 2, 3, 4, 5) and their tonal surfaces. Never use an arbitrary `BoxShadow`, coloured shadow, or blur.

**The Lift Means Tappable Rule.** If it's raised, it's something you act on (an event, a group, a sheet). Section headers, notices and empty states stay flat.

## Shapes

Material 3's rounded, friendly geometry, slightly softened: pill-shaped (stadium) buttons, a 16dp-rounded extended FAB, 20dp cards (`cardTheme` in `lib/app.dart`), filled text fields with 16dp corners and no outline (`appInputDecorationTheme`, mirrored on the sign-in screen), filled buttons at least 48dp tall, 28dp dialogs and bottom-sheet tops. Circles carry identity. Avatars and group pictures are circles inside a thin coloured ring (`ProfilePicture`), and reply buttons are circular icon buttons. The custom shapes are the 20dp cards, the 16dp filled fields and the feedback card's 16dp rounding.

## Components

### Reply Buttons (signature)
The heart of the product: a thumbs-up / thumbs-down pair (Font Awesome thumbs) beside every event and every member.
- **Shape:** circular icon buttons (40dp visual, 48dp touch target on mobile), 8dp apart.
- **Unanswered:** outlined, with hollow thumbs in the default ink.
- **Usual answer showing** (from the member's usual answer, nothing answered yet): outlined in the answer's colour, with a solid thumb in that colour. It says "you're counted as yes" without claiming you've answered.
- **Answered:** filled with Yes Green or the error red, with a solid white (`onYesColor` / `onError`) thumb.
- **Read-only** (someone else's answer, for non-admins): no buttons, just the mark: a filled or outlined circle with the solid thumb, in its 48dp slot so rows line up, and nothing at all when there's no answer. Never the framework's faded disabled button.
- **Behaviour:** tapping the current answer clears it. Buttons expose `isSelected`; a usual answer adds the semantics value "usual answer". Tooltips stay "Yes" / "No".

### Headcount (signature)
The number the product exists for, split by how sure it is: confirmed answers, then "+N usually" for people counted only by their usual answer (`Headcount` / `DetailsHeadcount` in `rsvp.dart`).
- **Event screen:** "**5 coming**" in Headline at 600 weight, "+2 usually" in Title medium, muted; below it "3 no reply · 2 out".
- **Group's day list:** in the subtitle, "10:00 AM · **5 coming** +2 usually".

### Answer Sections
On the event screen, in the order the organiser needs: Yes, No reply yet, No. Each header sits on the opaque page `surface`, with the answer's icon in a 14%-tinted circle of its colour (solid green thumb up, hourglass, solid red thumb down) that lines up with the member avatars below, the label in Title medium, and the count trailing in Title large; it pins only while its own members scroll by. Each member row reads to screen readers as "Name, coming" (or not coming, usually coming, no reply yet), and shows their usual answer as a subtitle ("Usually in", "Usually in · On weekdays").

### Usual Answers
The "set it once" feature. "You" invites it ("Set your usual answer", in `primary`) on recurring events; tapping a row opens a bottom sheet titled with whose answer it is and which event, offering only rules that fit the event (every time; weekdays / weekends for a daily event). Hidden for one-off events. Saving or removing confirms with a snackbar and Undo, as does an admin answering for someone else.

### Buttons
- **Primary action:** one extended FAB per screen (Harbour Navy Container, 16dp rounding, icon + label). The one exception is the first-run home (`HomeIntro`): it has no FAB, because its in-flow buttons are the way in.
- **Filled:** stadium-shaped `primary`, used for in-flow confirmations (join group, update app, not-found home).
- **Filled + Text pair:** the first-run home ends with "Start a group" (`FilledButton.icon`, which opens the new-group page on Create) next to "Join with an invite code" (`TextButton.icon`, which opens it on Join).
- **Tonal:** `FilledButton.tonalIcon` inside the feedback card and for an empty day's "Next: …".
- **Destructive:** sign-out and delete-profile tiles take `colorScheme.error` for icon and text.

### Lists
`ListTile` everywhere: groups (a card: ringed avatar + Title large name, up to two lines + one-line faded description), events (a card: Title medium name + local time + reply pair; the open one on `secondaryContainer`) and members (a flat row: initials or photo avatar + name + reply pair; tapping opens the default-answer sheet). The member avatar is a plain `CircleAvatar` hidden from screen readers (the name already says who); "You" gets a `primary` circle with a person icon. Initials skip asides in brackets ("Tom (no app)" is T).

### Group Avatar
`ProfilePicture`: a circle (radius 24 in lists, 128 on group details) with the photo or initials on a light tint of its ring colour, inside a thin `CircularProgressIndicator` ring. The ring doubles as upload progress. Groups use Lagoon Teal and people use Harbour Navy.

### Feedback Card
A dismissible `ExpansionTile` on home: collapsed on `surfaceContainer` with a Sniglet title, expanded on `secondaryContainer` with an email button and a store-review button (red heart).

### Sheets & Dialogs
The default-answer picker is a modal bottom sheet. Confirmations use `AlertDialog.adaptive`, so iOS gets its native alert.

### First Run (`widgets/onboarding.dart`)
The onboarding lives in the empty states and teaches by showing the real thing. There is no tour and no seen-flags: every state comes from data.
- **Home with no groups (`HomeIntro`):** "Welcome to GRUP" (headlineSmall, with the GRUP name in Sniglet) and a one-line tagline. Below them, an example event built from the real pieces: a flat `Card.filled` with a made-up weekly event, the headcount ("1 coming +1 usually"), and three members showing a yes, a usual yes and a no as read-only marks. It ignores taps, and each name tells screen readers that member's answer. A caption explains confirmed and usual answers. Three numbered `SetupStep`s follow (start a group, add its events, invite your people), then the button pair. The page is capped at 560dp wide. While the first load runs, home stays blank instead of welcoming a returning user.
- **New group, admin (`GroupSetup`):** "Get your group going" lists the same steps as a checklist. Each step is done when the data says so: the group exists, it has events, someone else is in it. "Add the first event" opens event creation directly, and "Invite your people" opens manage on the Members tab. The checklist replaces the empty-group state, then stays below the day's events until someone else joins.
- **`SetupStep`:** a `ListTile` with a 32dp outlined circle holding the number in `primary`. When the step is done, the circle becomes `primary`-filled with a check, the title is muted and the hint drops. Never green: green means "yes" (The Answer Colour Rule).
- **New group, member:** the illustration over "no events yet". It says that an admin's events will show up here and take one tap to answer.
- **Name prompt:** on first sign-in the profile page explains, under the name field, that groups see the name next to answers.

### Empty & Error States
Empty: centred body copy, above a full-width illustration (`assets/images/*.webp`). In dark mode the illustration's lightness is inverted while its hues are kept (invert + 180° hue rotation), so the line art turns light and the navy stays blue. A day with no events in a group that has them elsewhere shows no illustration: just the fact and a tonal "Next: {event}, {date}" button. Error: `ErrorNotice` with a cloud-off icon and a retry.

## Do's and Don'ts

### Do:
- **Do** put the headcount and the user's own answer within the first screenful of any event surface, with confirmed and usual answers counted separately.
- **Do** call it a "usual answer" in copy; "default" is the code's word.
- **Do** use `.adaptive()` constructors for dialogs, switches, checkboxes, radios and progress indicators, and stock Material for everything else.
- **Do** read colour from `ColorScheme` roles and text from `theme.textTheme`, so night mode and system font scale work for free.
- **Do** keep one extended FAB per screen for its single primary action.
- **Do** keep touch targets at 48dp minimum, including the reply buttons.
- **Do** test every change in both the day (navy) and night (olive) themes.

### Don't:
- **Don't** use Yes Green or the error red for anything except answers, counts and genuine errors (The Answer Colour Rule).
- **Don't** set Sniglet on anything but the GRUP name (The One Wink Rule).
- **Don't** use `tertiaryContainer` / `onTertiaryContainer`: they resolve to an off-brand pink until the scheme is fixed.
- **Don't** put text in Lagoon Teal (2.9:1) or rely on Pitch Green for anything meaningful at night (2.5:1). They are decorative rings only.
- **Don't** add custom `BoxShadow`s, gradients or glows. Lift uses Material 3 elevation levels.
- **Don't** port Cupertino navigation (tab bars, nav bars) into the app. iOS gets Material plus OS behaviours, not a second design language.
- **Don't** import `package:flutter/material.dart` outside the legacy island (`screens/auth.dart`).
