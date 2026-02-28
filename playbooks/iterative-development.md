# Iterative Development Playbook

A structured workflow for taking a feature, release, or architecture from idea to
shipped code using Claude Code skills and agents.

## Overview

```
Decision Docs ──→ PLAN v1 ──→ PLAN vN ──→ Beads ──→ Code ──→ Ship ──→ Docs
   /hs-sw-plan-draft  /hs-sw-plan-review  /hs-sw-beads-create  implement  /hs-sw-land-the-plane  /hs-sw-release-docs
                       /hs-sw-fresh-eyes   /hs-sw-beads-review  /hs-sw-fresh-eyes                  /hs-sw-docs-harvest
                                                                 /hs-mk-capture (anytime)
```

---

## Phase 1: Plan Conception

**Input:** Decision docs, PRDs, notes, brainstorm artifacts
**Output:** A PLAN.md v1 following the canonical template

### Steps

1. Gather your source docs into a directory (e.g., `docs/prds/versions/v0.XX/decisions/`)
2. Run `/hs-sw-plan-draft <source-dir>` to synthesize them into a structured PLAN
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

1. `/hs-sw-plan-review PLAN.md` — one round of deep review
2. Review the suggestions. Accept, reject, or discuss.
3. Repeat until suggestions become incremental (Claude will signal convergence)
4. `/hs-sw-fresh-eyes PLAN.md` — final scan for errors, contradictions, confusion

### Convergence signals

- Suggestions shift from "restructure this section" to "tweak this wording"
- No new architectural suggestions in the last round
- The plan feels boring to review because it's solid

---

## Phase 3: Beads Creation

**Input:** PLAN.md at steady state
**Output:** A full bead hierarchy with dependencies

### Steps

1. `/hs-sw-beads-create PLAN.md` — decompose plan into epics/tasks/subtasks
2. `/hs-sw-beads-review` — optimize structure, check acceptance criteria
3. Repeat `/hs-sw-beads-review` once more (diminishing returns after 2 rounds)
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
4. `/hs-sw-fresh-eyes` — check your own work
5. `bd close <id>` — mark done
6. Repeat

### Quality checks during implementation

- `/hs-sw-test-coverage` — run after each major feature to identify test gaps early
- `/hs-sw-ux-polish` — run after UI work, before it accumulates
- Use the `hs-sw-bug-hunter` agent periodically for a deep sweep
- Use the `hs-sw-peer-reviewer` agent to review work from other agents/sessions

---

## Phase 5: Ship

**Input:** All beads closed, code working
**Output:** Code pushed and deployed

### Steps

1. `/hs-sw-land-the-plane` — run quality gates, commit in logical groups, push
2. Verify CI passes
3. Verify deployment succeeds

---

## Phase 6: Content Capture (Continuous)

**Input:** Interesting discoveries during any phase
**Output:** Captured insights in `~/content/captures/`

### In-flow capture

- `/hs-mk-capture "workflow skills are just markdown files"` — captures the insight
  with full context from the current conversation. Takes seconds, doesn't
  interrupt your work.

### Drafting a blog

- `/hs-mk-blog-draft ~/content/captures/2026-02-28-workflow-skills.md` — draft from
  specific captures
- `/hs-mk-blog-draft devtools` — draft from all captures tagged "devtools"
- Source captures move to `captures/done/` after drafting

### Maintenance

- `/hs-mk-content-index` — rebuild `~/content/index.md` grouped by project and topic

---

## Phase 7: Release Documentation

**Input:** All artifacts from the release (PLANs, PRDs, decisions, closed tickets)
**Output:** Clean internal and external documentation

### Internal engineering docs

- `/hs-sw-release-docs v0.17b` — synthesizes everything into:
  - `architecture.md` — how it works, key decisions with rationale
  - `api.md` — endpoints, schemas, auth
  - `data-model.md` — tables, migrations, relationships
  - `what-shipped.md` — planned vs actual, known limitations
  - `lessons.md` — what worked, what didn't

### External user docs

- `/hs-sw-docs-harvest docs/prds/versions/v0.17/` — extracts user-facing content into
  `docs/site/` (concepts, guides, architecture, reference)

---

## Phase 8: Session Management

### Pausing work

- `/hs-cc-stash "context about what matters"` — before compaction or ending session
- This captures: where you are, key decisions, open threads, next step

### Resuming work

- `/hs-cc-hydrate` — at the start of a new session
- This restores context and shows git state since you left

---

## When to use which skill

| Situation | Skill |
|-----------|-------|
| New project, need standard setup | `/hs-sw-project-init` |
| Have decision docs, need a plan | `/hs-sw-plan-draft` |
| Have a plan, need to improve it | `/hs-sw-plan-review` |
| Just wrote code, need to check it | `/hs-sw-fresh-eyes` |
| Plan is ready, need to break it into work items | `/hs-sw-beads-create` |
| Beads exist, need to optimize them | `/hs-sw-beads-review` |
| Need to find untested code | `/hs-sw-test-coverage` |
| UI feels rough | `/hs-sw-ux-polish` |
| Want a deep bug sweep | `hs-sw-bug-hunter` agent |
| Want to review other agents' work | `hs-sw-peer-reviewer` agent |
| Ready to commit and push | `/hs-sw-land-the-plane` |
| Found something interesting mid-session | `/hs-mk-capture` |
| Ready to draft a blog from captures | `/hs-mk-blog-draft` |
| Need to browse captured content | `/hs-mk-content-index` |
| Release done, need internal eng docs | `/hs-sw-release-docs` |
| Release done, need external user docs | `/hs-sw-docs-harvest` |
| Ending a session | `/hs-cc-stash` |
| Starting a session | `/hs-cc-hydrate` |
