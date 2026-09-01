#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${CODEX_HOME:-$HOME/.codex}/skills"

python3 "$ROOT/scripts/sync-codex-skills.py"
mkdir -p "$DEST"

for skill_dir in "$ROOT"/codex-skills/*; do
  [ -d "$skill_dir" ] || continue
  name="$(basename "$skill_dir")"
  rm -rf "$DEST/$name"
  cp -R "$skill_dir" "$DEST/$name"
  # The fork stores the generated Codex adapter as SKILL.example.md (single-root
  # SKILL.md package contract); materialize the real SKILL.md Codex expects.
  if [ -f "$DEST/$name/SKILL.example.md" ] && [ ! -f "$DEST/$name/SKILL.md" ]; then
    mv "$DEST/$name/SKILL.example.md" "$DEST/$name/SKILL.md"
  fi
done

chmod +x "$ROOT"/tools/*.py "$ROOT"/tools/*.sh 2>/dev/null || true

echo "Installed Codex skills to $DEST"
echo "Run ./scripts/install-codex-prompts.sh if you want slash-command prompts."
echo "Restart Codex to pick up new skills."
