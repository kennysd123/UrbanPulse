[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$contextDir = Join-Path $repoRoot '.ai-context'
$target = Join-Path $contextDir 'UrbanPulse.md'
$marker = '<!-- urbanpulse-repository-context:v1 -->'
Push-Location $repoRoot
try {
    $actualRoot = & git rev-parse --show-toplevel
    if ($LASTEXITCODE -ne 0 -or [IO.Path]::GetFullPath($actualRoot) -ne [IO.Path]::GetFullPath($repoRoot)) {
        throw 'La raíz Git debe coincidir con el checkout que contiene estos scripts.'
    }
    foreach ($candidate in @($contextDir, $target)) {
        $item = Get-Item -LiteralPath $candidate -Force -ErrorAction SilentlyContinue
        if ($item -and ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            throw 'Contexto redirigido mediante enlace o junction: no se escribirá fuera de la ubicación local prevista.'
        }
    }
    & git check-ignore -q -- .ai-context/UrbanPulse.md
    if ($LASTEXITCODE -ne 0) { throw 'El contexto local debe estar excluido de Git antes de generarlo.' }
    $trackedContext = @(& git ls-files -- .ai-context)
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo comprobar si el contexto está versionado.' }
    if ($trackedContext.Count -gt 0) { throw '.ai-context contiene archivos versionados; revisar antes de continuar.' }
    $branch = & git branch --show-current
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo leer la rama.' }
    $head = & git rev-parse HEAD
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo leer HEAD.' }
    $stamp = [DateTimeOffset]::Now.ToString('o')
    $body = @"
$marker
# Contexto auxiliar de UrbanPulse

Generado: $stamp
Rama observada: $branch
HEAD observado: $head

Origen: exclusivamente este repositorio. No hay sincronización con KennyBrain.
Este índice es reconstruible; no editar manualmente. No contiene decisiones nuevas.
Leer AGENTS.md y SDD.md en la raíz, README.md, los documentos pertinentes según
AGENTS.md sección 3, openspec/config.yaml y el change elegido explícitamente.
Ejecutar scripts/start-session.ps1 para comprobar el estado actual de Git/OpenSpec.
Leer session-handoff.md si existe, cotejándolo con las fuentes vigentes.
No interpretar propuestas ni estados CLI como aprobación humana.
"@
    New-Item -ItemType Directory -Path $contextDir -Force | Out-Null
    # Leer y reemplazar con el mismo handle exclusivo: no truncar antes de validar.
    $stream = [IO.File]::Open($target, [IO.FileMode]::OpenOrCreate, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
    try {
        $reader = [IO.StreamReader]::new($stream, [Text.Encoding]::UTF8, $true, 1024, $true)
        try { $previous = $reader.ReadToEnd() } finally { $reader.Dispose() }
        if ($previous.Length -gt 0 -and -not $previous.StartsWith($marker, [StringComparison]::Ordinal)) {
            throw 'Existe contexto manual. Conservarlo y revisarlo; no se sobrescribió.'
        }
        $bytes = [Text.UTF8Encoding]::new($false).GetBytes($body.Replace("`r`n", "`n") + "`n")
        $stream.Position = 0
        $stream.SetLength(0)
        $stream.Write($bytes, 0, $bytes.Length)
    } finally { $stream.Dispose() }
    Write-Output 'Actualizado .ai-context/UrbanPulse.md desde el repositorio; bóveda no utilizada.'
} finally { Pop-Location }
