---
name: hs-sw-sprint-recover
description: Recover from a failed or incomplete sprint — triage, fix beads state, prepare for re-sprint
argument-hint: [feature-dir-or-triage-doc]
---

# /sprint-recover — Sprint Recovery

```
┌─ THE FLYWHEEL ──────────────────────────────────────────────────────────┐
│ SHAPE → PLAN → REVIEW×N → DECOMPOSE → SPRINT PLAN → EXECUTE → CLOSE   │
│                                                                         │
│  Failed sprint? ──→ ★/sprint-recover ──→ re-enter at SPRINT PLAN       │
│ ★ YOU ARE HERE: Fix beads state after a failed/incomplete sprint.        │
│ See FLYWHEEL.md for the full development lifecycle.                     │
└─────────────────────────────────────────────────────────────────────────┘
```

Re-entry point after a failed or incomplete sprint. Reads the triage analysis,
reconciles bead state with reality, and produces a clean backlog ready for
`/sprint-exec-plan`.

**Usage:**
```
/sprint-recover docs/projects/features/org-management/
/sprint-recover /tmp/org-management-triage-heatmap.md
/sprint-recover   ← prompts for feature dir or triage doc
```

## Process

### Step 1 — Find the inputs

If `$ARGUMENTS` is a feature directory (e.g., `docs/projects/features/org-management/`):
- Read `PLAN.md` for intended scope
- Read `sprint-plan.md` for the previous sprint topology (if exists)
- Read `sprint-state.md` for where the sprint stopped (if exists)
- Check `planning-context/` for triage docs, heatmaps, audit reports
- Look for files matching `*triage*`, `*audit*`, `*heatmap*` in the feature dir and in `/tmp/`

If `$ARGUMENTS` is a specific file: read it as the triage source.

If no arguments: ask "What feature are we recovering? Point me to the feature
directory or a triage document."

### Step 2 — Read the triage

Parse the triage document for:
- **GREEN** tickets — truly done, verified working
- **YELLOW** tickets — partially done, gaps identified
- **RED** tickets — not done, not started, or falsely marked complete
- **Root causes** — what went wrong (skipped frontend? no TDD? self-grading?)

If no triage document exists, perform a live triage:
1. `bd list --status=closed` + `bd list --label qa-passed` — what claims to be done?
2. For each "done" bead, quick-verify: do the files it claims to have changed exist?
   Do tests pass? Does the acceptance criteria evidence hold up?
3. `bd list --status=open` — what was never started?
4. Classify each bead as GREEN / YELLOW / RED
5. Write the triage to `<feature_dir>/planning-context/sprint-recovery-triage.md`

### Step 3 — Beads surgery

For each bead, based on triage classification:

**GREEN (truly done):**
- Leave as-is (`closed` or `in_progress` with `qa-passed` label)
- No action needed

**YELLOW (partially done):**
- If `closed`: `bd reopen <id> --reason="Recovery: <gap description>"`
- If `qa-passed` label: `bd update <id> --remove-label qa-passed`
- Add a note explaining the gap: `bd note <id> "Recovery: <gap description>"`
- Update acceptance criteria if the gap reveals missing criteria
- If the gap is a specific fix: create a new fix bead, wire as dependency

**RED (not done):**
- If falsely `closed`: `bd reopen <id> --reason="Recovery: not implemented in previous sprint"`
- If `qa-passed` label: `bd update <id> --remove-label qa-passed`
- Add note: `bd note <id> "Recovery: not implemented in previous sprint"`
- Review the description — is it self-sufficient for a fresh agent?
- Enrich if needed: `bd update <id> --description="..."`

### Step 4 — TDD gap analysis

For every open impl bead (YELLOW or RED) with testable acceptance criteria:
- Does a companion test bead exist?
- Does the test bead block the impl bead?
- If not: create the test bead with `bd create` and wire dependencies

```bash
bd create --title="Test: <impl bead title>" \
  --description="Write failing tests for <impl bead id>. See acceptance criteria on the impl bead." \
  --type=task --priority=<same as impl>
bd dep add <impl-bead-id> <test-bead-id>
```

Log: `bd comments add <impl-id> "Recovery: created TDD pair <test-id>"`

### Step 5 — Dependency repair

- `bd graph --all` to see the full dependency structure
- Check for:
  - Broken deps (depend on a bead that was deleted or superseded)
  - Missing deps (RED bead depends on another RED bead but no dep wired)
  - Circular deps (must resolve before sprint)
  - Orphaned beads (no deps and not a root — probably lost)
- Fix with `bd dep add` / `bd dep remove`
- Flag any circular deps — report and stop if unresolvable

### Step 6 — Domain balance check

Count open beads by domain:
```
Backend: N impl + N test
Frontend: N impl + N test
Infra: N impl + N test
```

Flag if the previous sprint's failure mode is still present:
- "Previous sprint skipped frontend. There are N frontend beads. Ensure the
  next sprint has frontend workers."
- "Previous sprint had no TDD. N impl beads now have test pairs."

### Step 7 — Structural review

Run the same checks as `/beads-review`:
- Every bead has concrete acceptance criteria
- Every bead has a self-sufficient description
- No orphans, no cycles
- Domain balance is reasonable
- CLI beads exist for API/UI features

Fix issues in-place. Log all changes.

### Step 8 — Recovery summary

Present a clear summary:

```markdown
## Sprint Recovery: <feature-name>

### Previous Sprint
- Total tickets: N
- GREEN (keep): N
- YELLOW (reopened + patched): N
- RED (reopened): N
- Root cause: <what went wrong>

### Beads Surgery
- Reopened: N beads
- Created: N new beads (N test pairs, N fix beads)
- Dependencies fixed: N
- Enriched descriptions: N

### Ready for Sprint
- Open beads: N (N impl + N test)
- Domains: backend (N), frontend (N), infra (N)
- TDD coverage: N/N impl beads have test pairs

### Next Steps
1. Review the recovery — `bd list --status=open` to see all open beads
2. `/sprint-exec-plan` to plan the recovery sprint
3. `/sprint-go --dry-run` to preview
4. `/sprint-go` to launch
```

Save this summary to `<feature_dir>/planning-context/sprint-recovery-summary.md`.

## Rules

- **Do NOT create a new PLAN or pitch.** The plan already exists. You're fixing
  beads, not re-planning the feature.
- **Do NOT close GREEN beads.** Leave them alone. They're done.
- **Be aggressive on reopening.** If there's any doubt about whether a bead is
  truly done, reopen it. It's cheaper to re-verify than to ship a bug.
- **Every reopened bead must have a note** explaining why it was reopened. A fresh
  agent will read this — make it useful.
- **Create TDD pairs for everything.** The previous sprint likely skipped TDD.
  Don't repeat the mistake.
- If no triage doc exists, do the live triage (Step 2 fallback). Don't skip
  triage and go straight to surgery — you need to know what's broken first.
- Use extended thinking for triage analysis and dependency repair.
