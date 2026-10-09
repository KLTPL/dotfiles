#!/bin/bash
set -euo pipefail

echo "Starting Claude skills install..."

# Third-party skills installed globally with the skills CLI (https://github.com/vercel-labs/skills)
# Format: "<github repo> <skill name>"
SKILLS=(
  "emilkowalski/skills apple-design"
  "vercel-labs/agent-skills web-design-guidelines"
)

for entry in "${SKILLS[@]}"; do
  read -r repo skill <<< "$entry"
  echo "⬇️ Installing skill: $skill..."
  npx -y skills@latest add "$repo" --skill "$skill" -g -a claude-code -y
done

echo "🎉 Done!"
