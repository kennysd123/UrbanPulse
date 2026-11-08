[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Agent,
    [string]$Change = 'ninguno',
    [Parameter(Mandatory)][string]$Phase,
    [Parameter(Mandatory)][string]$Objective
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$target = Join-Path $repoRoot '.ai-context/session-handoff.md'
Push-Location $repoRoot
try {
    $actualRoot = & git rev-parse --show-toplevel
    if ($LASTEXITCODE -ne 0 -or [IO.Path]::GetFullPath($actualRoot) -ne [IO.Path]::GetFullPath($repoRoot)) {
        throw 'La raíz Git debe coincidir con el checkout que contiene estos scripts.'
    }
    foreach ($candidate in @((Split-Path $target -Parent), $target)) {
        $item = Get-Item -LiteralPath $candidate -Force -ErrorAction SilentlyContinue
        if ($item -and ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            throw 'Contexto redirigido mediante enlace o junction: no se escribirá fuera de la ubicación local prevista.'
        }
    }
    if (Test-Path -LiteralPath $target) { throw 'Handoff existente: leer, revisar y editar explícitamente; no se sobrescribió.' }
    & git check-ignore -q -- .ai-context/session-handoff.md
    if ($LASTEXITCODE -ne 0) { throw 'El handoff debe estar excluido de Git.' }
    $trackedContext = @(& git ls-files -- .ai-context)
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo comprobar si el contexto está versionado.' }
    if ($trackedContext.Count -gt 0) { throw 'Revisar archivos versionados bajo .ai-context antes de escribir.' }
    $branch = & git branch --show-current
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo leer la rama.' }
    $head = & git rev-parse HEAD
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo leer HEAD.' }
    $stamp = [DateTimeOffset]::Now.ToString('o')
    $body = @"
# Handoff de sesión — pendiente de completar y revisar

- Fecha: $stamp
- Proyecto: UrbanPulse
- Agente: $Agent
- Rama: $branch
- Commit HEAD: $head
- Change OpenSpec: $Change
- Fase SDD: $Phase
- Objetivo: $Objective

## Trabajo realizado

Pendiente de completar con hechos observados.

## Archivos modificados

Pendiente de contrastar con el estado inicial y Git actual.

## Pruebas y verificaciones

Pendiente: registrar comandos, resultados y limitaciones; no asumir pruebas exitosas.

## Decisiones confirmadas

Ninguna aprobación nueva registrada por este script.

## Propuestas pendientes

Pendiente de completar. Crear el archivo no aprueba contenido.

## Bloqueos

Pendiente de completar.

## Próximo paso

Revisar y completar este handoff antes de transferir la sesión.
No importar automáticamente en KennyBrain ni publicar en GitHub.
"@
    New-Item -ItemType Directory -Path (Split-Path $target -Parent) -Force | Out-Null
    $stream = [IO.File]::Open($target, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write)
    try {
        $bytes = [Text.UTF8Encoding]::new($false).GetBytes($body.Replace("`r`n", "`n") + "`n")
        $stream.Write($bytes, 0, $bytes.Length)
    } finally { $stream.Dispose() }
    Write-Output 'Creado handoff local; completar y revisar antes de finalizar.'
} finally { Pop-Location }
