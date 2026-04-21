---
name: hs-sw-ux-polish
description: Deep UI/UX scrutiny targeting Stripe-level quality for both desktop and mobile
argument-hint: [component-or-directory]
---

# /ux-polish — World-Class UX Review

```
┌─ THE FLYWHEEL ──────────────────────────────────────────────────────────┐
│ SHAPE → PLAN → REVIEW×N → DECOMPOSE → SPRINT PLAN → EXECUTE → CLOSE   │
│ ★ YOU ARE HERE: Wave gate (UX lens) or standalone review.               │
│ See FLYWHEEL.md for the full development lifecycle.                     │
└─────────────────────────────────────────────────────────────────────────┘
```

Scrutinize every aspect of the application workflow and look for things that
are sub-optimal, unintuitive, or unpolished. Target: Stripe-level apps.

## Scope

- If `$ARGUMENTS` provided, focus on those components
- Otherwise, review the full application workflow

## Evaluation Axes

1. **Usability** — Is every interaction intuitive? Can users accomplish goals
   without thinking? Are there unnecessary steps?
2. **Consistency** — Same patterns throughout? Mixed patterns (different button
   styles, inconsistent spacing, varying empty states) are jarring.
3. **Visual hierarchy** — Is the most important content prominent? Does
   spacing, typography, and color guide the eye correctly?
4. **Polish** — Loading states (skeleton screens, not spinners), empty states
   (helpful, not blank), error states (actionable, not cryptic), transitions
   (subtle, not distracting)
5. **Performance UX** — Optimistic updates, lazy loading, progressive
   disclosure, perceived speed over raw speed
6. **Desktop UX** — Keyboard shortcuts, hover states, information density,
   multi-panel layouts, drag-and-drop where natural
7. **Mobile UX** — Touch targets (min 44px), swipe gestures, thumb zones,
   progressive disclosure, responsive breakpoints, no hover-dependent features
8. **Accessibility** — Contrast ratios (WCAG AA minimum), focus indicators,
   screen reader labels, reduced-motion support
9. **CLI UX** — CLI is a first-class interface, not an afterthought:
   - Does every feature accessible via UI/API also have CLI commands?
   - Do all commands support `--json` for agent/machine consumption?
   - Is human-friendly output the default? (rich formatting, colors, tables)
   - Are error messages actionable ("missing --workspace flag") not cryptic?
   - Is help text (`--help`) complete and useful?
   - Are command names intuitive and consistent? (e.g., all CRUD follows
     `<noun> list|show|create|update|delete` pattern)
   - Is output scannable? (headers, whitespace, alignment for human mode;
     parseable structure for `--json` mode)

## Process

1. Trace the component hierarchy: pages → layouts → components → primitives.
   Since you can't see the running app, reconstruct the visual structure from code.
2. Walk through actual user workflows (onboarding, core loop, edge cases)
3. Evaluate each axis above for desktop AND mobile as separate passes
4. Propose specific, actionable improvements with rationale
5. Implement changes directly OR create beads if the scope is large

## Rules

- Desktop and mobile are different modalities — optimize each separately.
- Be specific. Not "improve spacing" but "increase card padding from 12px to 16px
  for better visual breathing room."
- When referencing best practices, explain the principle — don't just name-drop.
- Use extended thinking for deep UX analysis.
