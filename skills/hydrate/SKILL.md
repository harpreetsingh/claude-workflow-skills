---
name: hydrate
description: Restore session context from the most recent tmp/session-resume.md stash after compaction or at the start of a new session.
---

# /hydrate — Restore session context

Read `tmp/session-resume.md` (relative to project root) and restore context from the most recent stash.

## Steps

1. Read `tmp/session-resume.md`. If it doesn't exist, tell the user "No session resume found. Use `/stash` to create one before compacting." and stop.

2. Present a brief summary of what was stashed:
   - Where we were
   - What the immediate next step is
   - How many open threads exist

3. Ask: "Ready to pick up from here, or do you want to adjust the plan?"

## Rules

- Do NOT re-read every file listed in the resume upfront. Only read files as needed when you actually start working.
- Do NOT treat the resume as a task list to execute automatically. It's context for the human to direct you.
- The resume was written by a previous Claude instance. Trust it but verify if something seems off.
