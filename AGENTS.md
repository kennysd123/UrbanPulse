# UrbanPulse — Instrucciones para agentes de IA

Ámbito: todo el repositorio. Este archivo orienta el trabajo de Codex y otros agentes; remite a las fuentes del proyecto y no las sustituye ni aprueba propuestas por sí mismo. Estado de esta entrega: pendiente de auditoría.

## 1. Contexto del proyecto

UrbanPulse es una plataforma web de descubrimiento, consulta de disponibilidad y reserva de entretenimiento y recreación en Huamanga. Atiende canchas de gras, karaokes, salones de eventos y recreos.

- Canchas: reserva directa de recurso, fecha y bloque horario configurado, sin exigir duración uniforme.
- Karaoke: reserva directa de sala, fecha e intervalo.
- Salón y recreo: solicitud de evento, revisión, cotización y condiciones registradas por el propietario y aceptadas por el cliente dentro de UrbanPulse. En recreos se reserva el ambiente o espacio definido por el propietario, sin presumir exclusividad de todo el establecimiento o del día.

Consultar [actores](Doc/01-analisis-de-sistema/01-actores.md), [historias de usuario](Doc/01-analisis-de-sistema/02-historias-del-usuarios.md) y [requisitos funcionales](Doc/01-analisis-de-sistema/03-requisitos-funcionales.md).

## 2. Arquitectura aprobada

Respetar las nueve decisiones adoptadas en el [catálogo ADR](Doc/01-analisis-de-sistema/07-decisiones-arquitectonicas.md), especialmente:

- **Monolito Modular**: una aplicación desplegable con responsabilidades modulares (ADR-001).
- **Clean Architecture** con cuatro capas oficiales: **Presentación, Aplicación, Dominio e Infraestructura** (ADR-002). Presentación recibe operaciones, Aplicación coordina casos de uso, Dominio expresa reglas e Infraestructura implementa repositorios y adaptadores. Las dependencias de código se orientan hacia el núcleo; Dominio no depende de Infraestructura.
- Modalidades diferenciadas y disponibilidad integrada a la confirmación (ADR-003/ADR-004).
- **API REST entre aplicación web y backend** (RC03/ADR-005).
- Integraciones mediante interfaces/adaptadores, autorización por roles y persistencia mediante repositorios (ADR-006–ADR-008).
- **Persistencia relacional sin motor específico aprobado** (RC04); optimización de consultas sin caché o métricas concretas aprobadas (ADR-009).

No seleccionar lenguaje, framework, ORM, motor, proveedor de mapas, infraestructura ni mecanismos adicionales sin aprobación. La notación TypeScript y las extensiones `.ts` del diseño interno son ilustrativas.

## 3. Fuentes de verdad y estado documental

Consultar en este orden, atendiendo al nivel de aprobación de cada elemento:

1. **Análisis y requisitos aprobados**: actores, HU y RF enlazados arriba; [atributos AC](Doc/01-analisis-de-sistema/04-atributos-de-calidad.md) y [restricciones RC y decisiones DF/DP](Doc/01-analisis-de-sistema/05-restricciones.md).
2. **ADR y decisiones arquitectónicas vigentes**: catálogo ADR, [drivers DA](Doc/01-analisis-de-sistema/06-driver-arquitectonicos.md) y documentos de [arquitectura inicial](Doc/02-arquitectura-software/01-arquitectura-inicial.md), [estilo](Doc/02-arquitectura-software/02-estilo-arquitectonico.md) y [enfoque](Doc/02-arquitectura-software/03-enfoque-arquitectonico.md), sujetos a las discrepancias señaladas abajo.
3. **Reglas RN, DF y DP**: [reglas de negocio y catálogo PC](Doc/03-diseño-software/01-reglas-de-negocio.md), contrastadas con el documento de restricciones. Conservar sus niveles individuales: aprobada, derivada, propuesta o pendiente.
4. **Estados y flujos aprobados**: consultar [estados y transiciones](Doc/03-diseño-software/02-estados-y-transiciones.md) y [flujos de reserva](Doc/03-diseño-software/03-flujos-de-reserva.md), distinguiendo las condiciones aprobadas de los nombres intermedios y secuencias propuestos.
5. **Diseño interno propuesto**: [diseño de módulos](Doc/03-diseño-software/diseño-interno/diseño-interno-de-modulos.md) y [patrones](Doc/03-diseño-software/diseño-interno/patrones-de-diseño.md). Sus clases, firmas, DTO, carpetas y composición concretos siguen sujetos a aprobación.

ADR-001–ADR-009 están adoptadas; DF-01–DF-06 y DP-01–DP-12 están aprobadas. Hay 20 RF catalogados: 19 aprobados y RF13 pendiente. La formalización detallada de DF-02 en HU/RF continúa pendiente. Los dos estados informativos del saldo de DP-08 están aprobados; ello no aprueba todas las máquinas de estados. Los [escenarios EQ](Doc/01-analisis-de-sistema/08-escenarios-atributos-calidad.md) conservan procedimientos y métricas pendientes de revisión; no acreditan pruebas ejecutadas.

**No resolver contradicciones silenciosamente.** Informar fuentes, contenido en conflicto, criterio respaldado y efecto sobre el cambio; solicitar definición si impide continuar sin decidir algo pendiente. No inferir aprobación por fecha, presencia en Git, imagen o ejemplo.

Discrepancias conocidas: README y arquitectura inicial describen una separación de tres capas frente a las cuatro de ADR-002; aplicar ADR-002 y reportar el desfase. El estilo menciona ORM, pero no basta para aprobar una selección técnica. Patrones declara aprobación conceptual y el diseño interno conserva pendiente la aprobación concreta: no extender aquella declaración a clases o firmas. El ADR contiene referencias gráficas desactualizadas y una afirmación de armonización que no coincide con el texto inicial actual. El [inventario gráfico](Doc/diagramas/INVENTARIO-PENDIENTES.md) y el [informe documental](Doc/03-diseño-software/04-informe-actualizacion-pagos-simulados.md) son antecedentes auxiliares de disponibilidad local: no forman parte necesariamente del repositorio versionado ni son fuentes obligatorias para otros agentes o colaboradores. Consultarlos solo si están disponibles; su ausencia no impide aplicar estas instrucciones ni altera la jerarquía de fuentes de verdad o las discrepancias conocidas. Sus estados históricos de Git no sustituyen la inspección actual.

## 4. Reglas funcionales inmutables sin autorización

- Preservar las reservas directas de cancha/karaoke, sin solicitud de evento ni cotización obligatoria. Requieren adelanto simulado obligatorio configurado por recurso y disponibilidad válida al confirmar (DF-04).
- Preservar las solicitudes de salón/recreo. Confirmar exige conjuntamente aceptación del cliente dentro de UrbanPulse, adelanto simulado aprobado y disponibilidad verificada (DF-02/DF-03). Aceptar la solicitud, aceptar condiciones y confirmar son hechos distintos; WhatsApp no sustituye la aceptación interna.
- Mostrar total y adelanto antes de iniciar la simulación; fijar ambos al iniciarla (DP-03). No imponer S/ 10, porcentajes ni plazos universales. Rechazo o ausencia de aprobación y disponibilidad inválida impiden confirmar.
- Impedir confirmaciones incompatibles incluso bajo concurrencia. Consultar disponibilidad o coordinar no retiene el recurso ni garantiza disponibilidad futura (RN-12/RN-13; PC-05).
- Registrar posteriormente el **saldo completo simulado** solo por propietario autorizado sobre reserva confirmada propia (HU14/RF20). Saldo = total acordado menos adelanto aprobado y aplicado (DP-04). Conservar reserva, importe, método informativo, autor, fecha/hora, una recepción activa e historial de correcciones. Saldo cero sigue pendiente de representación: no inventar recepción.
- Mantener separados resultado del adelanto, estado de Reserva y registro del saldo. RF19 exige reflejar el resultado del adelanto en la situación de la reserva; aprobación aislada no confirma. Registrar o corregir saldo no cambia Reserva ni el resultado del adelanto.
- Todo pago es simulación académica. Efectivo, Yape, Plin y transferencia son categorías informativas. **Prohibido introducir pagos reales, integraciones financieras, reembolsos, pagos parciales del saldo o funcionalidades no autorizadas.** No generar comprobantes bancarios ni afirmar recepción de fondos reales.
- **RF13 continúa pendiente**: no habilitar cancelación, devolución, expiración, reapertura o cierre del ciclo por inferencia. No ampliar al administrador a gestión de usuarios (HU11/RF15), ni incorporar mensajería propia, compra de comidas/entradas/actividades o reserva de habitaciones.

## 5. Decisiones técnicas y contractuales pendientes

Mantener explícitamente abiertos **PC-01–PC-12** del catálogo RN. Este índice orienta la consulta; el detalle y los límites aprobados permanecen en la fuente:

- PC-01–PC-04: contenido/versiones y aceptación de cotización; creación y relaciones de Reserva/Solicitud/Pago; iniciador de confirmación del evento; alcance temporal, solapamientos y espacios compartidos.
- **PC-05: garantía ante concurrencia y disponibilidad durante coordinación.** La prohibición de doble confirmación está aprobada; su mecanismo no. Una consulta seguida de escritura, un callback o un diagrama secuencial no demuestra la garantía. No dar por aprobados bloqueos, retenciones o expiraciones.
- PC-06–PC-08: precisión monetaria, límites y saldo cero; resolución del adelanto aprobado sin disponibilidad u otras condiciones; fallos, reintentos, duplicados y asociación de resultados. La fórmula del saldo y su registro manual completo ya están aprobados y no se reabren.
- PC-09–PC-12: no aceptación, cambios y reapertura; cancelación y ciclo posterior; permisos detallados y mecanismos de autenticación/autorización; cobertura HU/RF/DA y evaluación EQ.

El procedimiento concreto de corrección con historial y unicidad activa, contratos REST, persistencia y simulador siguen pendientes de diseño. Presentar alternativas como propuestas identificadas; no introducir mecanismos técnicos como decisiones definitivas sin aprobación.

## 6. Reglas de trabajo con Codex

Antes de modificar cualquier archivo:

1. Leer estas instrucciones, el contexto documental pertinente y el estado actual de Git.
2. Identificar dependencias funcionales, arquitectónicas, documentales y de trazabilidad del cambio.
3. Separar hechos aprobados, consecuencias derivadas, propuestas y pendientes; explicar contradicciones detectadas.
4. Delimitar los archivos y el alcance autorizado; preservar trabajo preexistente y convenciones locales.

Durante el trabajo, limitar los cambios a lo solicitado. No reescribir documentos aprobados ni reorganizar rutas innecesariamente. No convertir ejemplos académicos en implementación o tecnologías adoptadas. Si falta una decisión necesaria, exponer el pendiente y continuar únicamente con trabajo independiente que esté autorizado.

## 7. Documentación y diagramas

- Usar Markdown compatible con GitHub y Obsidian, enlaces relativos y Mermaid editable cuando corresponda. Guardar imágenes en `Doc/diagramas/`; conservar la fuente editable y distinguirla de su exportación.
- Preservar las carpetas por etapa: `Doc/01-analisis-de-sistema/`, `Doc/02-arquitectura-software/`, `Doc/03-diseño-software/` y su subcarpeta `diseño-interno/`. Los documentos usan prefijos numéricos y nombres descriptivos separados por guiones; mantener identificadores existentes.
- Verificar destinos, anclas, mayúsculas, tildes y espacios exactos, también respecto del nombre versionado por Git. No normalizar nombres existentes como `02-historias-del-usuarios.md` o `06-driver-arquitectonicos.md`. Codificar o delimitar correctamente los espacios en enlaces.
- Mantener trazabilidad **HU → RF → AC/DA → ADR → componentes** solo con evidencia; distinguir origen explícito, relación complementaria y contexto. HU03/RF04 y HU04/RF06 son asociaciones contextuales; RF02/RF09/RF10 carecen de origen explícito en drivers. AC02/AC07 no tienen driver ni respuesta arquitectónica explícita. No inventar relaciones, requisitos o identificadores para cerrar huecos.
- Diagramas, propuestas y evaluaciones documentadas no prueban implementación, renderizado ni cumplimiento de métricas. Reportar desfases gráficos sin editar etapas protegidas fuera del alcance.

## 8. Git y control de versiones

- **No ejecutar `git add`, `git commit` ni `git push` sin autorización explícita.**
- No incorporar informes auxiliares ni archivos locales no solicitados. Preservar archivos sin seguimiento y cambios ajenos; no eliminarlos ni revertirlos para limpiar el estado.
- No modificar etapas cerradas salvo indicación expresa. No deducir su reapertura de un informe histórico ni de una inconsistencia detectada.
- Antes de finalizar, mostrar los archivos creados/modificados y contrastarlos con el estado inicial; revisar el diferencial y el índice.
- Ejecutar las verificaciones disponibles y pertinentes: rutas/anclas, estructura Markdown, consistencia documental y `git diff --check`; herramientas de diagramas o pruebas de código cuando existan y correspondan. Revisar por separado archivos nuevos sin seguimiento, que el diff normal omite.
- Informar comandos/resultados y limitaciones. No afirmar éxito de pruebas, parser, renderizado o comprobaciones no ejecutadas.

## 9. Formato de entrega

Al terminar cada tarea, presentar:

1. Archivos creados o modificados, distinguiéndolos de cambios preexistentes.
2. Resumen del cambio y su alcance.
3. Decisiones aprobadas respetadas, con referencias pertinentes.
4. Nuevas propuestas, si las hubiera, sin tratarlas como aprobadas.
5. Pendientes y contradicciones identificados.
6. Verificaciones realizadas, resultados y limitaciones.
7. Estado de Git: rama, cambios, índice y si hubo operaciones autorizadas de commit/push.

Cuando se solicite auditoría, presentar el contenido o diferencial revisable antes de su aprobación; no declarar aprobación por haber creado el archivo.
