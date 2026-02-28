---
name: fresh-eyes
description: Review recently written or modified code with fresh eyes for bugs, errors, and problems
argument-hint: [file-or-directory]
---

# /fresh-eyes — Fresh Eyes Review

Carefully read over all recently written or modified code looking super carefully
for any obvious bugs, errors, problems, issues, confusion, etc. Fix anything
you uncover.

## Scope

- If `$ARGUMENTS` is provided, review those specific files/directories
- Otherwise, run `git diff --name-only HEAD~1` to find recently changed files

## Process

1. Identify files to review (from args or git diff)
2. Read each file completely — no skimming
3. For each file:
   - Understand its purpose in the larger codebase
   - Trace execution flows through imports and callers
   - Check for: logic errors, off-by-one, null/undefined handling, race
     conditions, missing error handling at boundaries, typos in strings/keys,
     wrong variable names, copy-paste artifacts
4. Fix every issue found directly in the code
5. Summarize what was found and fixed

## Rules

- Approach the code as if you've never seen it before — that's the whole point.
- Don't rationalize away suspicious code. If it looks wrong, investigate.
- Comply with all rules in CLAUDE.md and AGENTS.md.
- Use extended thinking for complex logic analysis.
