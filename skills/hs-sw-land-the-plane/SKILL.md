---
name: hs-sw-land-the-plane
description: Run quality gates, commit changes in logical groups, sync beads, and push to remote
argument-hint: [commit-message-hint]
disable-model-invocation: true
---

# /land — Land the Plane

Run the full pre-push checklist, commit, and push. Work is NOT done until
`git push` succeeds.

## Process

1. **Check what changed**
   ```
   git status
   git diff --stat
   ```
   If there are no changes to commit, say so and stop.

2. **Artifact check** — Scan for files that should never be committed:
   `*.tsbuildinfo`, `.beads/.local_version`, `*.log`,
   `.next/`, `node_modules/`, `__pycache__/`, `.env*` (except `.env.example`),
   `.DS_Store`, `*.sqlite3`
   If found: add to `.gitignore`, unstage, and warn.

3. **Quality gates** — Detect the project's stack from the files that changed
   and run the appropriate checks. Defer to CLAUDE.md for project-specific gate
   commands if present. Common patterns:
   - Python: linter (`ruff check`/`flake8`) → formatter check → tests (`pytest`)
   - TypeScript/JS: linter (`eslint`/`biome`) → type check (`tsc --noEmit`) → build
   - Rust: `cargo clippy` → `cargo test`
   - Go: `go vet` → `go test ./...`
   Only run gates for directories with actual changes.

4. **Beads sync** (if `.beads/` directory exists)
   ```
   bd dolt push
   ```

5. **Commit** — Create a series of logically connected commits, NOT one giant
   commit. Analyze all changed files and group them by coherent change:
   - Feature + its tests = one commit
   - Refactor = one commit
   - Config/infra changes = one commit
   - Docs/beads = one commit
   Each commit message should be detailed: subject line (what), body (why and
   what's in this group). If `$ARGUMENTS` provided, use it as the overall theme.
   Do NOT edit any code at this stage. Do NOT commit ephemeral files.

6. **Push**
   ```
   git pull --rebase
   ```
   If rebase conflicts occur, STOP and report them — do not auto-resolve.
   ```
   git push
   git status  # must show "up to date with origin"
   ```

## Rules

- If quality gates fail, STOP. Report the failures. Do not push broken code.
- If push fails, resolve and retry until it succeeds.
- Don't skip checks. Don't guess. Always verify.
- Every push costs real money (CI, deployments). Treat it accordingly.
