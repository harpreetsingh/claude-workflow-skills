#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_TARGET="$HOME/.claude/skills"
AGENTS_TARGET="$HOME/.claude/agents"

echo "Installing claude-workflow-skills from $REPO_DIR"

# Ensure target directories exist
mkdir -p "$SKILLS_TARGET" "$AGENTS_TARGET"

# Symlink skills
for skill_dir in "$REPO_DIR"/skills/*/; do
  skill_name="$(basename "$skill_dir")"
  target="$SKILLS_TARGET/$skill_name"

  if [ -L "$target" ]; then
    echo "  ↻ $skill_name (updating symlink)"
    rm "$target"
  elif [ -d "$target" ]; then
    echo "  ⚠ $skill_name already exists as a directory — skipping (remove manually to install)"
    continue
  else
    echo "  + $skill_name"
  fi

  ln -s "$skill_dir" "$target"
done

# Symlink agents
for agent_file in "$REPO_DIR"/agents/*.md; do
  [ -f "$agent_file" ] || continue
  agent_name="$(basename "$agent_file")"
  target="$AGENTS_TARGET/$agent_name"

  if [ -L "$target" ]; then
    echo "  ↻ ${agent_name%.md} (updating symlink)"
    rm "$target"
  elif [ -f "$target" ]; then
    echo "  ⚠ ${agent_name%.md} already exists — skipping (remove manually to install)"
    continue
  else
    echo "  + ${agent_name%.md}"
  fi

  ln -s "$agent_file" "$target"
done

echo ""
echo "Done. Skills and agents are now available in Claude Code."
echo "To update: git pull (symlinks point to this repo)"
echo "To remove: ./uninstall.sh"
