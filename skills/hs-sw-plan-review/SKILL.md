---
name: hs-sw-plan-review
description: Deeply review a markdown plan and propose concrete improvements with rationale and diffs
argument-hint: [plan-file-path]
---

# /plan-review — Iterative Plan Improvement

Read the plan file at `$ARGUMENTS` (default: `PLAN.md`) and perform one round of
deep review.

## What to do

1. Read the entire plan file carefully
2. Evaluate it holistically for:
   - Architecture quality, robustness, and simplicity
   - Missing, weak, or unnecessary features
   - Performance, reliability, and security gaps
   - How compelling and useful it is for end users
   - Feasibility and implementation cost of each section
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
