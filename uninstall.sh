#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_TARGET="$HOME/.claude/skills"
AGENTS_TARGET="$HOME/.claude/agents"

echo "Uninstalling claude-workflow-skills"

# Remove skill symlinks that point back to this repo
for skill_dir in "$REPO_DIR"/skills/*/; do
  skill_name="$(basename "$skill_dir")"
  target="$SKILLS_TARGET/$skill_name"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$skill_dir" ]; then
    echo "  - $skill_name"
    rm "$target"
  fi
done

# Remove agent symlinks that point back to this repo
for agent_file in "$REPO_DIR"/agents/*.md; do
  [ -f "$agent_file" ] || continue
  agent_name="$(basename "$agent_file")"
  target="$AGENTS_TARGET/$agent_name"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$agent_file" ]; then
    echo "  - ${agent_name%.md}"
    rm "$target"
  fi
done

echo ""
echo "Done. All symlinks removed."
