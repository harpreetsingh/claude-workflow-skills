# claude-workflow-skills

Reusable [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skills and agents for iterative software development.

## Naming Convention

All skills use the `hs-` namespace with a category prefix for discoverability:

| Prefix | Category | Description |
|--------|----------|-------------|
| `hs-sw-` | Software | SDLC skills — planning, quality, shipping, docs |
| `hs-mk-` | Marketing | Content capture, blog drafting, indexing |
| `hs-cc-` | Claude Code | Session management — stash and hydrate |

Type `/hs-` to see all skills. Type `/hs-sw-` to narrow to software. Type `/hs-mk-` for marketing.

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

#### Software (`hs-sw-`)

| Command | Purpose |
|---------|---------|
| `/hs-sw-project-init [name]` | Bootstrap a new project with AGENTS.md, beads, quality gates, docs structure |
| `/hs-sw-plan-draft [source-dir]` | Synthesize decision docs into a structured PLAN v1 |
| `/hs-sw-plan-review [file]` | Iteratively review and improve a markdown plan |
| `/hs-sw-beads-create [file]` | Create epics/tasks/subtasks with dependencies from a plan |
| `/hs-sw-beads-review` | Optimize existing beads for correctness and structure |
| `/hs-sw-fresh-eyes [path]` | Review recent code changes for bugs with fresh eyes |
| `/hs-sw-test-coverage [dir]` | Find test gaps and create beads for missing tests |
| `/hs-sw-ux-polish [path]` | Deep UI/UX scrutiny targeting Stripe-level quality |
| `/hs-sw-land-the-plane [hint]` | Quality gates + logical commits + push |
| `/hs-sw-release-docs [version]` | Synthesize internal engineering docs for a release from all artifacts |
| `/hs-sw-docs-harvest [source-dir]` | Extract external-facing docs from decision docs and PRDs |

#### Marketing (`hs-mk-`)

| Command | Purpose |
|---------|---------|
| `/hs-mk-capture [description]` | Quickly capture an interesting insight mid-session for future content |
| `/hs-mk-blog-draft [files-or-topic]` | Draft a v1 blog post from captured content, move sources to done |
| `/hs-mk-content-index` | Rebuild the content index grouped by project and topic |

#### Claude Code (`hs-cc-`)

| Command | Purpose |
|---------|---------|
| `/hs-cc-stash [focus]` | Save session context before compaction or ending a session |
| `/hs-cc-hydrate` | Restore session context from the most recent stash |

### Agents (autonomous subagents)

| Agent | Purpose |
|-------|---------|
| `hs-sw-bug-hunter` | Strategically explore code from entry points, trace execution flows, find and fix bugs |
| `hs-sw-peer-reviewer` | Review code from fellow agents/humans across recent commits |

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
/hs-sw-plan-draft docs/decisions/    # Synthesize docs into PLAN v1
/hs-sw-plan-review PLAN.md           # One round of plan improvement (repeat ×4-5)
/hs-sw-fresh-eyes                    # Review recent changes for bugs
/hs-sw-beads-create PLAN.md          # Turn plan into trackable beads
/hs-sw-beads-review                  # Optimize bead structure
/hs-sw-test-coverage backend/        # Find test gaps
/hs-sw-ux-polish                     # Full UX audit
/hs-sw-land-the-plane "feat: add X"  # Quality gates + commit + push
/hs-mk-capture "interesting insight" # Capture content mid-session
/hs-mk-blog-draft captures/file.md  # Draft a blog from captures
/hs-cc-stash "working on auth flow"  # Save context before compaction
/hs-cc-hydrate                       # Restore context in new session
```

Agents are invoked automatically by Claude Code when it recognizes a matching task, or you can reference them directly.

## Workflow

A typical development cycle:

1. **Bootstrap** — `/hs-sw-project-init my-app`
2. **Draft** — `/hs-sw-plan-draft docs/decisions/` or write `PLAN.md` from `templates/PLAN-TEMPLATE.md`
3. **Refine** — `/hs-sw-plan-review PLAN.md` × 4-5 rounds until convergence
4. **Decompose** — `/hs-sw-beads-create PLAN.md`, then `/hs-sw-beads-review`
5. **Implement** — Work through beads
6. **Test** — `/hs-sw-test-coverage`
7. **Polish** — `/hs-sw-ux-polish`
8. **Verify** — `/hs-sw-fresh-eyes`
9. **Ship** — `/hs-sw-land-the-plane`
10. **Pause** — `/hs-cc-stash` (before compaction or ending session)
11. **Resume** — `/hs-cc-hydrate` (in new session)
12. **Capture** — `/hs-mk-capture "interesting insight"` (mid-session, anytime)
13. **Blog** — `/hs-mk-blog-draft captures/file.md` (when ready to write)
14. **Release docs** — `/hs-sw-release-docs v0.17b` (at release close)
15. **External docs** — `/hs-sw-docs-harvest docs/prds/versions/v0.17/` (at release close)

See `playbooks/iterative-development.md` for the full workflow guide.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- [beads](https://github.com/steveyegge/beads) (`bd` CLI) for task tracking skills
- `git` for `/hs-sw-land-the-plane` and `/hs-sw-fresh-eyes`

## License

MIT
