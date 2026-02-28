---
name: plan-draft
description: Synthesize decision docs, PRDs, and notes into a structured PLAN v1 using the canonical template
argument-hint: [source-dir-or-files]
---

# /plan-draft — Generate a PLAN from source docs

Read all documents in `$ARGUMENTS` (a directory or space-separated file paths)
and synthesize them into a single, coherent PLAN following the canonical template.

## Process

1. **Read the template.** Find `templates/PLAN-TEMPLATE.md` in the
   claude-workflow-skills repo (check `~/.claude/skills/plan-draft/` symlink
   to locate the repo root, or search for it). This defines the target structure.

2. **Read all source documents.** Read every file in the provided directory
   (or listed files). These may be:
   - Decision docs (architectural choices with rationale)
   - PRDs (product requirements)
   - Meeting notes or brainstorm docs
   - Existing partial plans
   - README or handoff docs

3. **Synthesize, don't concatenate.** The goal is a single coherent plan, not
   a paste-together of source docs. For each template section:
   - Pull relevant content from across all source docs
   - Resolve contradictions (flag if you can't resolve)
   - Fill gaps with reasonable inferences (flag what you inferred)
   - Maintain traceability: note which source doc informed each section

4. **Write the PLAN.** Output to a file path that makes sense for the project
   (e.g., `docs/prds/versions/v0.XX/PLAN.md` or just `PLAN.md`).
   Ask the user for the output path if unclear.

5. **Flag gaps.** After writing, explicitly list:
   - Template sections you couldn't fill (missing info in source docs)
   - Contradictions between source docs you couldn't resolve
   - Inferences you made that the user should validate
   - Open Questions (move these to the Open Questions section)

## Template Scaling

The template scales by scope. Not every section needs equal depth:

| Scope | Heavy sections | Light sections |
|-------|---------------|----------------|
| **Feature** | Deliverables, Context | Architecture, Deployment |
| **Dot release** | All sections roughly equal | — |
| **Major release** | Architecture, Context, Deliverables | — (all sections full) |
| **Architecture** | Architecture, Key Decisions | Implementation (may be TBD) |

Collapse sections that aren't relevant — don't fill them with filler.

## Rules

- The plan must be self-contained. An agent reading only the plan should be able
  to implement it without reading the source docs.
- Preserve key decisions and their rationale — this is the most valuable content
  in decision docs. Don't summarize away the WHY.
- Write in the same voice as the source docs. Don't sanitize personality.
- Use extended thinking for synthesis.
