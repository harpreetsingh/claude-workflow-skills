---
name: beads-review
description: Review and optimize existing beads for correctness, completeness, and structure
---

# /beads-review — Beads Optimization

Check over each bead super carefully — are they correct? Optimal? Could anything
be changed to make the system work better for users?

## Process

1. **Structural review first** (cheap, catches big issues):
   - `bd list --status=open` to see all open beads
   - `bd graph --all` to see dependency structure
   - Look for: orphaned beads (no deps, not a root epic), circular dependencies,
     overly long dependency chains, beads with no dependents that aren't leaf tasks
2. **Deep review** (for each bead, `bd show <id>`):
   - Does this bead make sense? Is it necessary?
   - Is the scope right? Too big = hard to execute. Too granular = overhead.
     A good task is 1-4 hours of focused agent work.
   - Does it have concrete, verifiable acceptance criteria?
   - Are dependencies correct and complete?
   - Is the description self-contained enough for an agent with no prior context?
   - Could beads be merged (overlapping scope), split (too large), reordered
     (wrong priority), or removed (unnecessary)?
3. **Apply revisions** using `bd update` and `bd dep add`
4. **Summarize** all changes made and why

## Rules

- It's cheaper to fix things in plan space than during implementation.
- Be opinionated — propose real structural changes, not just wordsmithing.
- Every bead must have acceptance criteria. If one is missing them, add them.
- Use extended thinking for structural analysis.
