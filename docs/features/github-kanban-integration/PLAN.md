# Feature: GitHub Kanban Integration

**Date:** 2026-03-18
**Status:** Spec complete, ready for implementation
**Scope:** Feature — cross-repo skill infrastructure + per-repo configuration

---

## The One-Line Version

Skills already define the development lifecycle stages. Wire them to GitHub Projects V2 so the kanban board auto-updates as skills run, giving a strategic view of feature progress without manual status tracking.

---

## Problem

Beads is excellent for execution (granular tasks, dependencies, agent-driven work) but provides no strategic "what are we building this quarter" view. GitHub Projects V2 provides that view — a kanban board showing features moving through stages — but today it requires manual status updates. Meanwhile, the Claude Code skills (`/hs-sw-plan-draft`, `/hs-sw-beads-create`, `/hs-sw-fresh-eyes`, etc.) already represent the lifecycle stages. They just don't report their progress anywhere.

---

## Design

### Core Insight: Skills = State Machine Transitions

The existing skills map directly to kanban columns:

```
Backlog → Planning → Ready → Implementing → Review → Done
             ↑          ↑         ↑             ↑
         /plan-draft  /beads-   /sprint-go   /fresh-eyes
         /plan-review  create                /test-coverage
                      /beads-                /ux-polish
                       review
```

| Kanban Column | Entering Skills | Meaning |
|---------------|----------------|---------|
| **Backlog** | (manual) | Idea captured, not yet planned |
| **Planning** | `/hs-sw-plan-draft`, `/hs-sw-plan-review` | PRD/PLAN being written and refined |
| **Ready** | `/hs-sw-beads-create`, `/hs-sw-beads-review` | Plan decomposed into tickets, ready for implementation |
| **Implementing** | `/hs-sw-sprint-go`, `/hs-sw-sprint-exec-plan` | Active development underway |
| **Review** | `/hs-sw-fresh-eyes`, `/hs-sw-test-coverage`, `/hs-sw-ux-polish` | Code written, quality checks in progress |
| **Done** | `/hs-sw-land-the-plane` | Shipped |

5 active columns + Backlog. Clean, not overwhelming.

### How It Works

```
Developer runs: /hs-sw-beads-create docs/features/dynamic-proxy/PLAN.md

Skill does its normal work (creates beads from plan)
  ↓
At the end, skill reads AGENTS.md for GitHub Project config
  ↓
Skill calls: gh project item-edit --owner "joystream-ai" \
             --project "JoyStream" --id <item-id> \
             --field-id Status --value "Ready"
  ↓
GitHub kanban board shows "Dynamic Proxy" card move to "Ready" column
```

### Per-Repo Configuration

Skills are global (`~/.claude/skills/`) but GitHub Projects are per-repo. Each repo declares its project in `AGENTS.md`:

```markdown
## GitHub Project

| Field | Value |
|-------|-------|
| Org | joystream-ai |
| Project | JoyStream |
```

The skill reads this from the repo it's running in. Different repo → different AGENTS.md → different GitHub Project. No global config needed.

### GitHub ↔ Beads Linking

Each GitHub Project card (epic/story) has a `beads: joystream-xxxx` reference in its description. This is the only link — no sync, no webhooks, one-directional.

```
GitHub Projects (strategic kanban)        Beads (execution engine)
──────────────────────────────           ─────────────────────────
Feature card: "Dynamic Proxy"
  description: "beads: joystream-psyb"
  status: Implementing                   joystream-psyb (epic)
                                           ├── joystream-a1b2 (task) ✓ closed
                                           ├── joystream-c3d4 (task) → in_progress
                                           └── joystream-e5f6 (task) → open
```

Granular task progress lives in beads. The GitHub card shows the big picture.

---

## Implementation Plan

### Part 1: GitHub Project Setup (Manual, One-Time)

1. Create GitHub Projects V2 board for the org
2. Add custom single-select "Status" field with values:
   - `Backlog`, `Planning`, `Ready`, `Implementing`, `Review`, `Done`
3. Create board view with these columns
4. Add `## GitHub Project` section to AGENTS.md in each repo

### Part 2: Helper Function for Skills (New File)

Create a shared helper that any skill can call to update GitHub status.

**File:** `templates/github-kanban-helper.sh`

```bash
#!/bin/bash
# github-kanban-helper.sh — Update GitHub Projects V2 card status
#
# Usage (from within a skill):
#   source <skills-repo>/templates/github-kanban-helper.sh
#   gh_kanban_update "Ready"
#
# Reads GitHub Project config from AGENTS.md in the current repo.
# No-ops gracefully if config is missing or gh CLI not available.

gh_kanban_update() {
    local target_status="$1"
    local feature_name="$2"  # Optional: feature name to find/create card

    # 1. Check prerequisites
    if ! command -v gh &>/dev/null; then
        echo "[gh-kanban] gh CLI not found, skipping status update"
        return 0
    fi

    # 2. Read config from AGENTS.md
    local agents_file
    agents_file=$(git rev-parse --show-toplevel 2>/dev/null)/AGENTS.md
    if [[ ! -f "$agents_file" ]]; then
        echo "[gh-kanban] No AGENTS.md found, skipping status update"
        return 0
    fi

    local org project
    org=$(grep -A5 "## GitHub Project" "$agents_file" | grep "Org" | awk -F'|' '{print $3}' | xargs)
    project=$(grep -A5 "## GitHub Project" "$agents_file" | grep "Project" | awk -F'|' '{print $3}' | xargs)

    if [[ -z "$org" || -z "$project" ]]; then
        echo "[gh-kanban] GitHub Project not configured in AGENTS.md, skipping"
        return 0
    fi

    # 3. Find the project and item
    # (Implementation: use gh project item-list + jq to find by title)
    # (If feature_name provided, find card matching that name)
    # (If not found, no-op — don't create cards automatically)

    echo "[gh-kanban] Updated '$feature_name' → $target_status in $org/$project"
}
```

### Part 3: Skill Modifications

Add a GitHub status update call to the **end** of each relevant skill. This is 3-5 lines appended to each `SKILL.md`'s process section.

#### Skills to Modify

| Skill | Status to Set | When |
|-------|--------------|------|
| `hs-sw-plan-draft` | `Planning` | After PLAN.md is written |
| `hs-sw-plan-review` | `Planning` | (no change — already in Planning) |
| `hs-sw-beads-create` | `Ready` | After beads are created from plan |
| `hs-sw-beads-review` | `Ready` | (no change — already in Ready) |
| `hs-sw-sprint-exec-plan` | `Implementing` | After sprint plan is generated |
| `hs-sw-sprint-go` | `Implementing` | After sprint is launched |
| `hs-sw-fresh-eyes` | `Review` | After code review completes |
| `hs-sw-test-coverage` | `Review` | After test gap analysis completes |
| `hs-sw-ux-polish` | `Review` | After UX review completes |
| `hs-sw-land-the-plane` | `Done` | After successful push |

#### Example Modification (hs-sw-beads-create/SKILL.md)

Add to the end of the Process section:

```markdown
## GitHub Status Update

After creating beads, update the GitHub Project kanban:

1. Read `## GitHub Project` section from AGENTS.md in the repo root
2. If configured, run:
   ```bash
   gh project item-edit --owner "<org>" --project "<project>" \
     --id <item-id> --field-id Status --value "Ready"
   ```
3. If `gh` CLI is not available or AGENTS.md has no GitHub Project section, skip silently
4. Log: "[gh-kanban] Updated '<feature>' → Ready"
```

### Part 4: New Skill — `/hs-sw-gh-sync` (Optional)

A manual sync skill for catchup — when you've been working without the hooks, or need to bulk-update.

**File:** `skills/hs-sw-gh-sync/SKILL.md`

```markdown
---
name: hs-sw-gh-sync
description: Sync current feature status to GitHub Projects kanban board
argument-hint: [feature-name]
---

# /gh-sync — Sync Feature Status to GitHub Kanban

Read the current state of beads and code, infer what lifecycle stage
the feature is in, and update the GitHub Projects V2 card.

## Process

1. Read `## GitHub Project` from AGENTS.md — get org and project name
2. If `$ARGUMENTS` provided, use as feature name. Otherwise, infer from
   branch name (`feature/<name>` → `<name>`) or ask.
3. Determine current stage by checking:
   - Does `docs/features/<name>/PLAN.md` exist? → at least Planning
   - Does `bd list` show beads for this feature? → at least Ready
   - Are any beads `in_progress`? → Implementing
   - Are all beads `closed`? → Review or Done
   - Has code been pushed to main? → Done
4. Update the GitHub Project card:
   ```bash
   gh project item-edit --owner "<org>" --project "<project>" \
     --id <item-id> --field-id Status --value "<inferred-status>"
   ```
5. Report what was updated and why

## Rules

- Never create GitHub cards automatically — only update existing ones
- If the card doesn't exist, tell the user to create it manually
- Gracefully no-op if gh CLI or GitHub Project config is missing
```

### Part 5: New Skill — `/hs-sw-gh-feature` (Optional)

Create a GitHub issue + Project card for a new feature, linking it to the docs/features/ planning directory.

**File:** `skills/hs-sw-gh-feature/SKILL.md`

```markdown
---
name: hs-sw-gh-feature
description: Create a GitHub issue and Project card for a new feature, scaffold docs/features/ directory
argument-hint: <feature-name> [description]
---

# /gh-feature — Start a New Feature

Create the GitHub issue, Project card, and local planning directory
for a new feature.

## Process

1. Parse `$ARGUMENTS` for feature name and optional description
2. Read `## GitHub Project` from AGENTS.md — get org and project name
3. Create GitHub issue:
   ```bash
   gh issue create --title "<feature-name>" \
     --body "## Feature: <name>\n\n<description>\n\n---\nPlanning: docs/features/<name>/PLAN.md\nBeads: (not yet created)" \
     --label "feature"
   ```
4. Add issue to GitHub Project board in "Backlog" column
5. Create local planning directory:
   ```
   docs/features/<feature-name>/
   └── PLAN.md  (from templates/PLAN-TEMPLATE.md, pre-filled with feature name)
   ```
6. Report: issue URL, project card created, local directory ready
7. Suggest next step: `/hs-sw-plan-draft docs/features/<feature-name>/`

## Rules

- Feature name must be kebab-case (e.g., `dynamic-proxy`, not `DynamicProxy`)
- Always use the PLAN template from this skills repo
- Do not create beads yet — that's /hs-sw-beads-create's job
```

---

## Changes to Existing Files

### `AGENTS-TEMPLATE.md` (templates/)

Add a `## GitHub Project` section to the template so new projects get it automatically:

```markdown
## GitHub Project

| Field | Value |
|-------|-------|
| Org | <your-github-org> |
| Project | <your-project-name> |
```

### `playbooks/iterative-development.md`

Update the workflow to include the GitHub kanban touchpoints:

```
Phase 0: /hs-sw-gh-feature <name>        → GitHub card created in Backlog
Phase 1: /hs-sw-plan-draft               → Card moves to Planning
Phase 2: /hs-sw-plan-review × N          → (stays in Planning)
Phase 3: /hs-sw-beads-create + review    → Card moves to Ready
Phase 3.5: /hs-sw-sprint-exec-plan + go  → Card moves to Implementing
Phase 4: Implementation                   → (stays in Implementing)
Phase 5: /hs-sw-fresh-eyes + test + ux   → Card moves to Review
Phase 6: /hs-sw-land-the-plane           → Card moves to Done
```

### `README.md`

Add to the skills table:

```markdown
| `/hs-sw-gh-feature [name]` | Create GitHub issue + Project card + scaffold docs/features/ directory |
| `/hs-sw-gh-sync [feature]` | Sync current feature status to GitHub Projects kanban board |
```

Add `gh` CLI to Requirements section.

---

## AGENTS.md Configuration Reference

Every repo that wants GitHub kanban integration adds this section to its `AGENTS.md`:

```markdown
## GitHub Project

| Field | Value |
|-------|-------|
| Org | joystream-ai |
| Project | JoyStream |
```

**Why AGENTS.md and not a config file?**
- Skills already read AGENTS.md as their first action
- It's checked into the repo (team-visible, version-controlled)
- Different repo → different AGENTS.md → different project
- No new config file format to maintain
- `.beads/config.yaml` belongs to the beads project — not ours to extend

---

## GitHub Projects V2 Setup Guide

### Create the Project

```bash
# Create project (V2)
gh project create --owner "joystream-ai" --title "JoyStream"

# Add custom Status field with the 5+1 values
# (Must be done via GitHub web UI — gh CLI doesn't support custom field creation yet)
# Go to: github.com/orgs/joystream-ai/projects/<N>/settings
# Add field: "Status" (single select)
# Values: Backlog, Planning, Ready, Implementing, Review, Done
```

### Add Existing Features

```bash
# Create issue for an existing feature
gh issue create --repo joystream-ai/joystream \
  --title "Dynamic Proxy with Sonnet" \
  --body "## Feature\n\nReplace static fixtures with contextual Sonnet mocks at runtime.\n\n---\nPlanning: docs/prds/versions/v0.17b/PLAN.md (D2)\nBeads: joystream-psyb" \
  --label "feature"

# Add to project
gh project item-add <project-number> --owner "joystream-ai" --url <issue-url>
```

### Column Automation (Optional, GitHub Web UI)

GitHub Projects V2 supports automation rules:
- When issue is closed → move to Done
- When PR is merged → move to Done
- When label "in-progress" is added → move to Implementing

These are supplementary — the skills handle the primary transitions.

---

## What This Does NOT Do

- **No bidirectional sync.** GitHub → Beads is manual (`/hs-sw-beads-create`). Beads → GitHub is skill-driven.
- **No webhooks.** No server infrastructure. Skills push status via `gh` CLI.
- **No automatic card creation.** `/hs-sw-gh-feature` creates cards. Other skills only update existing cards.
- **No granular task sync.** GitHub shows features (epics). Beads tracks tasks. The link is a `beads: joystream-xxxx` reference in the issue body.

---

## Acceptance Criteria

- [ ] GitHub Projects V2 board exists with 6 columns (Backlog, Planning, Ready, Implementing, Review, Done)
- [ ] AGENTS.md in JoyStream repo has `## GitHub Project` section
- [ ] `AGENTS-TEMPLATE.md` includes `## GitHub Project` section
- [ ] `/hs-sw-gh-feature` skill creates issue + project card + scaffolds `docs/features/`
- [ ] `/hs-sw-gh-sync` skill infers stage from beads/code state and updates card
- [ ] Each lifecycle skill (`plan-draft`, `beads-create`, `fresh-eyes`, `land-the-plane`, etc.) updates GitHub card status at completion
- [ ] Skills gracefully no-op when GitHub Project is not configured
- [ ] `playbooks/iterative-development.md` updated with kanban touchpoints
- [ ] `README.md` updated with new skills and `gh` requirement

---

## Implementation Order

1. **GitHub Project board** — create manually, configure columns (30 min)
2. **AGENTS.md config** — add `## GitHub Project` section to JoyStream + template (5 min)
3. **`/hs-sw-gh-feature`** — new skill, scaffolds everything (1 hour)
4. **`/hs-sw-gh-sync`** — new skill, manual catchup (1 hour)
5. **Skill modifications** — add status update to each existing skill (2 hours)
6. **Playbook + README** — update docs (30 min)
7. **Test** — run through full lifecycle on a real feature (1 hour)
