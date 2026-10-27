# Instala claude-delegar: 2 agentes en ~/.claude/agents y la regla en ~/.claude/CLAUDE.md.
$ErrorActionPreference = 'Stop'
$Raw = if ($env:CLAUDE_DELEGAR_RAW) { $env:CLAUDE_DELEGAR_RAW } else { 'https://raw.githubusercontent.com/cuajada69/claude-delegar/main' }
$Dest = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $HOME '.claude' }
$Src = $PSScriptRoot
$Utf8 = New-Object System.Text.UTF8Encoding($false)

function Get-RepoFile($path) {
  # usa el clon local si existe; si no, descarga (irm ... | iex)
  if ($Src -and (Test-Path (Join-Path $Src $path))) { return [IO.File]::ReadAllText((Join-Path $Src $path), $Utf8) }
  $bytes = (Invoke-WebRequest -UseBasicParsing "$Raw/$path").RawContentStream.ToArray()
  return $Utf8.GetString($bytes)
}

New-Item -ItemType Directory -Force (Join-Path $Dest 'agents') | Out-Null
foreach ($a in 'buscador-rapido', 'implementador') {
  $f = Join-Path $Dest "agents\$a.md"
  $new = Get-RepoFile "agents/$a.md"
  if ((Test-Path $f) -and ([IO.File]::ReadAllText($f, $Utf8) -ne $new)) { Copy-Item $f "$f.bak" -Force; Write-Host "  respaldo: $f.bak" }
  [IO.File]::WriteAllText($f, $new, $Utf8)
  Write-Host "  agente: $f"
}

$start = '<!-- claude-delegar:start -->'
$end = '<!-- claude-delegar:end -->'
$md = Join-Path $Dest 'CLAUDE.md'
$old = if (Test-Path $md) { [IO.File]::ReadAllText($md, $Utf8) } else { '' }
# quita un bloque anterior (reinstalar no duplica) y agrega el actual
$old = [regex]::Replace($old, '(\r?\n)*' + [regex]::Escape($start) + '[\s\S]*?' + [regex]::Escape($end) + '\r?\n?', '')
$block = "$start`n" + (Get-RepoFile 'regla-claude-md.md').TrimEnd() + "`n$end`n"
$sep = if ($old.Trim()) { "`n" } else { '' }
[IO.File]::WriteAllText($md, $old.TrimEnd() + $sep + $(if ($sep) { "`n" } else { '' }) + $block, $Utf8)
Write-Host "  regla: $md"
Write-Host 'Listo. Abre una sesion nueva de Claude Code y escribe /agents para verlos.'
