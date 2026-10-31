---
version: 1
slug: "lib-presentation-screens-group-plan-dart"
primary_target: "lib/presentation/screens/group_plan.dart"
related_targets: ["lib/presentation/screens/group_manage.dart"]
---

## Scope

The paid-plan flow on the web: the plan card at the top of Manage → Members, the group's plan page (`GroupPlanRoute`), and the upgrade sheet that ends at Stripe Checkout. Mode: Persuade, inside an Operate app; it inherits GRUP's established world. Web only and admins only (`GroupAccess.purchaseUi`, billing doc F9): the native apps show no plan names, prices or purchase links.

## Audience and job

The organiser of a group that is filling up, or that wants deadlines, the kitchen view or the export. They should come away believing a plan is simple, fairly priced and made for groups like theirs, and act: pick a size, pick monthly or yearly, continue to payment. Proof is the product's own facts only: spots, the three perks, the price, VAT included, the founder discount, the first payment date. No testimonials or invented claims.

## Constraints

Plan codes and Stripe lookup keys stay `community_{s,m,l}`; only display names change (Crew, Club, Crowd, in English in every locale). Code checks feature and limit keys, never plan names. Founding groups never have a spot limit, so size only sets their price. Band changes for a paid group go through Stripe's portal (Manage billing).

## Direction contract

THESIS: The plan page is the group's calm status board: its plan as a Sniglet mark over its people as spots. Buying happens in a short sheet that asks one question at a time (size, then monthly or yearly) and ends in "Continue to payment". It refuses the category default of a three-column pricing table with repeated feature lists and "Subscribe" buttons.

OWN-WORLD: GRUP's established world: stock Material 3, Cabin, day navy and night olive tonal surfaces, 20dp cards, pill buttons. One widening of the One Wink Rule: plan names (Free, Crew, Club, Crowd) are Sniglet marks in `primary`. That covers plan names only, never prices, counts, buttons, headings or body text. The spots meter has one dot per spot, `primary` filled per person and `outlineVariant` rings when empty. A group with no limit gets a count instead of dots. No new colours, shadows or gradients. Red only for a failed payment.

STORY: On the web, the organiser sees in Manage how full the group is and that Crew, Club or Crowd make room. They open the plan page and read what a plan adds in plain words. They take the size the sheet already suggests, choose monthly or yearly, and continue to Stripe knowing the price, VAT, any founder discount and the first payment date. When they come back, the plan switches on with one small celebration.

FIRST VIEWPORT (390×844, Free group): the group name in the app bar. "Free" in Sniglet at 36sp, `primary`, with "8 of 10 spots taken" under it. A row of ten dots, eight filled, captioned "Pending invites hold a spot too". "Every plan includes" over four rows: room to grow, answer deadlines, kitchen view, spreadsheet export, each an icon, a name and one plain sentence. A full-width FilledButton "Choose a plan" with "Plans from CHF 9 a month" beneath. All of it sits above the fold. In the sheet, step 1 has three tappable size cards (mark, "Up to N people", monthly price), with the fitting one on `primaryContainer` and "Fits your group" below its name. Step 2 has the mark, Monthly/Yearly segments, the price as a headline, "2 months free", and "Continue to payment" over the fine print.

FORM: The Upgrade Sheet, a Material bottom-sheet checkout with one question per step. Ranked 6 of 7 on my list and dealt lead (THE ROLL); seed key 4e0aad13; code-led. Signature interaction: when a plan switches on after checkout, the new mark scales in (ease-out-back) and the new empty spots pop in one after another (staggered ease-out, about 700ms in all), then "Welcome to Club!" settles under the mark. Under Reduce Motion the final state appears at once. Motion grammar: everything else is stock Material (sheet slide, ripples). The sheet's step change is a 200ms fade and resize, instant under Reduce Motion.

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance

## Unresolved

- Stripe product names are renamed to Crew, Club and Crowd in the dashboard by a person.
- The billing doc's section 8.5 quotes the old copy; its as-built section records the change.
