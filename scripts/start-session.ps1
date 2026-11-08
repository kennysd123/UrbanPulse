[CmdletBinding()]
param([string]$Change)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
Push-Location $repoRoot
try {
    $actualRoot = & git rev-parse --show-toplevel
    if ($LASTEXITCODE -ne 0 -or [IO.Path]::GetFullPath($actualRoot) -ne [IO.Path]::GetFullPath($repoRoot)) {
        throw 'Ejecutar desde el checkout UrbanPulse que contiene estos scripts.'
    }
    Write-Output 'Leer AGENTS.md y SDD.md antes de modificar archivos.'
    $branch = & git branch --show-current
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo leer la rama.' }
    $head = & git rev-parse HEAD
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo leer HEAD.' }
    Write-Output ('Rama: ' + $branch)
    Write-Output ('HEAD: ' + $head)
    & git --no-optional-locks status --short
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo leer el estado Git.' }
    & git diff --cached --stat
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo inspeccionar el índice.' }
    & openspec --version
    if ($LASTEXITCODE -ne 0) { throw 'OpenSpec no disponible.' }
    $rootJson = & openspec list --json
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo resolver la raíz OpenSpec.' }
    $rootInfo = $rootJson | ConvertFrom-Json
    if (-not $rootInfo.root.path -or [IO.Path]::GetFullPath($rootInfo.root.path) -ne [IO.Path]::GetFullPath($repoRoot)) {
        throw 'OpenSpec no resolvió la única raíz local autorizada; revisar configuración antes de continuar.'
    }
    Write-Output $rootJson
    & openspec list --specs --json
    if ($LASTEXITCODE -ne 0) { throw 'No se pudieron listar specs.' }
    if ($Change) {
        if ($Change -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') { throw 'Change debe ser kebab-case.' }
        & openspec status --change $Change --json
        if ($LASTEXITCODE -ne 0) { throw 'Change no encontrado o estado inválido.' }
        Write-Output "Leer openspec/changes/$Change y su approval.md. El estado CLI no acredita aprobación."
    } else {
        Write-Output 'Sin change seleccionado. Seleccionar explícitamente antes de Apply; no inferir del handoff.'
    }
    foreach ($localFile in @('.ai-context/UrbanPulse.md', '.ai-context/session-handoff.md')) {
        if (Test-Path -LiteralPath $localFile) { Write-Output "Contexto auxiliar disponible: $localFile (leer y cotejar con Git)." }
    }
    Write-Output 'Inicio de solo lectura terminado. No se ejecutó Apply, staging, commit, push ni Archive.'
} finally { Pop-Location }
