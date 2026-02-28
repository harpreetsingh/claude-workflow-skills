---
name: plan-review
description: Deeply review a markdown plan and propose concrete improvements with rationale and diffs
argument-hint: [plan-file-path]
---

# /plan-review — Iterative Plan Improvement

Read the plan file at `$ARGUMENTS` (default: `PLAN.md`) and perform one round of
deep review.

## What to do

1. Read the entire plan file carefully
2. Evaluate it for:
   - Architecture quality and robustness
   - Missing or weak features
   - Features that should be changed or removed
   - Performance and reliability gaps
   - How compelling/useful it is for end users
3. For EACH proposed change, provide:
   - **Analysis**: What's wrong or suboptimal
   - **Rationale**: Why the change makes it better
   - **Diff**: git-diff style change relative to the current plan
4. Apply all approved changes to the plan file in-place

## Convergence

Each invocation is one round. After 4-5 rounds the suggestions become very
incremental — that's the signal you've reached steady state and the plan is
ready for implementation.

## Rules

- Be bold. Propose real architectural changes, not cosmetic tweaks.
- Every suggestion must have a concrete rationale — no "consider doing X" without why.
- Preserve the plan's voice and structure while improving substance.
- Use extended thinking for deep analysis.
