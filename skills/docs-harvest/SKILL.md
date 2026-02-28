---
name: docs-harvest
description: Extract external-facing documentation from decision docs, PRDs, and implementation into docs/site/
argument-hint: [source-dir]
---

# /docs-harvest — Harvest External Documentation

At epic or release close, extract the external-facing content from your internal
artifacts (decision docs, PRDs, plans, implementation) and write clean user
documentation.

**Source directory:** `$ARGUMENTS` (e.g., `docs/prds/versions/v0.17/`)

## Process

1. **Read all source artifacts** in the provided directory:
   - Decision docs → architecture and concepts
   - PLAN.md → feature overview and capabilities
   - PRDs → user-facing feature descriptions
   - Implementation code → API reference, configuration

2. **Identify external-facing content.** For each artifact, extract ONLY what
   an end user or integrator needs to know. Strip:
   - Internal debate and alternatives-considered (keep in release-docs instead)
   - Implementation details that don't affect users
   - Team workflow and process notes
   - Temporary workarounds and tech debt notes

3. **Write docs** to `docs/site/` (create if missing) in a format compatible
   with any static site generator:
   ```
   docs/site/
   ├── concepts/          # Key concepts and mental models
   │   └── <concept>.md
   ├── guides/            # How-to guides for common tasks
   │   └── <guide>.md
   ├── architecture/      # System design (external view)
   │   └── <component>.md
   └── reference/         # API reference, configuration
       └── <endpoint>.md
   ```

4. **Each doc** should have frontmatter:
   ```yaml
   ---
   title: "<title>"
   description: "<one-line description>"
   category: concept | guide | architecture | reference
   version: <release version this was harvested from>
   source_artifacts:
     - <path to source doc>
   ---
   ```

5. **Report** — list docs created, flag gaps (things a user would need to know
   that aren't covered by any source artifact).

## Rules

- Write for the external reader. They don't know your internal terminology
  unless you define it.
- Each doc must stand alone — no "see the PRD for details."
- Don't create empty placeholder docs. Only write docs where source material
  exists.
- If a concept or feature isn't ready for public docs, skip it.
- Use extended thinking for content extraction.
