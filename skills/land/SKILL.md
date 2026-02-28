---
name: land
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

2. **Artifact check** — Reject if any of these appear in staged files:
   `*.tsbuildinfo`, `.beads/.local_version`, `.beads/daemon-error`, `*.log`,
   `.next/`, `node_modules/`, `__pycache__/`, `.env*` (except `.env.example`),
   `.DS_Store`
   If found: add to `.gitignore`, unstage, and warn.

3. **Quality gates** (only for changed directories):
   - Backend (`backend/`): `uv run ruff check .` → `uv run ruff format --check .` → `uv run pytest -v`
   - Frontend (`frontend/`): `npm run lint` → `npx tsc --noEmit` → `npm run build`

4. **Beads sync**
   ```
   bd sync --flush-only
   ```

5. **Commit** — Group changes into logical commits with detailed messages.
   If `$ARGUMENTS` provided, use it as the commit message hint.
   Don't edit any code at this stage. Don't commit ephemeral files.

6. **Push**
   ```
   git pull --rebase
   git push
   git status  # must show "up to date with origin"
   ```

## Rules

- If quality gates fail, STOP. Report the failures. Do not push broken code.
- If push fails, resolve and retry until it succeeds.
- Don't skip checks. Don't guess. Always verify.
- Every push costs real money (CI, deployments). Treat it accordingly.
