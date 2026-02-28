---
name: hs-mk-blog-draft
description: Draft a v1 blog post from specific captured content, then move sources to done
argument-hint: [capture-files-or-topic]
---

# /blog-draft — Draft a Blog from Captures

Pick up stashed captures and synthesize them into a v1 blog post.

## Process

1. **Identify source captures.** Based on `$ARGUMENTS`:
   - If specific file paths given: read those captures
   - If a topic/keyword given: search `~/content/captures/` for matching files
     by tags, title, or content (skip files in `captures/done/`)
   - If no arguments: list all available captures with their one-line summaries
     and ask the user to pick

2. **Read all source captures thoroughly.** Understand:
   - What the insights are
   - How they connect to each other
   - What the narrative arc could be
   - Who the audience is

3. **Write a blog draft** to `~/content/drafts/<slug>.md` with frontmatter:
   ```yaml
   ---
   title: "<title>"
   date: YYYY-MM-DD
   status: draft
   source_captures:
     - <path to capture 1>
     - <path to capture 2>
   tags: [<merged from source captures>]
   ---
   ```

4. **Structure the draft.** Include:
   - A hook that makes someone want to keep reading
   - Section-by-section content with the actual substance (not placeholders)
   - Code examples where relevant (real, not pseudo)
   - A tone section at the bottom (notes for the human editor on voice, audience,
     what to emphasize)
   - A sources section referencing the original captures

5. **Move source captures** from `~/content/captures/` to `~/content/captures/done/`.
   This keeps the active captures directory clean.

6. **Report** — show the draft path, word count, and the sections written.

## Rules

- Write a REAL first draft, not an outline. The user should be able to edit this
  into a publishable post, not write it from scratch.
- Practitioner voice. Show real commands and code. Developers trust concrete over
  abstract.
- Don't oversell. "This saved me 20 minutes per session" beats "this 10x'd
  my productivity."
- The draft should stand alone — a reader shouldn't need to know about the
  captures to understand the blog.
- Use extended thinking for narrative synthesis.
