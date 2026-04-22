---
name: hs-sw-docs-gen-ext
description: Extract external-facing documentation from internal artifacts into docs/areas/site/ — capture now, build site later
argument-hint: [feature-dir-or-name]
---

# /docs-external — Harvest External Documentation

```
┌─ THE FLYWHEEL ──────────────────────────────────────────────────────────┐
│ SHAPE → PLAN → REVIEW×N → DECOMPOSE → SPRINT PLAN → EXECUTE → CLOSE   │
│ ★ YOU ARE HERE: Sprint close — extract user-facing docs to areas/site/. │
│ See FLYWHEEL.md for the full development lifecycle.                     │
└─────────────────────────────────────────────────────────────────────────┘
```

At feature or sprint close, extract the external-facing content from your
internal artifacts and write clean user documentation. The site doesn't need
to exist yet — this captures content into a standard folder structure that
any static site generator can consume later.

**Feature directory:** `$ARGUMENTS` (e.g., `docs/projects/features/org-management/` or
`org-management`). If just a name is given, look in `docs/projects/features/<name>/`.

## Output Location

```
docs/areas/site/
├── features/                  # Feature-specific docs
│   ├── org-management/
│   │   ├── workspaces.md      # Concepts: what workspaces are, hierarchy
│   │   ├── vaults.md          # Concepts: credential storage, resolution
│   │   ├── settings.md        # Concepts: inheritance, LLM profiles
│   │   └── agents.md          # Concepts: visibility, discovery, install
│   └── agent-builder/
│       └── ...
├── guides/                    # How-to guides (cross-feature)
│   └── <task>.md              # e.g., create-workspace.md, manage-credentials.md
├── reference/
│   ├── api/                   # API reference
│   │   └── <resource>.md      # e.g., workspaces.md, vaults.md, agents.md
│   └── cli/                   # CLI reference (first-class interface)
│       └── <command>.md       # One doc per command group, with --json schemas
└── _meta.yaml                 # Site config placeholder (for future site generator)
```

**This is just markdown.** No site generator needed yet. When you eventually
pick one (Nextra, Docusaurus, Mintlify), point it at `docs/areas/site/` and add
config.

## Process

1. **Read all source artifacts** for the feature:
   - `docs/projects/features/<name>/PLAN.md` → feature overview and capabilities
   - `docs/projects/features/<name>/architecture.md` → system design (if exists, from /docs-gen-int)
   - `docs/projects/features/<name>/api.md` → API details (if exists)
   - `docs/projects/features/<name>/cli.md` → CLI details (if exists)
   - Decision docs → concepts and rationale
   - Implementation code → API reference, CLI commands, configuration

2. **Identify external-facing content.** For each artifact, extract ONLY what
   an end user or integrator needs to know. Strip:
   - Internal debate and alternatives-considered (keep in internal docs)
   - Implementation details that don't affect users
   - Team workflow and process notes
   - Temporary workarounds and tech debt notes

3. **Write docs** to the structure above:

   ### Feature docs (`docs/areas/site/features/<name>/`)
   - One file per major concept the feature introduces
   - Written for users: "what is this, why should I care, how does it work"
   - Include examples and diagrams

   ### Guides (`docs/areas/site/guides/`)
   - Task-oriented: "How to create a workspace", "How to manage credentials"
   - Step-by-step with code examples (both UI steps and CLI commands)
   - Cross-feature guides go here (e.g., "Getting started" spans multiple features)

   ### API reference (`docs/areas/site/reference/api/`)
   - One file per resource (workspaces, vaults, agents, etc.)
   - Endpoint, method, request/response schemas, auth, errors
   - Copy from internal api.md but rewrite for external audience

   ### CLI reference (`docs/areas/site/reference/cli/`)
   - One file per command group (workspace, vault, agent, etc.)
   - Command syntax, flags, arguments
   - `--json` output schemas
   - Example usage (both human-friendly and JSON mode)

4. **Each doc** should have frontmatter:
   ```yaml
   ---
   title: "<title>"
   description: "<one-line description>"
   category: feature | guide | api-reference | cli-reference
   feature: <feature-name>
   source_artifacts:
     - <path to source doc>
   ---
   ```

5. **Report** — list docs created, flag gaps (things a user would need to know
   that aren't covered by any source artifact).

## Rules

- **Auto-write everything.** Create all directories (`docs/areas/site/features/<name>/`,
  `docs/areas/site/guides/`, `docs/areas/site/reference/api/`, `docs/areas/site/reference/cli/`)
  if they don't exist, then write all docs directly. Do NOT ask the user for
  confirmation before writing. Do NOT present content and wait for approval.
  Extract and write.
- Write for the external reader. They don't know your internal terminology
  unless you define it.
- Each doc must stand alone — no "see the PRD for details."
- Don't create empty placeholder docs. Only write docs where source material
  exists.
- If a concept or feature isn't ready for public docs, skip it.
- Include CLI examples alongside API examples — CLI is a first-class interface.
- Use extended thinking for content extraction.
