---
name: hs-sw-gh-beads-link
description: Bidirectionally link a beads ticket to a GitHub issue — sets external-ref on beads, updates the GitHub project Beads field, and posts a backlink comment
argument-hint: <gh-issue-url-or-number> [beads-id]
---

# /gh-beads-link — Bidirectional GitHub ↔ Beads Link

Connect a GitHub issue and a beads ticket so each references the other.
Run this after creating a beads epic or ticket that tracks work from a GitHub issue.

## When to Use

- You picked up a GitHub issue, drafted a plan, and created a beads ticket to track the work
- You want GitHub collaborators to find the beads ticket (and vice versa)
- The single source of truth for *status* is beads; GitHub is where the *requirement* lives

## Arguments

```
$ARGUMENTS = "<gh-issue-url-or-number> [beads-id]"
```

- `gh-issue-url-or-number` — required. Full URL (`https://github.com/org/repo/issues/42`) or bare number (`42`) if you're already in the right repo.
- `beads-id` — optional. If omitted, use the most recently touched beads issue (last `bd create` or `bd update`).

## Process

1. **Parse arguments.**
   - Extract the GitHub issue number and repo (`owner/repo`) from the URL, or use the current repo from `gh repo view --json nameWithOwner` if only a number was given.
   - Resolve the beads ID: use `$ARGUMENTS` if provided, else run `bd list --status=in_progress --limit=1` and take the first result. Confirm with the user before proceeding if ambiguous.

2. **Fetch GitHub issue details.**
   ```bash
   gh issue view <number> --repo <owner/repo> --json number,title,url,labels,state
   ```
   Display: number, title, state, URL. Confirm this is the right issue before writing anything.

3. **Fetch beads ticket details.**
   ```bash
   bd show <beads-id>
   ```
   Display: ID, title, status. Confirm this is the right ticket before writing anything.

4. **Link beads → GitHub.**
   Set the `external-ref` field on the beads ticket:
   ```bash
   bd update <beads-id> --external-ref "gh-<number>"
   ```
   Also append the full GitHub URL to the beads description notes so it's visible in `bd show`:
   ```bash
   bd update <beads-id> --append-notes "GitHub: https://github.com/<owner/repo>/issues/<number>"
   ```

5. **Set the Beads field on the GitHub Project.**
   Use `gh project item-add --format json` to add the issue to the project (idempotent — safe if already added) AND get its project item ID in one step. Then find the "Beads" field ID and set it.

   > **WHY NOT `gh issue view --json projectItems`:** That API returns `.id = null` for newly created issues even if they were just added to the project. Always use `item-add --format json` instead — it returns the real `PVTI_...` item ID reliably.

   ```bash
   # Step A: Add issue to project (idempotent) and capture item ID
   item_id=$(gh project item-add <project-number> --owner <owner> \
     --url "https://github.com/<owner/repo>/issues/<number>" \
     --format json --jq '.id')
   ```
   Find the "Beads" field ID (do this once per project, cache it):
   ```bash
   gh project field-list <project-number> --owner <owner> --format json \
     --jq '.fields[] | select(.name == "Beads") | {id: .id, type: .type}'
   ```
   Set the value:
   ```bash
   gh project item-edit \
     --id "$item_id" \
     --field-id <beads-field-id> \
     --project-id <project-id> \
     --text "<beads-id>"
   ```
   > **Pagination gotcha:** `gh project item-list` defaults to 30 items. Always pass `--limit 200` when checking if an item exists, otherwise it silently truncates and you miss items.

   If the "Beads" field doesn't exist on the project, warn the user and continue — do not abort.

6. **Link GitHub → beads (comment).**
   Post a comment on the GitHub issue that includes the beads ticket ID and a one-line summary of what's being tracked:
   ```bash
   gh issue comment <number> --repo <owner/repo> --body "$(cat <<'EOF'
   **Tracked in beads:** `<beads-id>` — <beads-title>

   Status updates and sub-tasks will be managed in the beads tracker.
   EOF
   )"
   ```

7. **Confirm and report.**
   Print a summary:
   ```
   ✓ Linked <beads-id> ↔ gh-<number>
     Beads:  <beads-id> — <beads-title>
     GitHub: #<number> — <gh-title>
             <gh-url>
     Project field "Beads": set to <beads-id>   ✓  (or: ⚠ not in a project)
     Backlink comment: posted                    ✓  (or: ⚠ already existed, skipped)
   ```

## Rules

- **Always confirm both sides before writing.** Show the user what you resolved and pause if either side is ambiguous.
- **Never create a new beads ticket here** — this skill links, it doesn't create. Use `bd create` first, then link.
- **Never force-push or close the GitHub issue** — only add a comment.
- **Idempotent:** If `external-ref` is already set to `gh-<number>`, skip step 4 and note it was already linked. If the project "Beads" field already contains `<beads-id>`, skip step 5. Do not duplicate the GitHub comment — check existing comments first with `gh issue view <number> --comments` before posting.
- **Repo inference:** If the beads project is a GitHub repo, always prefer `gh repo view` over hardcoding. Never guess the org/repo slug.
