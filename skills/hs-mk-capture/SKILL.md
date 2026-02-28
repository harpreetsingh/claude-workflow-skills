---
name: hs-mk-capture
description: Quickly capture an interesting insight, pattern, or discovery from the current session for future blog posts or content
argument-hint: [short-description]
---

# /capture — Capture Content In-Flow

You've hit something interesting mid-session. Capture it NOW before moving on.
This must be fast — you're in the middle of coding.

**What the user flagged:** $ARGUMENTS

## Process

1. **Write a capture file** to `~/content/captures/YYYY-MM-DD-<slug>.md` where
   the slug is derived from the description (lowercase, hyphens, 3-5 words).

2. **Frontmatter** — auto-fill as much as possible from context:
   ```yaml
   ---
   date: YYYY-MM-DD
   project: <detected from current git repo name>
   tags: [<2-4 topic tags from: architecture, workflow, devtools, debugging,
          product, infrastructure, ai-development>]
   type: <insight | spine | discovery | pattern | war-story>
   status: raw
   source_session: <working directory path>
   ---
   ```

3. **Body** — Write a detailed capture. This is NOT a polished draft. Include:
   - **What happened** — the context that made this interesting
   - **The insight** — the actual nugget, stated clearly
   - **Supporting detail** — code snippets, file paths, command outputs,
     architecture decisions, anything that would be lost without this file
   - **Why it matters** — who would care about this and why
   - **Potential angle** — if this became a blog post, what's the hook?

4. **Confirm** — tell the user the file path and a one-line summary.

## Rules

- Speed over polish. This is a capture, not a draft.
- Include MORE context than you think is needed. Your future self drafting the
  blog won't have the conversation history.
- Don't ask what tags to use — infer them from context. The user is busy.
- Don't disrupt the current workflow. Capture and move on.
