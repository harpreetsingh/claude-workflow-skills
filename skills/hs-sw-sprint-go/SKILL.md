---
name: hs-sw-sprint-go
description: Launch multi-agent sprint from execution plan — spawn director who owns the team
---

# /sprint-go — Launch Sprint

Reads the persisted sprint plan from `/hs-sw-sprint-exec-plan` and launches
a multi-agent sprint. This is the walk-away moment.

**Key architecture:** Director creates the team and spawns workers — making Director
the system-level team-lead who receives all worker messages directly. The user's
session exits the loop after spawning Director.

## Process

### Step 1 — Read Sprint Plan

- Read `tmp/sprint-exec-plan.md`
- If missing: tell user to run `/hs-sw-sprint-exec-plan` first and stop
- Present quick summary: "About to launch N workers across K waves. Confirm?"

### Step 2 — Approval Gate

- Show: ticket count, agent count, estimated cost tier distribution
- **Wait for explicit "go" from user**
- Options: go / cancel

### Step 3 — Spawn Director

- `Agent(subagent_type="hs-sw-sprint-director", name="director", run_in_background=true)`
- Pass the FULL sprint brief as the prompt, including:
  - Complete `tmp/sprint-exec-plan.md` content
  - Team topology (worker names, types, model tiers, ticket assignments)
  - Team name to create: `sprint-<date>-<project>`
  - Quality gates and project context from AGENTS.md/CLAUDE.md
- Director will create the team, spawn workers, and manage autonomously

### Step 4 — Exit

- Report to user: "Director launched in background. It will create the team and spawn N workers."
- "You can walk away. Director manages everything. Return to check verification entry points."
- **Do NOT create a team. Do NOT spawn workers. Do NOT stay in the loop.**

## Rules

- Never proceed without explicit user approval
- Director creates the team (NOT the launcher) — this is critical for message routing
- Director gets the full sprint brief + team topology in its spawn prompt
- Cap at 5 concurrent workers (enforced by Director)
- Workers are general-purpose (full tool access)
- Launcher exits immediately after spawning Director
- Requires Claude Code team features
