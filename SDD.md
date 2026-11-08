# UrbanPulse — flujo SDD compartido

Esta guía configura Spec-Driven Development para cambios nuevos. Complementa el uso de «Software Design Description» del README sin renombrar la documentación histórica. Estado de la entrega: **preparada para revisión humana**. No implementa funcionalidades ni migra requisitos a specs automáticamente.

## Fuentes y límites

Una sola raíz `openspec/` sirve a todos los agentes. Para cambios nuevos, consultar en este orden:

1. Specs OpenSpec explícitamente aprobadas y vigentes, con evidencia de revisión.
2. ADR y decisiones arquitectónicas aprobadas, respetando su estado individual.
3. Requisitos, reglas y documentación oficial vigente según [AGENTS.md, sección 3](AGENTS.md#3-fuentes-de-verdad-y-estado-documental).
4. Código y pruebas para conocer el comportamiento implementado.
5. Contexto generado desde KennyBrain, si existe integración verificada.
6. Handoff anterior, contrastado con Git y las fuentes actuales.
7. Conversaciones como antecedentes no normativos.

**Diferencia de jerarquías:** AGENTS.md empieza por requisitos aprobados; esta metodología empieza por specs aprobadas para cambios nuevos. Ninguna spec, sync o archivo reabre documentos cerrados por sí mismo. Si hay conflicto, registrar rutas, contenido, estado aprobado/propuesto, comportamiento actual y deseado; suspender la parte afectada y pedir resolución al responsable. Actualizar las fuentes pertinentes solo con autorización. Mientras no existan specs aprobadas, rige la documentación oficial con los niveles de AGENTS.md. Estar en `specs/`, Git o `archive/` no demuestra aprobación.

Se conservan ADR-001–ADR-009 adoptadas, ADR-010/011 en su alcance conceptual acotado y ADR-012 propuesta. Monolito modular, cuatro capas, ocho módulos, REST y persistencia relacional sin motor seleccionado; Redis solo fichas públicas reconstruibles y RabbitMQ solo sus invalidaciones técnicas. RF13 y PC-01–PC-12 siguen abiertos. La configuración SDD no selecciona tecnología del producto.

## Inicio de sesión

Leer [AGENTS.md](AGENTS.md), [README.md](README.md), esta guía y las fuentes pertinentes. Desde PowerShell en la raíz:

```powershell
./scripts/start-session.ps1
./scripts/sync-context.ps1
Get-Content .ai-context/UrbanPulse.md
# Si existe, leer y contrastar el handoff antes de continuar:
# Get-Content .ai-context/session-handoff.md
# Con un change real seleccionado:
# ./scripts/start-session.ps1 -Change 'nombre-del-change'
```

`start-session.ps1` es de solo lectura: informa rama, HEAD, cambios, índice y OpenSpec. No selecciona un change por suposición. Leer sus artefactos completos y `approval.md` antes de actuar. Con múltiples changes, pedir selección si el encargo no identifica uno. Conservar cambios ajenos incluso sin seguimiento.

`sync-context.ps1` genera exclusivamente un índice local desde el repositorio; su nombre conserva la entrada de la metodología original, pero **no sincroniza KennyBrain**. Solo reemplaza su propio archivo marcado, nunca contexto manual ni handoff. `.ai-context/` está excluida por `.gitignore`. No usar `git add -f` para publicarla.

## Herramientas y perfil

Configuración comprobada con OpenSpec **1.13.1**, instalación npm preexistente, Node **24.14.0**, npm **11.9.0**, Windows 10 (build 19045) y PowerShell **7.6.9**. No se descargó ni instaló software, no se actualizó PATH ni se cambió configuración global. El Node local satisface tanto el requisito del paquete instalado como el de la documentación web actual.

La CLI local y `--help` gobiernan los comandos de esta guía. La web puede describir versiones posteriores: por ejemplo, esta CLI no ofrece `openspec update --dry-run`. Consultar ayuda antes de actualizar. Fuentes oficiales: [instalación](https://openspec.dev/docs/installation), [setup](https://openspec.dev/docs/setup), [perfiles](https://openspec.dev/docs/profiles) y [CLI](https://openspec.dev/docs/cli).

Se utilizó el perfil global **custom** ya existente, entrega **both**: `propose`, `explore`, `continue`, `apply`, `update`, `sync`, `archive`, `verify`, `onboard`. El esquema es **spec-driven** sin personalizaciones. Los estados humanos descritos abajo son complementarios; no cambian el esquema. Verify está instalado explícitamente. Onboard/Continue se conservaron por el perfil existente; **Onboard no es una prueba inocua** y no debe ejecutarse en esta Tarea 0.

En otra máquina comprobar primero `openspec --version`, `openspec init --help` y `openspec config list`. Si falta la CLI, inspeccionar el instalador oficial de Windows y solicitar autorización explícita antes de descargar, ejecutar scripts remotos, instalar globalmente o alterar PATH. No reinstalar una CLI compatible. Preparar con `openspec config profile` un conjunto que incluya Explore, Propose, Update, Apply, Verify, Sync y Archive; advertir que el perfil se guarda globalmente y revisar su efecto en otros proyectos. La configuración global no se versiona: los archivos generados sí son portables.

Antes de regenerar, inspeccionar destinos y preservar cambios propios. Para los agentes detectados en esta entrega se ejecutó:

```powershell
openspec init . --tools 'codex,antigravity' --profile custom --language Spanish --no-animation
```

Las comillas de `'codex,antigravity'` son necesarias al pasar el argumento mediante el shim PowerShell. En futuros cambios revisar el diff de los archivos generados; `openspec update` puede sustituirlos y usar el perfil de esa máquina. No ejecutarlo automáticamente. Las reglas centrales están en AGENTS.md y esta guía. Las nueve skills y los nueve workflows incluyen una entrada local marcada `URBANPULSE:SDD-GATE:v1` que exige consultarlas; Apply, Sync y Archive nunca quedan autorizados por las instrucciones genéricas. Onboard detiene la planificación para revisión y no encadena archivo. `check-sdd.ps1` comprueba que estas entradas sigan presentes tras una regeneración; no actualiza ni repara archivos automáticamente.

Se retiró de las nueve skills la preautorización heredada `allowed-tools: Bash(openspec:*)`. Se conservan los permisos normales del cliente: omitir el campo no restringe técnicamente las herramientas ni valida aprobaciones humanas. No añadir concesiones de herramientas sin revisión. En clientes que implementan esa semántica, `allowed-tools` puede evitar solicitudes de permiso, según la [documentación oficial de skills](https://code.claude.com/docs/en/skills#pre-approve-tools-for-a-skill); no se ha probado esa integración futura de Claude Code en este equipo.

| Herramienta | Entrada e instrucciones | Estado de esta entrega |
|---|---|---|
| Codex | `AGENTS.md`, `.agents/skills/`; en chat `$openspec-explore` | CLI y generación comprobadas; Explore leída y simulada. El catálogo de esta sesión ya descubre las nueve skills del proyecto; no acredita su ejecución ni una sesión nueva del cliente. |
| Antigravity | `.agents/skills/`, `.agents/workflows/opsx-*.md`, regla `.agents/rules/urbanpulse.md`; en chat `/opsx-explore` | Instalación local detectada y archivos generados por CLI. Carga y ejecución en IDE pendientes. |
| Claude Code | Al estar disponible, revisar `openspec init --tools claude`; genera `.claude/skills/` y comandos | CLI no detectada; no se creó una integración ficticia. Leer AGENTS.md/SDD.md explícitamente mientras tanto. |
| GitHub Copilot | Al estar disponible, revisar `openspec init --tools github-copilot --no-copilot-cloud` y sus destinos `.github/` | No detectado en extensiones VS Code inspeccionadas; no se generaron adaptadores ni workflows cloud. |
| Otros agentes | Leer `AGENTS.md`, esta guía, configuración y change; los compatibles con skills pueden leer `.agents/skills/` | Protocolo portable; no acredita integración o ejecución de herramientas ausentes. |

La CLI 1.13.1 reconoce oficialmente los cuatro identificadores anteriores y `agents` para el destino universal. No hace falta duplicar specs. La regla de Antigravity usa `trigger: always_on`, según [su documentación oficial](https://antigravity.google/docs/rules/). El producto local inspeccionado admite selectores `.agents/rules/` y `.agents/workflows/`; falta probar su carga efectiva en una sesión nueva del IDE.

## Flujo y puertas humanas

Contexto → Explore → Propose → revisión humana → corrección de specs → Validate → **aprobación explícita** → Apply → Tests → Verify → correcciones → Verify limpio → revisión Git → **selección/staging y commit autorizados** → **push/PR autorizado por separado** → Sync/Archive con cierre humano → Handoff.

| Paso | Acción y condición de avance |
|---|---|
| Explore | Leer contexto e investigar. No código funcional ni configuración de producto. Capturar artefactos solo dentro del alcance pedido. |
| Propose | Generar proposal/specs/design/tasks con el workflow; nunca encadenar Apply. Crear changes reales con `openspec new change`, no a mano. |
| Update | Corregir artefactos y volver a revisión; ninguna conversación ni checkbox equivale a aprobación. |
| Validate | `openspec validate 'nombre-del-change' --strict --no-interactive`; comprueba estructura, no decisión humana ni coherencia semántica completa. |
| Apply | Leer evidencia humana y revisión aprobada; detenerse por decisiones no especificadas. Actualizar artefactos y renovar revisión antes de reanudar. |
| Tests | Ejecutar verificaciones pertinentes al comportamiento, contratos y fronteras arquitectónicas; documentar comandos/resultados y ausencias. |
| Verify | Comparar implementación con proposal/specs/design/tasks y pruebas. Corregir hallazgos y repetir hasta resultado limpio; suite verde sola no basta. |
| Revisión Git | Revisar archivos nuevos, diff, índice y exclusiones; seleccionar archivos explícitos. No add/commit sin permiso; push separado. |
| Sync/Archive | Sync requiere autorización explícita sobre las specs destino revisadas; conservar decisiones pendientes. Archivar solo con cierre humano después de Tests, Verify limpio y revisión Git, sin usar flags para omitir validación. |
| Handoff | Finalizar toda sesión, incluso bloqueada o con change abierto; no implica cierre ni aprobación. |

Las puertas son instrucciones verificables por revisión humana; **no son ACL ni bloqueos ejecutables de la CLI**. OpenSpec puede considerar un change listo sin aprobación. No se instalaron hooks ni mecanismos que garanticen impedir una invocación directa.

## Registro complementario del change

Para cada change real añadir `openspec/changes/<change>/approval.md` junto a sus artefactos. No existe ningún change de muestra en esta entrega. El registro debe conservar historial y distinguir validación técnica de aprobación del responsable. Usar esta estructura mínima:

```markdown
# Revisión del change

- Estado metodológico: Propuesta
- Revisión de artefactos: pendiente (identificar commit y/o hashes de proposal, specs, design y tasks)
- Validación técnica: pendiente (comando, fecha y resultado)
- Aprobación Apply: pendiente
- Evidencia del responsable: pendiente (fecha y referencia explícita saneada)
- Verify limpio: pendiente (evidencia de comportamiento, contratos y arquitectura)
- Selección/staging y commit: sin autorización
- Push/PR: sin autorización separada
- Sync: pendiente de revisión de destinos
- Cierre/Archive: pendiente del responsable

## Historial

Registrar transiciones, evidencia y revisión afectada; no inventar firmas ni copiar conversaciones privadas.
```

Estados complementarios: **Exploración → Propuesta → En revisión → Correcciones pendientes → En revisión → Validada técnicamente → Aprobada por el responsable → En implementación → En verificación → Lista para revisión Git → Publicada → Archivada**. Las correcciones se repiten cuando sean necesarias. Validada técnicamente exige evidencia técnica; Aprobada exige decisión humana independiente. Un cambio de alcance/contrato/arquitectura invalida la aprobación anterior y vuelve a revisión. Publicada exige evidencia de publicación autorizada; no equivale a despliegue productivo. Archivada exige cierre del responsable. Handoff registra la fase real aunque no avance de estado. No inventar transición de negocio ni confundir estos estados con los de Reserva/Pago.

## Comandos diarios

Estos son comandos de terminal compartidos, verificados mediante la ayuda de 1.13.1:

```powershell
openspec --version
openspec --help
openspec list --json
openspec list --specs --json
openspec schemas --json
./scripts/check-sdd.ps1
# Solo para un change real y en la fase autorizada:
# openspec new change 'nombre-del-change'
# openspec status --change 'nombre-del-change' --json
# openspec instructions apply --change 'nombre-del-change' --json
# openspec validate 'nombre-del-change' --strict --no-interactive
# openspec archive 'nombre-del-change'
git status --short
git diff
git diff --cached
git diff --check
```

Explore/Propose/Update/Apply/Verify/Sync son workflows de agente, **no** subcomandos `openspec explore`, `openspec apply` o `openspec verify`. `openspec update` actualiza integraciones; el workflow Update revisa el change. En chat:

| Acción | Codex | Antigravity |
|---|---|---|
| Explore | `$openspec-explore` | `/opsx-explore` |
| Propose | `$openspec-propose` | `/opsx-propose` |
| Update | `$openspec-update-change` | `/opsx-update` |
| Apply aprobado | `$openspec-apply-change` | `/opsx-apply` |
| Verify | `$openspec-verify-change` | `/opsx-verify` |
| Sync revisado | `$openspec-sync-specs` | `/opsx-sync` |
| Archive autorizado | `$openspec-archive-change` | `/opsx-archive` |

Añadir el nombre del change o tema a la invocación. En Codex iniciar una nueva sesión con `codex` desde la raíz si se usa su CLI; esta sesión de escritorio ya dispone del checkout. En Antigravity abrir la raíz como workspace y reiniciar el IDE para descubrir nuevos workflows. No se afirma que esas invocaciones de chat hayan sido ejecutadas en los IDE externos.

## KennyBrain y transferencia

Se leyeron `Flujo-SDD.md` y `Flujo-de-agentes.md` desde la bóveda accesible, sin escribir en ella. No se encontró proyecto UrbanPulse ni script de enlace en el repositorio o en la búsqueda dirigida de la bóveda. Esto no descarta una integración en otra ubicación no inspeccionada. Se conservaron sus principios en esta guía, sin versionar rutas privadas ni copiar contenido personal.

Adaptador opcional pendiente: el responsable puede seleccionar un documento de contexto saneado y definir un exportador de solo lectura, con origen/destino explícitos y tratamiento de contexto manual. No se implementa ni simula ese enlace. Todo lo necesario para continuar está en fuentes versionables del repositorio. El responsable decide qué handoff exportar o importar a KennyBrain después de revisarlo.

Para crear el handoff inicial:

```powershell
./scripts/new-handoff.ps1 -Agent 'agente utilizado' -Phase 'fase real' -Objective 'objetivo de la sesión'
```

Con change real añadir `-Change 'nombre-del-change'`. El script **no sobrescribe** un handoff existente. Leerlo primero y editarlo de forma explícita para conservar antecedentes necesarios. Completar trabajo, archivos, verificaciones, decisiones confirmadas, propuestas, bloqueos y próximo paso; el script ya registra fecha, proyecto, agente, rama, HEAD, change, fase y objetivo. No dejar campos pendientes al entregar. Cambiar de agente implica repetir el inicio y comprobar el estado actual. Transferir entre equipos mediante repositorio y copia saneada explícita del handoff; nunca depender de una ruta privada.

## Estructura y comprobación

```text
AGENTS.md                         reglas existentes y entrada al flujo
SDD.md                            política común y guía de uso
openspec/config.yaml              contexto, reglas y orientación de operaciones
openspec/specs/                    vacía hasta specs reales revisadas
openspec/changes/archive/          vacía hasta cierre de changes reales
.agents/skills/openspec-*/         9 skills oficiales, árbol compartido
.agents/workflows/opsx-*.md        9 comandos oficiales de Antigravity
.agents/rules/urbanpulse.md        referencia a reglas comunes
scripts/start-session.ps1         comprobación de inicio sin escrituras
scripts/sync-context.ps1          índice local reconstruible del repositorio
scripts/new-handoff.ps1           creación sin sobrescritura
scripts/check-sdd.ps1             estructura, CLI y exclusiones
.ai-context/                      contexto y handoff locales, ignorados
```

`check-sdd.ps1` comprueba estructura e ignorados, no implementación de producto ni carga real de IDE. Con inventario vacío, `openspec validate --all --strict --no-interactive` informa que no hay nada que validar: no es una spec validada. No crear/archivar un change ficticio para obtener un resultado verde. Prueba Explore no destructiva: leer contexto e instrucciones, listar specs/changes, investigar un tema de prueba y comprobar que no cambian archivos, índice ni HEAD. No ejecutar Apply, Onboard, commit, push o Archive. No continuar con Sprint 02/Tarea 1/Tarea 2 sin nueva instrucción.

Los scripts comprueban errores de Git y coincidencia de raíz; inicio y verificación rechazan una raíz OpenSpec externa. Los escritores rechazan enlaces/junctions ya presentes en `.ai-context` o en el archivo destino. Contexto se valida y reemplaza con un mismo handle exclusivo, sin truncar antes de leer; el handoff usa creación exclusiva y nunca reemplaza uno existente. Estas medidas protegen los casos comprobados; no constituyen aislamiento frente a otro proceso hostil que sustituya directorios concurrentemente ni garantía de recuperación ante fallo de disco. El contexto marcado es reconstruible: guardar anotaciones manuales en otro archivo local, nunca añadirlas al archivo generado.
