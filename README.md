# claude-workflow-skills

Reusable [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skills and agents for iterative software development.

## What's included

### Templates

| File | Purpose |
|------|---------|
| `templates/PLAN-TEMPLATE.md` | Canonical plan structure — scales from feature to architecture |
| `templates/AGENTS-TEMPLATE.md` | Universal AGENTS.md — git safety, beads workflow, quality gates, code discipline |

### Playbooks

| File | Purpose |
|------|---------|
| `playbooks/iterative-development.md` | Full workflow from decision docs → shipped code |

### Skills (slash commands)

| Command | Purpose |
|---------|---------|
| `/project-init [name]` | Bootstrap a new project with AGENTS.md, beads, quality gates, docs structure |
| `/plan-draft [source-dir]` | Synthesize decision docs into a structured PLAN v1 |
| `/plan-review [file]` | Iteratively review and improve a markdown plan |
| `/fresh-eyes [path]` | Review recent code changes for bugs with fresh eyes |
| `/beads-create [file]` | Create epics/tasks/subtasks with dependencies from a plan |
| `/beads-review` | Optimize existing beads for correctness and structure |
| `/test-coverage [dir]` | Find test gaps and create beads for missing tests |
| `/ux-polish [path]` | Deep UI/UX scrutiny targeting Stripe-level quality |
| `/stash [focus]` | Save session context before compaction or ending a session |
| `/hydrate` | Restore session context from the most recent stash |
| `/land [hint]` | Quality gates + logical commits + push |

### Agents (autonomous subagents)

| Agent | Purpose |
|-------|---------|
| `bug-hunter` | Strategically explore code from entry points, trace execution flows, find and fix bugs |
| `peer-reviewer` | Review code from fellow agents/humans across recent commits |

## Install

```bash
git clone https://github.com/hsingh/claude-workflow-skills.git
cd claude-workflow-skills
chmod +x install.sh uninstall.sh
./install.sh
```

This creates symlinks from `~/.claude/skills/` and `~/.claude/agents/` into the repo. Updates are just `git pull`.

## Update

```bash
cd claude-workflow-skills
git pull
# Symlinks already point here — changes take effect immediately
```

## Uninstall

```bash
cd claude-workflow-skills
./uninstall.sh
```

## Usage

In any Claude Code session:

```
/plan-draft docs/decisions/    # Synthesize docs into PLAN v1
/plan-review PLAN.md          # One round of plan improvement
/plan-review PLAN.md          # Another round (repeat until steady state)
/fresh-eyes                   # Review recent changes for bugs
/beads-create PLAN.md         # Turn plan into trackable beads
/beads-review                 # Optimize bead structure
/test-coverage backend/       # Find test gaps
/ux-polish                    # Full UX audit
/land "feat: add dashboard"   # Quality gates + commit + push
/stash "working on auth flow"  # Save context before compaction
/hydrate                       # Restore context in new session
```

Agents are invoked automatically by Claude Code when it recognizes a matching task, or you can reference them directly.

## Workflow

A typical development cycle:

1. **Draft** — `/plan-draft docs/decisions/` or write `PLAN.md` from `templates/PLAN-TEMPLATE.md`
2. **Refine** — `/plan-review PLAN.md` × 4-5 rounds until convergence
3. **Decompose** — `/beads-create PLAN.md`, then `/beads-review`
4. **Implement** — Work through beads
5. **Test** — `/test-coverage`
6. **Polish** — `/ux-polish`
7. **Verify** — `/fresh-eyes`
8. **Ship** — `/land`
9. **Pause** — `/stash` (before compaction or ending session)
10. **Resume** — `/hydrate` (in new session)

See `playbooks/iterative-development.md` for the full workflow guide.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- [beads](https://github.com/steveyegge/beads) (`bd` CLI) for task tracking skills
- `git` for `/land` and `/fresh-eyes`

## License

MIT
