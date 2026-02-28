---
name: hs-sw-sprint-exec-plan
description: Analyze beads into waves, label cost tiers, design team topology, generate ASCII diagram
---

# /sprint-exec-plan — Sprint Execution Plan

Read-only analysis of your beads backlog. Produces a sprint brief with wave plan,
cost tiers, team topology, and ASCII deployment diagram. No team creation — this
is the thinking step before `/hs-sw-sprint-go`.

## Process

### Step 1 — Inventory

- `bd list --status=open` to get all open tickets
- `bd show <id>` for each ticket to get full context
- `bd graph --all` for dependency structure
- Read AGENTS.md for project context, quality gates, verification entry points

### Step 2 — Verification Entry Points

- Check AGENTS.md for a "Verification Entry Points" section
- If configured: create missing verification tickets with `bd create`
- Wire as dependents of implementation tickets they verify
- Place in final wave
- If no section: note and suggest adding one

### Step 3 — Wave Analysis

- Build DAG from beads dependencies
- Group into waves: Wave 1 = no deps, Wave N = deps all in 1..N-1
- Name waves by dominant work type (Foundation / Core / Integration / Polish)
- Flag cycles — must resolve before proceeding

### Step 4 — Model Tier Labeling

Apply tiers via `bd update <id> --labels tier:<tier>`:

- `opus`: architectural decisions, complex multi-file refactors, high fan-out (blocks 3+)
- `sonnet`: standard features, API endpoints, UI components
- `haiku`: config, boilerplate, test stubs, docs, mechanical tasks

Respect existing ticket labels — don't overwrite user-assigned ones.

### Step 5 — Team Topology

- Agent count: total tickets / 4, capped at 5 workers
- Logical groupings: analyze domains (backend/frontend/infra or by label)
- Manager layer: only if 4+ workers; otherwise Director manages directly
- Director: always one, always opus-tier

### Step 6 — Generate Sprint Brief

Two artifacts:

**A. ASCII Deployment Diagram:**
```
Wave 1 (Foundation)     Wave 2 (Core)        Wave 3 (Polish)
┌─────────────────┐    ┌────────────────┐    ┌────────────────┐
│ T-01 schema  ◆  │    │ T-04 API    ●  │    │ T-07 tests  ○  │
│ T-02 models  ◆  │───▶│ T-05 UI     ●  │───▶│ T-08 docs   ○  │
│ T-03 config  ○  │    │ T-06 hooks  ●  │    │ T-09 demo   ○  │
└─────────────────┘    └────────────────┘    └────────────────┘
◆ = opus  ● = sonnet  ○ = haiku

Director (Opus)
├── Backend Manager (Sonnet)
│   ├── Worker-1: T-01, T-02, T-04
│   └── Worker-2: T-03, T-05
└── Frontend Manager (Sonnet)
    └── Worker-3: T-06, T-07, T-08, T-09
```

**B. Director Brief** — self-contained markdown with:
- Project, branch, tech stack, quality gates
- Wave plan with ticket IDs, titles, tiers, dependencies
- Team topology with agent assignments
- Role switching rules (impl → test → docs → marketing → fresh-eyes)
- Autonomy mandate

### Step 7 — Persist + Present

- Write full plan to `tmp/sprint-exec-plan.md`
- Present ASCII diagram + topology + cost summary in conversation
- Tell user: "Review and adjust, or run `/hs-sw-sprint-go` to launch"

## Rules

- Use extended thinking for wave analysis and topology decisions
- All ticket operations use `bd` CLI
- If dependency graph has cycles: report and stop
- Respect existing ticket labels — don't overwrite user-assigned ones
- This is read-only analysis (except verification ticket creation and tier labels)
