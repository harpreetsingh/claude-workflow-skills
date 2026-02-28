---
name: beads-review
description: Review and optimize existing beads for correctness, completeness, and structure
---

# /beads-review — Beads Optimization

Check over each bead super carefully — are they correct? Optimal? Could anything
be changed to make the system work better for users?

## Process

1. Run `bd list --status=open` to see all open beads
2. Run `bd graph --all` to see dependency structure
3. For each bead, `bd show <id>` and evaluate:
   - Does this bead make sense? Is it necessary?
   - Is the scope right? (not too big, not too granular)
   - Are acceptance criteria clear and verifiable?
   - Are dependencies correct and complete?
   - Is the description self-contained enough for an agent to execute?
   - Could anything be merged, split, reordered, or removed?
4. Revise beads using `bd update` and `bd dep add`
5. Summarize all changes made

## Rules

- It's cheaper to fix things in plan space than during implementation.
- Be opinionated — propose real structural changes, not just wordsmithing.
- Check for circular dependencies or missing intermediate steps.
- Use extended thinking for structural analysis.
