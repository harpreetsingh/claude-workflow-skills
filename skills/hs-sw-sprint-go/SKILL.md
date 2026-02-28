---
name: hs-sw-sprint-go
description: Launch multi-agent sprint from execution plan — spawn director + workers
---

# /sprint-go — Launch Sprint

Reads the persisted sprint plan from `/hs-sw-sprint-exec-plan` and launches
a multi-agent sprint. This is the walk-away moment.

## Process

### Step 1 — Read Sprint Plan

- Read `tmp/sprint-exec-plan.md`
- If missing: tell user to run `/hs-sw-sprint-exec-plan` first and stop
- Present quick summary: "About to launch N workers across K waves. Confirm?"

### Step 2 — Approval Gate

- Show: ticket count, agent count, estimated cost tier distribution
- **Wait for explicit "go" from user**
- Options: go / cancel

### Step 3 — Create Team

- `TeamCreate("sprint-<date>-<project>")`

### Step 4 — Mirror Beads into Tasks

- `TaskCreate()` for each ticket (include `bd` ticket ID in description)
- `TaskUpdate(addBlockedBy=[...])` mirroring beads dependency graph

### Step 5 — Spawn Director

- `Task(subagent_type="hs-sw-sprint-director", name="director", team_name=...)`
- Send sprint brief via `SendMessage`

### Step 6 — Spawn Workers

- `Task(subagent_type="general-purpose", name="worker-N", team_name=...)` for each worker in topology
- Cap at 5 concurrent workers

### Step 7 — Report

- Team name, agent count, assignment summary
- "You can walk away. Director manages from here. Return to check verification entry points."

## Rules

- Never proceed without explicit user approval
- Cap at 5 concurrent workers
- Director gets the full sprint brief via message
- Workers are general-purpose (full tool access)
- Requires Claude Code team features
