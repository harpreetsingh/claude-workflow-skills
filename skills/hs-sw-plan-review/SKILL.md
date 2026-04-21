---
name: hs-sw-plan-review
description: Deeply review a markdown plan and propose concrete improvements with rationale and diffs
argument-hint: [plan-file-path]
---

# /plan-review — Iterative Plan Improvement

```
┌─ THE FLYWHEEL ──────────────────────────────────────────────────────────┐
│ SHAPE → PLAN → ★REVIEW×N → DECOMPOSE → SPRINT PLAN → EXECUTE → CLOSE  │
│ ★ YOU ARE HERE: Iterative refinement. 4-5 rounds until convergence.     │
│ See FLYWHEEL.md for the full development lifecycle.                     │
└─────────────────────────────────────────────────────────────────────────┘
```

Read the plan file at `$ARGUMENTS` (default: `PLAN.md`) and perform one round of
deep review.

## What to do

1. Read the entire plan file carefully. Also check for a `planning-context/`
   directory alongside the plan — if it exists, read the evidence (research,
   competitor analysis, PRDs, reference material). This grounds your review
   in the same inputs that informed the plan.
2. Evaluate it holistically for:
   - Architecture quality, robustness, and simplicity
   - Missing, weak, or unnecessary features
   - Performance, reliability, and security gaps
   - How compelling and useful it is for end users
   - Feasibility and implementation cost of each section
   - **CLI completeness** — does every feature with an API or UI also specify
     CLI commands? Are `--json` flags included? Is the CLI a first-class
     interface or an afterthought? Flag any feature missing CLI commands as
     a High-severity gap.
3. For EACH proposed change, provide:
   - **Severity**: High (architectural) / Medium (feature-level) / Low (polish)
   - **Analysis**: What's wrong or suboptimal
   - **Rationale**: Why the change makes it better — with specifics, not hand-waving
   - **Diff**: git-diff style change relative to the current plan
4. Present ALL proposals and WAIT for the user to approve before editing the file.
   The user may accept all, accept some, or ask for another round.

## Convergence

Each invocation is one round. After 4-5 rounds the suggestions become very
incremental. When that happens, explicitly tell the user: "This plan has likely
converged — the remaining suggestions are incremental. Ready for /beads-create."

## Rules

- Be bold. Propose real architectural changes, not cosmetic tweaks.
- Every suggestion must have a concrete rationale — no "consider doing X" without why.
- Preserve the plan's voice and structure while improving substance.
- Do NOT apply changes automatically. Present them for approval.
- Use extended thinking for deep analysis.
