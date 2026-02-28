# Iterative Development Playbook

A structured workflow for taking a feature, release, or architecture from idea to
shipped code using Claude Code skills and agents.

## Overview

```
Decision Docs ──→ PLAN v1 ──→ PLAN vN ──→ Beads ──→ Code ──→ Ship
   /plan-draft    /plan-review ×4-5   /beads-create   implement   /land-the-plane
                  /fresh-eyes         /beads-review    /fresh-eyes
```

---

## Phase 1: Plan Conception

**Input:** Decision docs, PRDs, notes, brainstorm artifacts
**Output:** A PLAN.md v1 following the canonical template

### Steps

1. Gather your source docs into a directory (e.g., `docs/prds/versions/v0.XX/decisions/`)
2. Run `/plan-draft <source-dir>` to synthesize them into a structured PLAN
3. Review the gap report — fill in anything obvious, defer the rest to Open Questions

### Tips

- The more decisions you've made upfront, the better the v1 will be
- It's OK to have Open Questions — that's what plan-review is for
- If you don't have decision docs yet, write the PLAN manually using the template
  at `templates/PLAN-TEMPLATE.md`

---

## Phase 2: Plan Improvement

**Input:** PLAN.md v1
**Output:** PLAN.md at steady state (vN, typically N=4-5)

### Steps

1. `/plan-review PLAN.md` — one round of deep review
2. Review the suggestions. Accept, reject, or discuss.
3. Repeat until suggestions become incremental (Claude will signal convergence)
4. `/fresh-eyes PLAN.md` — final scan for errors, contradictions, confusion

### Convergence signals

- Suggestions shift from "restructure this section" to "tweak this wording"
- No new architectural suggestions in the last round
- The plan feels boring to review because it's solid

---

## Phase 3: Beads Creation

**Input:** PLAN.md at steady state
**Output:** A full bead hierarchy with dependencies

### Steps

1. `/beads-create PLAN.md` — decompose plan into epics/tasks/subtasks
2. `/beads-review` — optimize structure, check acceptance criteria
3. Repeat `/beads-review` once more (diminishing returns after 2 rounds)
4. `bd ready` — verify which beads are immediately actionable

### Tips

- This is the cheapest place to find structural problems — much cheaper than
  during implementation
- Every bead should be self-contained: an agent should be able to pick it up
  and execute without reading other beads

---

## Phase 4: Implementation

**Input:** Beads ready to work
**Output:** Working code

### Steps

1. `bd ready` — find the next unblocked bead
2. `bd update <id> --status in_progress` — claim it
3. Implement
4. `/fresh-eyes` — check your own work
5. `bd close <id>` — mark done
6. Repeat

### Quality checks during implementation

- `/test-coverage` — run after each major feature to identify test gaps early
- `/ux-polish` — run after UI work, before it accumulates
- Use the `bug-hunter` agent periodically for a deep sweep
- Use the `peer-reviewer` agent to review work from other agents/sessions

---

## Phase 5: Ship

**Input:** All beads closed, code working
**Output:** Code pushed and deployed

### Steps

1. `/land-the-plane` — run quality gates, commit in logical groups, push
2. Verify CI passes
3. Verify deployment succeeds

---

## Phase 6: Session Management

### Pausing work

- `/stash "context about what matters"` — before compaction or ending session
- This captures: where you are, key decisions, open threads, next step

### Resuming work

- `/hydrate` — at the start of a new session
- This restores context and shows git state since you left

---

## When to use which skill

| Situation | Skill |
|-----------|-------|
| Have decision docs, need a plan | `/plan-draft` |
| Have a plan, need to improve it | `/plan-review` |
| Just wrote code, need to check it | `/fresh-eyes` |
| Plan is ready, need to break it into work items | `/beads-create` |
| Beads exist, need to optimize them | `/beads-review` |
| Need to find untested code | `/test-coverage` |
| UI feels rough | `/ux-polish` |
| Want a deep bug sweep | `bug-hunter` agent |
| Want to review other agents' work | `peer-reviewer` agent |
| Ready to commit and push | `/land-the-plane` |
| Ending a session | `/stash` |
| Starting a session | `/hydrate` |
