#!/usr/bin/env bash
# Instala claude-delegar: 2 agentes en ~/.claude/agents y la regla en ~/.claude/CLAUDE.md.
set -euo pipefail

RAW="${CLAUDE_DELEGAR_RAW:-https://raw.githubusercontent.com/cuajada69/claude-delegar/main}"
DEST="${CLAUDE_HOME:-$HOME/.claude}"
SRC=""
if [ -f "${BASH_SOURCE[0]:-}" ]; then SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; fi

fetch() { # usa el clon local si existe; si no, descarga (curl ... | bash)
  if [ -n "$SRC" ] && [ -f "$SRC/$1" ]; then cat "$SRC/$1"; else curl -fsSL "$RAW/$1"; fi
}

mkdir -p "$DEST/agents"
for a in buscador-rapido implementador; do
  f="$DEST/agents/$a.md"
  new="$(fetch "agents/$a.md")"
  if [ -f "$f" ] && [ "$(cat "$f")" != "$new" ]; then cp "$f" "$f.bak"; echo "  respaldo: $f.bak"; fi
  printf '%s\n' "$new" > "$f"
  echo "  agente: $f"
done

START='<!-- claude-delegar:start -->'
END='<!-- claude-delegar:end -->'
md="$DEST/CLAUDE.md"
touch "$md"
tmp="$(mktemp)"
# quita un bloque anterior (reinstalar no duplica) y agrega el actual
awk -v s="$START" -v e="$END" '$0==s{skip=1;next} $0==e{skip=0;next} skip{next}
  /^[[:space:]]*$/{b++;next} {while(b>0){print "";b--} print}' "$md" > "$tmp"
{ [ -s "$tmp" ] && printf '\n'; echo "$START"; fetch regla-claude-md.md; echo "$END"; } >> "$tmp"
mv "$tmp" "$md"
echo "  regla: $md"
echo "Listo. Abre una sesión nueva de Claude Code y escribe /agents para verlos."
