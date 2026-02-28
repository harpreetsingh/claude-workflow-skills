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
| `/capture [description]` | Quickly capture an interesting insight mid-session for future content |
| `/blog-draft [files-or-topic]` | Draft a v1 blog post from captured content, move sources to done |
| `/content-index` | Rebuild the content index grouped by project and topic |
| `/docs-harvest [source-dir]` | Extract external-facing docs from decision docs and PRDs |
| `/release-docs [version]` | Synthesize internal engineering docs for a release from all artifacts |
| `/stash [focus]` | Save session context before compaction or ending a session |
| `/hydrate` | Restore session context from the most recent stash |
| `/land-the-plane [hint]` | Quality gates + logical commits + push |

### Agents (autonomous subagents)

| Agent | Purpose |
|-------|---------|
| `bug-hunter` | Strategically explore code from entry points, trace execution flows, find and fix bugs |
| `peer-reviewer` | Review code from fellow agents/humans across recent commits |

## Install

```bash
git clone https://github.com/harpreetsingh/claude-workflow-skills.git
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
/land-the-plane "feat: add dashboard"   # Quality gates + commit + push
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
8. **Ship** — `/land-the-plane`
9. **Pause** — `/stash` (before compaction or ending session)
10. **Resume** — `/hydrate` (in new session)

11. **Capture** — `/capture "interesting insight"` (mid-session, anytime)
12. **Blog** — `/blog-draft captures/file.md` (when ready to write)
13. **Release docs** — `/release-docs v0.17b` (at release close)
14. **External docs** — `/docs-harvest docs/prds/versions/v0.17/` (at release close)

See `playbooks/iterative-development.md` for the full workflow guide.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- [beads](https://github.com/steveyegge/beads) (`bd` CLI) for task tracking skills
- `git` for `/land` and `/fresh-eyes`

## License

MIT
