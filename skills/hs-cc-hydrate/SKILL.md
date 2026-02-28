---
name: hs-cc-hydrate
description: Restore session context from the most recent tmp/session-resume.md stash after compaction or at the start of a new session.
---

# /hydrate — Restore session context

Read `tmp/session-resume.md` (relative to project root) and restore context from the most recent stash.

## Steps

1. Read `tmp/session-resume.md`. If it doesn't exist, tell the user "No session resume found. Use `/stash` to create one before compacting." and stop.

2. Run `git status` and `git log --oneline -3` to get current branch state, uncommitted changes, and how far ahead/behind remote.

3. Present a brief summary combining both sources:
   - Where we were (from stash)
   - Current git state (branch, any drift since stash)
   - What the immediate next step is
   - How many open threads exist

4. Ask: "Ready to pick up from here, or do you want to adjust the plan?"

## Rules

- Do NOT re-read every file listed in the resume upfront. Only read files as needed when you actually start working.
- Do NOT treat the resume as a task list to execute automatically. It's context for the human to direct you.
- The resume was written by a previous Claude instance. Trust it but verify if something seems off.
- If git state has diverged from what the stash recorded (different branch, new commits from others), flag this explicitly.
