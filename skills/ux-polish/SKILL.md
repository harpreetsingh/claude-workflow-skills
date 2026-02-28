---
name: ux-polish
description: Deep UI/UX scrutiny targeting Stripe-level quality for both desktop and mobile
argument-hint: [component-or-directory]
---

# /ux-polish — World-Class UX Review

Scrutinize every aspect of the application workflow and look for things that
are sub-optimal, unintuitive, or unpolished. Target: Stripe-level apps.

## Scope

- If `$ARGUMENTS` provided, focus on those components
- Otherwise, review the full application workflow

## Evaluation Axes

1. **Usability** — Is every interaction intuitive? Can users accomplish goals
   without thinking?
2. **Visual appeal** — Does it look premium? Consistent spacing, typography,
   color? Does it make people gasp?
3. **Polish** — Smooth transitions, loading states, empty states, error states?
4. **Desktop UX** — Optimize for keyboard shortcuts, hover states, information
   density, multi-panel layouts
5. **Mobile UX** — Optimize for touch targets, swipe gestures, thumb zones,
   progressive disclosure, responsive breakpoints
6. **Accessibility** — Contrast, focus indicators, screen reader support

## Process

1. Read through components and pages systematically
2. Trace actual user workflows (onboarding, core loop, edge cases)
3. Evaluate each axis above for desktop AND mobile separately
4. Propose specific, actionable improvements with rationale
5. Implement changes directly OR create beads if the scope is large

## Rules

- Desktop and mobile are different modalities — optimize each separately.
- Be specific. Not "improve spacing" but "increase padding from 12px to 16px on
  card components for better visual breathing room."
- Reference best practices from Stripe, Linear, Vercel, Arc for justification.
- Use extended thinking for deep UX analysis.
