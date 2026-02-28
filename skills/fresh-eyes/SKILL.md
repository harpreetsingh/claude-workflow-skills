---
name: fresh-eyes
description: Review recently written or modified code with fresh eyes for bugs, errors, and problems
argument-hint: [file-or-directory]
---

# /fresh-eyes — Fresh Eyes Review

Carefully read over all recently written or modified code looking for bugs,
errors, problems, and confusion. Fix anything you uncover.

## Scope

- If `$ARGUMENTS` is provided, review those specific files/directories
- Otherwise, detect what changed in this work session:
  1. Try `git diff --name-only $(git merge-base HEAD main)..HEAD` (all changes since branching)
  2. Fallback to `git diff --name-only HEAD~5` if on main
  3. Exclude test files from the initial pass (review them separately after)

## Process

1. Identify files to review (from args or git diff)
2. Read each file completely — no skimming
3. For each file:
   - Understand its purpose in the larger codebase
   - Trace execution flows through imports and callers
   - Check for:
     - Logic errors, off-by-one, wrong comparison operators
     - Null/undefined handling, missing return statements
     - Type mismatches, incorrect async/await, unhandled promise rejections
     - Race conditions, missing error handling at system boundaries
     - Typos in strings/keys/URLs, wrong variable names
     - Copy-paste artifacts, stale references after a refactor
     - API contract violations (caller doesn't match callee signature)
4. Classify each finding: **Bug** (breaks behavior) / **Defect** (will bite later) / **Nit** (minor)
5. Fix bugs and defects directly. Report nits but don't change them.
6. Summarize what was found and fixed

## Rules

- Approach the code as if you've never seen it before — that's the whole point.
- Don't rationalize away suspicious code. If it looks wrong, investigate.
- Comply with all rules in CLAUDE.md and AGENTS.md.
- Use extended thinking for complex logic analysis.
