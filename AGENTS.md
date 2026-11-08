# UrbanPulse — Instrucciones para agentes de IA

Ámbito: todo el repositorio. Este archivo orienta el trabajo de Codex y otros agentes; remite a las fuentes del proyecto y no las sustituye ni aprueba propuestas por sí mismo. Estado de esta entrega: pendiente de auditoría.

## 1. Contexto del proyecto

UrbanPulse es una plataforma web de descubrimiento, consulta de disponibilidad y reserva de entretenimiento y recreación en Huamanga. Atiende canchas de gras, karaokes, salones de eventos y recreos.

- Canchas: reserva directa de recurso, fecha y bloque horario configurado, sin exigir duración uniforme.
- Karaoke: reserva directa de sala, fecha e intervalo.
- Salón y recreo: solicitud de evento, revisión, cotización y condiciones registradas por el propietario y aceptadas por el cliente dentro de UrbanPulse. En recreos se reserva el ambiente o espacio definido por el propietario, sin presumir exclusividad de todo el establecimiento o del día.

Consultar [actores](Doc/01-analisis-de-sistema/01-actores.md), [historias de usuario](Doc/01-analisis-de-sistema/02-historias-del-usuarios.md) y [requisitos funcionales](Doc/01-analisis-de-sistema/03-requisitos-funcionales.md).

## 2. Arquitectura aprobada

Consultar los doce registros ADR-001–ADR-012 y respetar el estado individual de cada decisión en el [catálogo ADR](Doc/01-analisis-de-sistema/07-decisiones-arquitectonicas.md), especialmente:

- **Monolito Modular**: una aplicación desplegable con responsabilidades modulares (ADR-001).
- **Clean Architecture** con cuatro capas oficiales: **Presentación, Aplicación, Dominio e Infraestructura** (ADR-002). Presentación recibe operaciones, Aplicación coordina casos de uso, Dominio expresa reglas e Infraestructura implementa repositorios y adaptadores. Las dependencias de código se orientan hacia el núcleo; Dominio no depende de Infraestructura.
- Modalidades diferenciadas y disponibilidad integrada a la confirmación (ADR-003/ADR-004).
- **API REST entre aplicación web y backend** (RC03/ADR-005).
- Integraciones mediante interfaces/adaptadores, autorización por roles y persistencia mediante repositorios (ADR-006–ADR-008).
- **Persistencia relacional sin motor específico aprobado** (RC04). ADR-009 optimiza consultas de disponibilidad y no aprobó históricamente caché; ADR-010 la complementa sin sustituirla.
- **ADR-010:** Redis/cache-aside exclusivamente para fichas públicas reconstruibles de Establecimientos; la base relacional sigue siendo definitiva.
- **ADR-011:** RabbitMQ transporta invalidaciones técnicas de esas fichas; el consumidor está dentro del backend y no añade un noveno módulo funcional. Worker independiente: **Preparado arquitectónicamente, no obligatorio inicialmente**; implementación posterior, conservando fronteras de consumo/coordinación/invalidación sin modificar Dominio.
- **ADR-012:** modelo financiero propuesto para el objetivo funcional de pagos electrónicos reales. Mercado Pago Marketplace Split 1:1 es candidato pendiente de validación, sin integración ni producción aprobadas.

La arquitectura documentada conserva ocho módulos funcionales, cinco contenedores C2 (aplicación web, backend, base relacional, Redis y RabbitMQ) y seis responsabilidades técnicas conceptuales C3. Esas responsabilidades no son módulos, servicios separados ni clases obligatorias. Los cierres conceptuales históricos de las vistas C4 conservan su alcance técnico; sus fuentes revisadas de pagos reales están disponibles y pendientes de aprobación de la revisión. Sus participantes siguen siendo candidatos ilustrativos.

No seleccionar lenguaje, framework, ORM, motor relacional, proveedor de mapas, infraestructura o mecanismos operativos adicionales sin aprobación. La notación TypeScript y las extensiones `.ts` del diseño interno son ilustrativas. La aprobación conceptual de Redis y RabbitMQ se limita a los alcances indicados y no aprueba configuraciones o garantías operativas.

## 3. Fuentes de verdad y estado documental

Consultar en este orden, atendiendo al nivel de aprobación de cada elemento:

1. **Análisis y requisitos aprobados**: actores, HU y RF enlazados arriba; [atributos AC](Doc/01-analisis-de-sistema/04-atributos-de-calidad.md) y [restricciones RC y decisiones DF/DP](Doc/01-analisis-de-sistema/05-restricciones.md).
2. **ADR y decisiones arquitectónicas vigentes**: catálogo ADR, [drivers DA](Doc/01-analisis-de-sistema/06-driver-arquitectonicos.md) y documentos de [arquitectura inicial](Doc/02-arquitectura-software/01-arquitectura-inicial.md), [estilo](Doc/02-arquitectura-software/02-estilo-arquitectonico.md) y [enfoque](Doc/02-arquitectura-software/03-enfoque-arquitectonico.md), sujetos a las discrepancias señaladas abajo.
3. **Reglas RN, DF y DP**: [reglas de negocio y catálogo PC](Doc/03-diseño-software/01-reglas-de-negocio.md), contrastadas con el documento de restricciones. Conservar sus niveles individuales: aprobada, derivada, propuesta o pendiente.
4. **Estados y flujos aprobados**: consultar [estados y transiciones](Doc/03-diseño-software/02-estados-y-transiciones.md) y [flujos de reserva](Doc/03-diseño-software/03-flujos-de-reserva.md), distinguiendo las condiciones aprobadas de los nombres intermedios y secuencias propuestos.
5. **Diseño Interno**: [diseño de módulos](Doc/03-diseño-software/diseño-interno/diseño-interno-de-modulos.md), [patrones](Doc/03-diseño-software/diseño-interno/patrones-de-diseño.md) y [principios SOLID](Doc/03-diseño-software/diseño-interno/principios-de-diseño.md) conservan su aprobación conceptual y cierre documental históricos en sus alcances; la revisión financiera actual no hereda aprobación de ADR-012. El [diseño técnico D1–D6](Doc/03-diseño-software/diseño-interno/diseno-tecnico-fichas-publicas-redis.md) también está cerrado documentalmente. Estos cierres no aprueban clases, firmas, DTO, carpetas, contratos operativos ni composición concretos.

ADR-001–ADR-009 están adoptadas; ADR-010 y ADR-011 están aprobadas conceptualmente y cerradas documentalmente en sus alcances acotados. Las vistas [C1](Doc/04-modelo-c4/01-contexto-c1.md), [C2](Doc/04-modelo-c4/02-contenedores-c2.md), [C3](Doc/04-modelo-c4/03-componentes-c3.md) y las tres vistas [C4](Doc/04-modelo-c4/04-codigo-c4.md), [C4 de Establecimientos/Redis](Doc/04-modelo-c4/05-codigo-c4-establecimientos-redis.md) y [C4 de invalidación RabbitMQ](Doc/04-modelo-c4/06-codigo-c4-invalidacion-rabbitmq.md) conservan sus cierres conceptuales históricos; sus seis fuentes Mermaid revisadas están disponibles para auditoría, sin aprobación automática de la evolución financiera. ADR-012 sigue propuesta. DF-01–DF-06 y DP-01–DP-12 están aprobadas. Hay 20 RF catalogados: 19 aprobados y RF13 pendiente. La formalización detallada de DF-02 en HU/RF continúa pendiente. Los dos estados informativos del saldo de DP-08 están aprobados; ello no aprueba todas las máquinas de estados. Los [escenarios EQ](Doc/01-analisis-de-sistema/08-escenarios-atributos-calidad.md) conservan procedimientos y métricas pendientes de revisión; no acreditan pruebas ejecutadas.

«Aprobado conceptualmente» y «cerrado documentalmente» describen estados distintos de aprobación documental; ninguno acredita implementación, despliegue o pruebas. El [diseño técnico D1–D6](Doc/03-diseño-software/diseño-interno/diseno-tecnico-fichas-publicas-redis.md) está aprobado conceptualmente y cerrado documentalmente; sus participantes C4 siguen siendo candidatos ilustrativos, no clases o contratos aprobados.

**No resolver contradicciones silenciosamente.** Informar fuentes, contenido en conflicto, criterio respaldado y efecto sobre el cambio; solicitar definición si impide continuar sin decidir algo pendiente. No inferir aprobación por fecha, presencia en Git, imagen o ejemplo.

Estado tras la sincronización de Tarea 4: README y los textos de arquitectura describen las cuatro capas de ADR-002 y pagos reales como objetivo; las seis fuentes C1–C4 existen y se han revisado documentalmente. Los PNG históricos siguen pendientes de actualización/cotejo; no prueban tecnologías adoptadas ni aprobación financiera. Los cierres históricos de Diseño Interno y C4 no aprueban clases, firmas, contratos operativos, composición concreta o la revisión financiera. Consultar el informe de auditoría del Sprint 01 (antecedente auxiliar local, fuera del repositorio) para resultados y límites, sin convertirlo en aprobación.

El inventario gráfico (antecedente auxiliar local, fuera del repositorio) y el informe histórico (antecedente auxiliar local, fuera del repositorio) son antecedentes auxiliares de disponibilidad local: no forman parte necesariamente del repositorio versionado ni son fuentes obligatorias. Consultarlos solo si están disponibles; su ausencia no altera la jerarquía documental. Sus estados históricos de Git no sustituyen la inspección actual.

## 4. Reglas funcionales inmutables sin autorización

- Preservar las reservas directas de cancha/karaoke, sin solicitud de evento ni cotización obligatoria. Cliente elige pago completo o adelanto configurado por recurso; confirmar exige pago requerido verificado por backend y aplicado una sola vez, y disponibilidad válida sin incompatibles concurrentes (DF-04; DP-02/DP-12).
- Preservar solicitudes de salón/recreo: confirmar exige conjuntamente cotización y condiciones aceptadas por el cliente dentro de UrbanPulse, pago requerido verificado y aplicado y disponibilidad válida (DF-02/DF-03). Aceptar solicitud, aceptar condiciones y confirmar son hechos distintos; WhatsApp no sustituye aceptación interna.
- Mostrar y fijar total, adelanto, opción elegida, importe, moneda y propietario receptor al iniciar (DP-03). No imponer S/ 10, porcentajes o plazos universales. Rechazo, incertidumbre, ausencia de verificación/aplicación o disponibilidad inválida impiden confirmar.
- Impedir confirmaciones incompatibles aun bajo concurrencia. Consulta o coordinación no retiene el recurso ni garantiza disponibilidad futura (RN-12/RN-13; PC-05). La garantía y su validación siguen pendientes.
- Solo propietario autorizado registra posteriormente el **saldo completo positivo** de una reserva confirmada propia (HU14/RF20). Pendiente = total acordado − pago verificado y aplicado, sea total o adelanto (DP-04). Conservar reserva, importe, método declarado, fecha de recepción, referencia cuando corresponda, autor y fecha/hora de registro, una recepción activa e historial de correcciones. Mostrar recepción separadamente para evitar doble descuento o cobro de lo recibido. Cero no genera recepción ficticia; etiqueta pendiente. Sin fraccionamiento posterior.
- Separar intención electrónica, resultado aprobado y verificado, aplicación única, confirmación, saldo pendiente, recepción declarada, conciliación/devolución y liquidación efectiva del proveedor. Aprobación aislada no confirma (RF19); registrar/corregir saldo no cambia Reserva ni resultado electrónico ni acredita liquidación.
- El MVP objetivo incluye **pagos electrónicos reales para el propietario receptor**; UrbanPulse no recauda para redistribuir manualmente. Backend verifica autenticidad, correlación, estado, importe, moneda y receptor. Webhooks/reintentos no duplican aplicaciones ni cobros de la misma intención; mecanismos PC-02/PC-05/PC-08 pendientes. El navegador no es autoridad financiera. Dobles de prueba no acreditan integración real.
- Conservar pagos aprobados sin confirmación y resultados inciertos para conciliación y devolución cuando corresponda; políticas, responsables, recuperación, contracargos y evidencia final pendientes. No forzar confirmación, borrar aprobación o repetir cobro por timeout. Devolución financiera no aprueba cancelación RF13.
- **Mercado Pago Marketplace Split 1:1 es candidato pendiente de validación** en Perú, vinculación/revocación del receptor, medios, costes, liquidación y devoluciones. Efectivo, Yape, Plin y transferencia son métodos declarados de recepción posterior; no prueban soporte electrónico del candidato. No seleccionar SDK, checkout ni afirmar fondos recibidos sin evidencia.
- Redis se limita a copias reconstruibles de fichas públicas de Establecimientos, sin almacenar reservas, disponibilidad, aceptación contractual, adelantos o saldos. RabbitMQ transporta únicamente invalidaciones técnicas de esas fichas, nunca reservas o pagos procesados.
- **RF13 continúa pendiente**: no habilitar cancelación, expiración, reapertura o cierre del ciclo por inferencia. La devolución financiera cuando corresponda conserva política y ejecución pendientes. No ampliar al administrador a gestión de usuarios (HU11/RF15), ni incorporar mensajería propia, compra de comidas/entradas/actividades o reserva de habitaciones.

## 5. Decisiones técnicas y contractuales pendientes

Mantener explícitamente abiertos **PC-01–PC-12** del catálogo RN. Este índice orienta la consulta; el detalle y los límites aprobados permanecen en la fuente:

- PC-01–PC-04: contenido/versiones y aceptación de cotización; creación y relaciones de Reserva/Solicitud/Pago; iniciador de confirmación del evento; alcance temporal, solapamientos y espacios compartidos.
- **PC-05: garantía ante concurrencia y disponibilidad durante coordinación.** La prohibición de doble confirmación está aprobada; su mecanismo no. Una consulta seguida de escritura, un callback o un diagrama secuencial no demuestra la garantía. No dar por aprobados bloqueos, retenciones o expiraciones.
- PC-06–PC-08: precisión monetaria, límites y saldo cero; resolución del pago aprobado sin disponibilidad u otras condiciones; fallos, reintentos, duplicados y asociación de resultados. La fórmula DP-04 revisada y el registro manual completo positivo están establecidos y no se reabren; precisión, bruto/neto y etiqueta de cero siguen pendientes.
- PC-09–PC-12: no aceptación, cambios y reapertura; cancelación y ciclo posterior; permisos detallados y mecanismos de autenticación/autorización; cobertura HU/RF/DA y evaluación EQ.

El procedimiento concreto de corrección con historial y unicidad activa, contratos REST, persistencia e integración del proveedor siguen pendientes de diseño. Vinculación/revocación de receptores, conciliación, devolución, contracargos, idempotencia financiera y recuperación requieren decisiones y evidencias; ADR-012 no las cierra. Presentar alternativas como propuestas identificadas; no introducir mecanismos técnicos como decisiones definitivas sin aprobación.

También siguen pendientes contratos y firmas concretos, sincronización D3/D4, revisión y repoblación de fichas, configuración de Redis, publicación y recuperación de RabbitMQ, idempotencia operativa y validaciones. Transactional Outbox está evaluado, pero no adoptado. Tampoco se adopta como requisito adicional la prohibición absoluta de toda escritura física tardía en Redis: debe impedirse seleccionar o emitir como vigente una reconstrucción invalidada, aunque una escritura tardía pueda ocurrir. No afirmar garantías sin diseño y validación.

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

- Guardar preferentemente fuera del repositorio UrbanPulse los informes de ejecución, auditoría, revisión, preparación de commit y resultados temporales de Codex. Los documentos formales del proyecto (ADR, requisitos, reglas de negocio, diseño arquitectónico y diagramas) sí pertenecen al repositorio. Nunca incluir automáticamente informes de trabajo de Codex en un commit; revisar y seleccionar siempre los archivos explícitamente.
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

## 10. Flujo Spec-Driven Development multiagente

Antes de trabajar, leer [la guía SDD compartida](SDD.md), ejecutar `./scripts/start-session.ps1` desde PowerShell en la raíz y leer el change seleccionado y el handoff local si existen. OpenSpec usa una única raíz `openspec/`; las skills generadas no sustituyen estas reglas.

Para cambios nuevos rige la spec explícitamente aprobada y vigente, contrastada con ADR y requisitos aprobados. Esta prioridad metodológica no migra ni reabre documentos cerrados ni convierte propuestas en aprobaciones. Ante contradicción con la jerarquía de la sección 3, identificar las fuentes, suspender la parte afectada y solicitar resolución humana antes de modificarla.

Explore no implementa. Propose/Update no aprueban ni encadenan Apply. Validate no reemplaza revisión humana. Apply requiere aprobación explícita del responsable sobre la revisión concreta de los artefactos; cambios posteriores de alcance, contrato o arquitectura requieren nueva revisión. Tests, Verify limpio y revisión Git preceden a la selección autorizada de archivos. Commit y push requieren autorizaciones separadas. Sync requiere autorización explícita sobre las specs destino revisadas; Archive requiere cierre humano. No ejecutar Onboard como prueba: puede crear e implementar un change real.

Al terminar cada sesión crear o completar `.ai-context/session-handoff.md` sin sobrescribirlo a ciegas. El contexto local y KennyBrain son auxiliares; no escribir en la bóveda ni publicar conversaciones o secretos. Las puertas son reglas para los agentes, no controles técnicos de acceso de la CLI.
