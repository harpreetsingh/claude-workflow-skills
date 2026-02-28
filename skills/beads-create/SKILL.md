---
name: beads-create
description: Create comprehensive beads (epics/tasks/subtasks) with dependencies from a plan
argument-hint: [plan-file-path]
---

# /beads-create — Plan to Beads

Read the plan at `$ARGUMENTS` (default: `PLAN.md`) and create a comprehensive,
granular set of beads with full dependency structure.

## Process

1. Read the plan file thoroughly
2. Decompose into epics → tasks → subtasks. Maintain traceability — note which
   plan section each bead maps to in the description.
3. **Phase 1 — Create beads** (can be parallelized):
   For each bead, create with `bd create`:
   - Clear imperative title
   - Detailed description including:
     - Which plan section this implements and why
     - Background and reasoning/justification
     - Acceptance criteria (concrete, verifiable conditions)
     - Relevant considerations and gotchas
     - How it serves the overarching project goals
   - Appropriate type (epic/feature/task/bug) and priority (0-4)
   - Record the returned bead ID for dependency wiring
4. **Phase 2 — Wire dependencies** (must be sequential, after all IDs exist):
   Overlay dependency structure with `bd dep add`
5. **Phase 3 — Verify**:
   - `bd graph --all` to check the structure visually
   - `bd ready` to confirm which beads are immediately actionable
   - Flag anything that looks wrong (orphaned beads, everything blocked, etc.)

## Rules

- Every bead must be totally self-contained and self-documenting — a future
  agent picking up any bead should have full context without reading anything else.
- Include the WHY, not just the WHAT.
- Dependencies must be correct — nothing should be unblocked that has real prereqs,
  and nothing should be blocked unnecessarily.
- Use extended thinking for decomposition.
