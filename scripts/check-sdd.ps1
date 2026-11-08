[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
Push-Location $repoRoot
try {
    $actualRoot = & git rev-parse --show-toplevel
    if ($LASTEXITCODE -ne 0 -or [IO.Path]::GetFullPath($actualRoot) -ne [IO.Path]::GetFullPath($repoRoot)) {
        throw 'La raíz Git debe coincidir con el checkout que contiene estos scripts.'
    }
    $required = @('AGENTS.md', 'SDD.md', 'openspec/config.yaml', '.agents/rules/urbanpulse.md', '.agents/skills/.openspec-target')
    $skills = @('explore', 'propose', 'continue-change', 'update-change', 'apply-change', 'verify-change', 'sync-specs', 'archive-change', 'onboard')
    $commands = @('explore', 'propose', 'continue', 'update', 'apply', 'verify', 'sync', 'archive', 'onboard')
    foreach ($skill in $skills) { $required += ".agents/skills/openspec-$skill/SKILL.md" }
    foreach ($command in $commands) { $required += ".agents/workflows/opsx-$command.md" }
    foreach ($path in $required) {
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Falta $path" }
    }
    foreach ($path in @('openspec/specs', 'openspec/changes/archive')) {
        if (-not (Test-Path -LiteralPath $path -PathType Container)) { throw "Falta $path" }
    }
    foreach ($path in @('.ai-context/UrbanPulse.md', '.ai-context/session-handoff.md')) {
        & git check-ignore -q -- $path
        if ($LASTEXITCODE -ne 0) { throw "Contexto local no excluido: $path" }
    }
    $trackedContext = @(& git ls-files -- .ai-context)
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo comprobar si el contexto está versionado.' }
    if ($trackedContext.Count -gt 0) { throw 'Hay contexto operativo versionado.' }
    foreach ($path in $required | Where-Object { $_ -like '.agents/skills/*/SKILL.md' -or $_ -like '.agents/workflows/*.md' }) {
        $content = Get-Content -LiteralPath $path -Raw
        if (-not $content.Contains('<!-- URBANPULSE:SDD-GATE:v1 -->') -or -not $content.Contains('AGENTS.md') -or -not $content.Contains('SDD.md')) {
            throw "Falta la entrada de aprobación del proyecto en $path; revisar posibles regeneraciones."
        }
        if ($content -match '(?m)^allowed-tools:') {
            throw "Preautorización de herramientas no revisada en $path; conservar los permisos normales del cliente."
        }
    }
    foreach ($path in $required) {
        & git check-ignore -q -- $path
        if ($LASTEXITCODE -eq 0) { throw "Archivo compartido ignorado: $path" }
        if ($LASTEXITCODE -gt 1) { throw 'Falló check-ignore.' }
    }
    & openspec --version
    if ($LASTEXITCODE -ne 0) { throw 'CLI no funcional.' }
    $rootJson = & openspec list --json
    if ($LASTEXITCODE -ne 0) { throw 'Raíz OpenSpec inválida.' }
    $rootInfo = $rootJson | ConvertFrom-Json
    if (-not $rootInfo.root.path -or [IO.Path]::GetFullPath($rootInfo.root.path) -ne [IO.Path]::GetFullPath($repoRoot)) {
        throw 'OpenSpec no resolvió la única raíz local autorizada; revisar configuración antes de continuar.'
    }
    Write-Output $rootJson
    & openspec list --specs --json
    if ($LASTEXITCODE -ne 0) { throw 'No se pudieron listar specs.' }
    & git diff --check
    if ($LASTEXITCODE -ne 0) { throw 'Errores de whitespace en diff versionado.' }
    & git diff --cached --check
    if ($LASTEXITCODE -ne 0) { throw 'Errores de whitespace en el índice.' }
    Write-Output 'Estructura, entradas de workflows y exclusiones verificadas.'
    Write-Output 'Esto no prueba carga en IDE, aprobación humana, specs, comportamiento ni ausencia exhaustiva de secretos.'
    Write-Output 'Validar cada change real con openspec validate <change> --strict --no-interactive y ejecutar Tests/Verify.'
} finally { Pop-Location }
