---
name: hs-sw-gh-issue
description: File a GitHub issue with title, body, labels, and native type (Feature|Bug|Task) via GraphQL
argument-hint: [repo]
---

# /gh-issue — File a GitHub Issue

Create a GitHub issue with the correct native type set (Feature, Bug, or Task).
`gh issue create` does not support `--type` — this skill uses the GraphQL API to set it.

## When to Use

- Filing a new GitHub issue from a description, ticket, or conversation
- Any time a `type:` is specified (Feature, Bug, Task) — `gh issue create` silently ignores it

## Arguments

`$ARGUMENTS` — optional repo override in `owner/repo` format. If omitted, uses current repo via `gh repo view`.

## Process

1. **Gather required fields** from context or ask the user:
   - `title` — required
   - `body` — required (write in GitHub-flavored markdown; use `## Description`, `## Why It Matters`, `## Proposed Change` sections as appropriate)
   - `type` — one of `Feature`, `Bug`, `Task` (required; default `Task` if unclear)
   - `labels` — optional, comma-separated
   - `repo` — from `$ARGUMENTS` or `gh repo view --json nameWithOwner --jq '.nameWithOwner'`

2. **Write body to a temp file** to avoid shell quoting issues:
   ```bash
   cat > /tmp/gh-issue-body.md << 'ENDBODY'
   <body content>
   ENDBODY
   ```

3. **Create the issue** (without type — `gh issue create` doesn't support it):
   ```bash
   gh issue create \
     --title "<title>" \
     --body-file /tmp/gh-issue-body.md \
     --label "<labels>" \
     --repo <owner/repo>
   ```
   Capture the returned issue URL and extract the issue number.

4. **Look up the issue type ID** for the target repo:
   ```bash
   gh api graphql -f query='
   query {
     repository(owner: "<owner>", name: "<repo>") {
       issueTypes(first: 10) {
         nodes { id name }
       }
     }
   }'
   ```
   Match the desired type name (case-insensitive) to get its `id`.

5. **Get the issue node ID:**
   ```bash
   gh api graphql -f query='
   query {
     repository(owner: "<owner>", name: "<repo>") {
       issue(number: <number>) { id }
     }
   }' --jq '.data.repository.issue.id'
   ```

6. **Set the issue type:**
   ```bash
   gh api graphql -f query='
   mutation {
     updateIssue(input: {
       id: "<issue-node-id>",
       issueTypeId: "<type-node-id>"
     }) {
       issue { number title issueType { name } }
     }
   }'
   ```

7. **Report:**
   ```
   ✓ Filed: <owner/repo>#<number> — <title>
     Type:   <type>
     Labels: <labels>
     URL:    <url>
   ```

## Rules

- **Always use `--body-file`** — never inline the body in the shell command. Backticks and special chars in issue bodies break heredoc quoting.
- **Always set the type** — if the user didn't specify, infer from context (bug report → Bug, new capability → Feature, chore/refactor → Task). Confirm if unsure.
- **If `issueTypes` query returns empty**, the repo may not have types enabled. Warn and skip step 6 — do not abort.
- **Clean up** `/tmp/gh-issue-body.md` after the issue is filed.
