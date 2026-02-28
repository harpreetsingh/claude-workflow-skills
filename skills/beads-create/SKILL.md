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
2. Decompose into epics → tasks → subtasks
3. For each bead, create with `bd create`:
   - Clear imperative title
   - Detailed description including:
     - Background and reasoning/justification
     - Acceptance criteria
     - Relevant considerations
     - How it serves the overarching project goals
   - Appropriate type (epic/feature/task/bug) and priority (0-4)
4. Overlay dependency structure with `bd dep add`
5. Run `bd list` and `bd graph --all` to verify the structure looks right

## Rules

- Every bead must be totally self-contained and self-documenting — a future
  agent picking up any bead should have full context without reading anything else.
- Include the WHY, not just the WHAT.
- Dependencies must be correct — nothing should be unblocked that has real prereqs.
- Use parallel `bd create` commands where possible for efficiency.
- Use extended thinking for decomposition.
