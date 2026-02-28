# claude-workflow-skills

Reusable [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skills and agents for iterative software development.

## What's included

### Skills (slash commands)

| Command | Purpose |
|---------|---------|
| `/plan-review [file]` | Iteratively review and improve a markdown plan |
| `/fresh-eyes [path]` | Review recent code changes for bugs with fresh eyes |
| `/beads-create [file]` | Create epics/tasks/subtasks with dependencies from a plan |
| `/beads-review` | Optimize existing beads for correctness and structure |
| `/test-coverage [dir]` | Find test gaps and create beads for missing tests |
| `/ux-polish [path]` | Deep UI/UX scrutiny targeting Stripe-level quality |
| `/land [hint]` | Quality gates + logical commits + push |

### Agents (autonomous subagents)

| Agent | Purpose |
|-------|---------|
| `bug-hunter` | Randomly explore code, trace execution flows, find and fix bugs |
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
/plan-review PLAN.md          # One round of plan improvement
/plan-review PLAN.md          # Another round (repeat until steady state)
/fresh-eyes                   # Review recent changes for bugs
/beads-create PLAN.md         # Turn plan into trackable beads
/beads-review                 # Optimize bead structure
/test-coverage backend/       # Find test gaps
/ux-polish                    # Full UX audit
/land "feat: add dashboard"   # Quality gates + commit + push
```

Agents are invoked automatically by Claude Code when it recognizes a matching task, or you can reference them directly.

## Workflow

A typical development cycle:

1. **Plan** — Write `PLAN.md`, then `/plan-review PLAN.md` × 4-5 rounds
2. **Decompose** — `/beads-create PLAN.md`, then `/beads-review`
3. **Implement** — Work through beads
4. **Test** — `/test-coverage`
5. **Polish** — `/ux-polish`
6. **Verify** — `/fresh-eyes`
7. **Ship** — `/land`

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- [beads](https://github.com/steveyegge/beads) (`bd` CLI) for task tracking skills
- `git` for `/land` and `/fresh-eyes`

## License

MIT
