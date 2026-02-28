---
name: hs-cc-stash
description: Save session context to tmp/session-resume.md before compaction or ending a session. User provides guidance on what matters.
---

# /stash — Save session context before compaction

The user is about to compact or end a session. They have provided guidance on what matters:

**User's focus:** $ARGUMENTS

Your job: write a structured session resume to `tmp/session-resume.md` (relative to the project root). Create the `tmp/` directory if it doesn't exist. The file should be gitignored.

## What to capture

Use the user's guidance above to prioritize what goes into the resume. Not everything matters equally — the user told you what's relevant. Build the file around their focus, then fill in supporting context.

## Required sections

Write the file in this exact structure:

```markdown
**Where we are:**
[1-3 sentences. Current state of the work. What phase, what's done, what's in-flight.]

**Branch & git state:**
[Current branch name, last commit SHA and message, any uncommitted changes]

**Key decisions made this session:**
[Bulleted list. Only decisions that would be lost without this file. Include the WHY, not just the WHAT.]

**Key files touched or referenced:**
[Bulleted list of file paths with 1-line descriptions of why they matter.]

**Bead status:**
[Any beads that are in_progress or were closed this session. Include IDs and titles.]

**Open threads / unresolved:**
[Bulleted list. Things we discussed but didn't finish. Disagreements. Parked ideas.]

**Immediate next step:**
[One concrete action. Not a list of 10 things. THE thing to do when context resumes.]

**After that:**
[2-5 follow-up items in priority order.]
```

## Rules

- Keep the total file under 100 lines. Brevity is the point — this gets injected into a fresh context window.
- Do NOT pad with generic summaries. Every line should carry information that would be lost without it.
- Do NOT include things that are already in committed docs or CLAUDE.md — only session-specific context.
- If the user gave no arguments, review the full conversation and use your judgment on what matters most.
- Overwrite any existing `tmp/session-resume.md` — only the most recent stash matters.
