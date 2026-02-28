---
name: hs-sw-docs-gen-int
description: Synthesize PLANs, PRDs, decisions, and closed tickets into comprehensive internal engineering docs for a release
argument-hint: [version-or-source-dir]
---

# /release-docs — Internal Engineering Documentation

At release close, synthesize all the scattered artifacts into clean, comprehensive
internal documentation. Someone joining 6 months from now should read this and
understand what was built, why, and how it works.

**Version or source directory:** `$ARGUMENTS` (e.g., `v0.17b` or `docs/prds/versions/v0.17/`)

## Process

1. **Gather all artifacts** for this release:
   - PLAN.md — what was intended
   - Decision docs — key architectural choices and rationale
   - PRDs — requirements and specs
   - Closed beads/tickets — what was actually delivered (`bd list --status=closed`)
   - Session learnings — surprises, patterns, debugging insights
   - Code changes — `git log` for the release branch/period

2. **Synthesize into these documents** (write to `docs/releases/<version>/`):

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

   ### `data-model.md` — Data Model
   - New or changed tables/schemas
   - Migrations applied
   - Relationships and constraints
   - Indexing strategy

   ### `what-shipped.md` — Release Summary
   - What was planned vs what shipped (PLAN → reality)
   - Features delivered with brief descriptions
   - Known limitations and tech debt incurred
   - Deferred items and where they went (future tickets/plans)

   ### `lessons.md` — Engineering Learnings
   - Distilled from session learnings and ticket comments
   - What was harder than expected and why
   - Patterns that worked well (reuse for next release)
   - Patterns that didn't work (avoid next time)

3. **Cross-reference.** Each doc should link to the others where relevant.
   Include source artifact references so readers can drill into the raw
   decision docs if they want more context.

4. **Report** — list docs created, call out any sections that are thin
   (missing source material).

## Rules

- This is internal engineering documentation — include the WHY and the tradeoffs,
  not just the WHAT.
- Don't sanitize. If a decision was contentious or a feature was descoped, say so.
  Future engineers need to understand the real history.
- Distill, don't copy. Decision docs are 80% deliberation — extract the 20% that
  is the actual decision and its rationale.
- Don't create docs for sections with no substance. Thin is worse than absent.
- Use extended thinking for synthesis across artifacts.
