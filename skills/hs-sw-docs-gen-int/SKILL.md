---
name: hs-sw-docs-gen-int
description: Synthesize PLANs, PRDs, decisions, and closed tickets into comprehensive internal engineering docs for a feature
argument-hint: [feature-dir-or-name]
---

# /docs-internal — Internal Engineering Documentation

```
┌─ THE FLYWHEEL ──────────────────────────────────────────────────────────┐
│ SHAPE → PLAN → REVIEW×N → DECOMPOSE → SPRINT PLAN → EXECUTE → CLOSE   │
│ ★ YOU ARE HERE: Sprint close — write internal docs alongside PLAN.md.   │
│ See FLYWHEEL.md for the full development lifecycle.                     │
└─────────────────────────────────────────────────────────────────────────┘
```

At feature close (or sprint end), synthesize all the scattered artifacts into
clean, comprehensive internal documentation. Someone joining 6 months from now
should read this and understand what was built, why, and how it works.

**Feature directory:** `$ARGUMENTS` (e.g., `docs/projects/features/org-management/` or
`org-management`). If just a name is given, look in `docs/projects/features/<name>/`.

## Output Location

Write docs alongside the feature's existing artifacts:

```
docs/projects/features/<feature-name>/
├── pitch.md                  ← already exists (from /shape)
├── PLAN.md                   ← already exists (from /plan-draft)
├── running-design.md         ← may exist (design notes)
├── architecture.md           ← NEW (from this skill)
├── api.md                    ← NEW
├── cli.md                    ← NEW
├── data-model.md             ← NEW
├── what-shipped.md           ← NEW
└── lessons.md                ← NEW
```

This keeps each feature self-contained — plan, design, and post-mortem all in
one place. When versions are bumped later, release notes can aggregate across
features.

## Process

1. **Gather all artifacts** for this feature:
   - PLAN.md — what was intended
   - Decision docs — key architectural choices and rationale
   - PRDs — requirements and specs
   - Closed and deferred beads — what was delivered and what was deferred
     (`bd list --status=closed,deferred`)
   - Session learnings — surprises, patterns, debugging insights
   - Code changes — `git log` for the feature branch

2. **Synthesize into these documents:**

   ### `architecture.md` — How It Works
   - System architecture with diagrams
   - Component responsibilities and boundaries
   - Data flow end-to-end
   - Key design decisions with rationale (distilled from decision docs)
   - What was considered and rejected, and why

   ### `api.md` — API Reference
   - New or changed endpoints/interfaces
   - Request/response schemas
   - Authentication and authorization
   - Error handling

   ### `cli.md` — CLI Reference
   - New or changed CLI commands
   - Command syntax, flags, and arguments
   - `--json` output schemas for each command
   - Example usage (human-friendly and JSON mode)
   - CLI is a first-class interface — every API endpoint should have a
     corresponding CLI command documented here

   ### `data-model.md` — Data Model
   - New or changed tables/schemas
   - Migrations applied
   - Relationships and constraints
   - Indexing strategy

   ### `what-shipped.md` — Feature Summary
   - What was planned vs what shipped (PLAN → reality)
   - Deliverables completed with brief descriptions
   - Known limitations and tech debt incurred
   - Deferred items and where they went (future tickets/plans)

   ### `lessons.md` — Engineering Learnings
   - Distilled from session learnings and ticket comments
   - What was harder than expected and why
   - Patterns that worked well (reuse for next feature)
   - Patterns that didn't work (avoid next time)

3. **Cross-reference.** Each doc should link to the others where relevant.
   Include source artifact references so readers can drill into the raw
   decision docs if they want more context.

4. **Report** — list docs created, call out any sections that are thin
   (missing source material).

## Rules

- **Auto-write everything.** Create the feature directory if it doesn't exist,
  write all docs directly. Do NOT ask the user for confirmation before writing.
  Do NOT present content and wait for approval. Synthesize and write.
- This is internal engineering documentation — include the WHY and the tradeoffs,
  not just the WHAT.
- Don't sanitize. If a decision was contentious or a feature was descoped, say so.
  Future engineers need to understand the real history.
- Distill, don't copy. Decision docs are 80% deliberation — extract the 20% that
  is the actual decision and its rationale.
- Don't create docs for sections with no substance. Thin is worse than absent.
- Use extended thinking for synthesis across artifacts.
