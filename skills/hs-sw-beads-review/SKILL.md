---
name: hs-sw-beads-review
description: Review and optimize existing beads for correctness, completeness, and structure
---

# /beads-review — Beads Optimization

```
┌─ THE FLYWHEEL ──────────────────────────────────────────────────────────┐
│ SHAPE → PLAN → REVIEW×N → ★DECOMPOSE → SPRINT PLAN → EXECUTE → CLOSE  │
│ ★ YOU ARE HERE: QA the beads before sprint. Fix structure, not code.    │
│ See FLYWHEEL.md for the full development lifecycle.                     │
└─────────────────────────────────────────────────────────────────────────┘
```

Check over each bead super carefully — are they correct? Optimal? Could anything
be changed to make the system work better for users?

## Process

1. **Structural review first** (cheap, catches big issues):
   - `bd list --status=open` to see all open beads
   - `bd graph --all` to see dependency structure
   - Look for: orphaned beads (no deps, not a root epic), circular dependencies,
     overly long dependency chains, beads with no dependents that aren't leaf tasks
2. **TDD compliance check**:
   - For each impl bead with testable acceptance criteria: does a companion test
     bead exist?
   - Does the test bead BLOCK the impl bead? (`bd show <id>` — check dependencies)
   - Does the test bead's acceptance criteria require tests to FAIL (red phase)?
   - If missing: create the test bead and wire the dependency
   - Flag any impl bead that has no test coverage rationale
3. **Domain balance check**:
   - Count beads by domain (backend, frontend, infra, tests)
   - Flag if any domain has impl beads but zero test beads
   - Flag if frontend and backend both exist but only one has test coverage
   - Flag if >30% of beads are in one domain with no dedicated worker planned
4. **CLI coverage check**:
   - For each impl bead that delivers an API endpoint or UI feature: does it
     also specify CLI commands?
   - Do the CLI commands include `--json` flag for agent/machine consumption?
   - If missing: add CLI requirements to the bead's acceptance criteria
   - Flag any bead that delivers an API/UI without CLI as incomplete
5. **Deep review** (for each bead, `bd show <id>`):
   - Does this bead make sense? Is it necessary?
   - Is the scope right? Too big = hard to execute. Too granular = overhead.
     A good task is 1-4 hours of focused agent work.
   - Does it have **mechanically verifiable** acceptance criteria? Each
     criterion must be checkable by grep, curl, test output, or file read.
     If a criterion says "it works" or "handles errors" — rewrite it with
     the specific observable (endpoint returns X, component renders Y,
     command outputs Z). Vague criteria are the root cause of stubs passing QA.
   - Are dependencies correct and complete?
   - Is the description self-contained enough for an agent with no prior context?
   - Could beads be merged (overlapping scope), split (too large), reordered
     (wrong priority), or removed (unnecessary)?
5. **Apply revisions** using `bd update` and `bd dep add`
7. **Summarize** all changes made and why — organized by:
   - TDD gaps found and fixed
   - Domain balance issues
   - CLI coverage gaps found and fixed
   - Structural changes (merges, splits, reorders)

## Rules

- It's cheaper to fix things in plan space than during implementation.
- Be opinionated — propose real structural changes, not just wordsmithing.
- Every bead must have acceptance criteria. If one is missing them, add them.
- Every impl bead with testable criteria must have a companion test bead that
  blocks it. No exceptions — if tests can be written, they must be planned.
- Use extended thinking for structural analysis.
