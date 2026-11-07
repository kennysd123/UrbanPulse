# UrbanPulse — Flujos de reserva

**Reconciliación Tarea 2 — 07/11/2026; pendiente de auditoría.** El alcance funcional de pagos reales sustituye la exclusividad simulada histórica conforme a [RC/DF/DP revisados](../01-analisis-de-sistema/05-restricciones.md) y [ADR-012](../01-analisis-de-sistema/adr/ADR-012-modelo-pagos-mvp.md). Las decisiones arquitectónicas financieras de ADR-012 siguen propuestas; Mercado Pago Marketplace Split 1:1 es candidato, sin capacidades verificadas ni integración de producción aprobada. Esta revisión no acredita implementación o pruebas. AGENTS.md y la arquitectura general se sincronizan en Tarea 4 con el alcance funcional vigente; la arquitectura financiera de ADR-012 sigue propuesta y los cierres históricos no la aprueban.

## Propósito y lectura

Recorridos conceptuales propuestos basados en [reglas RN/PC](01-reglas-de-negocio.md) y [estados](02-estados-y-transiciones.md). Condiciones funcionales establecidas no aprueban el orden operativo, endpoints, creación de entidades o mecanismos concurrentes. Presentación recibe operaciones, Aplicación coordina, Dominio expresa invariantes e Infraestructura adapta proveedor y persistencia. Dependencias de código hacia el núcleo; llamadas internas por API públicas de cada módulo.

Cada flujo distingue operación, verificación, aplicación, Reserva, recepción posterior y conciliación. Mercado Pago Marketplace Split 1:1 sigue candidato; no se afirman medios, liquidación o devoluciones soportados. Receptor vinculado válido es condición de inicio; onboarding/revocación y sus contratos están pendientes.

## Coordinación, cotización, pago y confirmación

Solicitud aceptada por propietario, condiciones aceptadas por cliente en UrbanPulse y Reserva confirmada son hechos distintos. WhatsApp complementa mediante redirección; nunca sustituye aceptación. Consulta de disponibilidad o coordinación no retiene recurso. RN-13 impide confirmaciones incompatibles; PC-05 mantiene pendiente la garantía, incluida evaluación de retención temporal como mecanismo por diseñar y evaluar. No se adopta retención, bloqueo ni expiración.

## F-01 — Reserva directa de cancha

**Base:** HU03/RF03; RF04 con HU03 contextual; HU07/RF09; HU09/RF11/RF18/RF19; HU10/HU14/RF14; HU14/RF20; DF-04–DF-06; DP-01–DP-12. RN-13 conserva obligación concurrente; RN-14–RN-17/RN-24/RN-25 rigen pago y recepción.

1. El backend identifica y autoriza al cliente; la consulta y operaciones del propietario respetan su establecimiento. Se selecciona cancha, fecha y bloque configurado, sin duración uniforme obligatoria; consultar disponibilidad no garantiza reserva.
2. Se recuperan precio total y adelanto configurado por recurso de la fuente autorizada. Reserva directa sin solicitud de evento ni cotización obligatoria; el propietario no aprueba cada reserva.
3. Mostrar total, adelanto configurado, opciones total/adelanto, importe elegido, moneda y propietario receptor. El cliente elige; al iniciar quedan fijados los datos de operación y condiciones aplicables (DP-03), sin aceptar importes de una ficha Redis como autoridad ni alterar operaciones por cambios posteriores.
4. Pagos correlaciona la intención con cliente, recurso/periodo y reserva o solicitud/intento según modelo por diseñar; comprueba vinculación válida del receptor e inicia operación mediante puerto/adaptador del proveedor. UrbanPulse no recauda para redistribuir manualmente. Contrato de inicio/reintento idempotente pendiente PC-08.
5. Backend verifica el resultado mediante proveedor, tanto ante consulta como notificación auténtica: estado, operación, importe, moneda, receptor y correlación. El retorno del navegador no acredita aprobación; webhook es señal de verificación. Pendiente o timeout conservan incertidumbre sin confirmar ni ordenar automáticamente otro cobro.
6. Con aprobación verificada, coordinar aplicación única del pago por fronteras públicas de Pagos y Reservas. El mismo pago notificado por eventos o canales distintos se aplica como máximo una vez. Un candidato en memoria no es aplicación persistida; modelo y coordinación recuperable pendientes PC-02/PC-05/PC-08.
7. Validar disponibilidad al confirmar y todas las condiciones de la modalidad. La aplicación y confirmación deben coordinarse consistentemente, sin afirmar que la lista de pasos o una consulta seguida de escritura garantizan atomicidad. Adelanto configurado verificado y aplicado basta para la condición financiera; no se espera al saldo.
8. Registrar confirmación solo si se satisfacen las guardas y la garantía de compatibilidad concurrente. Ante rechazo, falta de verificación/aplicación o condiciones insuficientes no confirmar; reflejar situación según RF19. El cliente inicia el recorrido directo y el sistema evalúa las condiciones.
9. Si existe pago aprobado sin confirmación, conservar operación, receptor, importe, evidencia, motivo, intentos y vínculo disponible para conciliación y devolución cuando corresponda (PC-07/PC-10). No borrar aprobación, forzar Reserva ni fingir devolución realizada. Un fallo tras cobro requiere recuperación, sin garantía automática aquí.
10. Cliente y propietario autorizados consultan estado de Reserva, operación, pago verificado/aplicado, pendiente = total acordado − pago aplicado y recepción posterior separada (RF14/DP-10). Pago total aplicado implica cero, sin recepción ficticia ni etiqueta definitiva inventada.
11. Si la reserva está confirmada y el pendiente es positivo, solo su propietario autorizado registra recepción posterior completa (L1) el día del servicio. Conservar reserva, método declarado, importe, fecha de recepción, referencia aplicable, autor y fecha/hora de registro. Una recepción activa; repetición sin duplicar y corrección L2 con historial. No fraccionar ni volver a cobrar saldo ya recibido; no cambia Reserva o resultado electrónico ni acredita liquidación del proveedor.

**Desfase gráfico:** imagen histórica con pago simulado, sin la verificación/aplicación/conciliación revisadas. Se conserva sin editar y no define el flujo financiero vigente.

![F-01 — Secuencia de reserva](../diagramas/F-01%20%E2%80%94%20Reserva-directa-de-cancha.png)

## F-02 — Reserva directa de karaoke

**Base:** HU04/RF05; RF06 con HU04 contextual; demás vínculos de pagos/consulta/recepción de F-01; DF-04–DF-06. RN-13 conserva obligación concurrente; RN-14–RN-17/RN-24/RN-25 rigen pago y recepción.

1. El backend identifica y autoriza al cliente; la consulta y operaciones del propietario respetan su establecimiento. Se selecciona sala, fecha e intervalo horario; consultar disponibilidad no garantiza reserva.
2. Se recuperan precio total y adelanto configurado por recurso de la fuente autorizada. Reserva directa sin solicitud de evento ni cotización obligatoria; el propietario no aprueba cada reserva.
3. Mostrar total, adelanto configurado, opciones total/adelanto, importe elegido, moneda y propietario receptor. El cliente elige; al iniciar quedan fijados los datos de operación y condiciones aplicables (DP-03), sin aceptar importes de una ficha Redis como autoridad ni alterar operaciones por cambios posteriores.
4. Pagos correlaciona la intención con cliente, recurso/periodo y reserva o solicitud/intento según modelo por diseñar; comprueba vinculación válida del receptor e inicia operación mediante puerto/adaptador del proveedor. UrbanPulse no recauda para redistribuir manualmente. Contrato de inicio/reintento idempotente pendiente PC-08.
5. Backend verifica el resultado mediante proveedor, tanto ante consulta como notificación auténtica: estado, operación, importe, moneda, receptor y correlación. El retorno del navegador no acredita aprobación; webhook es señal de verificación. Pendiente o timeout conservan incertidumbre sin confirmar ni ordenar automáticamente otro cobro.
6. Con aprobación verificada, coordinar aplicación única del pago por fronteras públicas de Pagos y Reservas. El mismo pago notificado por eventos o canales distintos se aplica como máximo una vez. Un candidato en memoria no es aplicación persistida; modelo y coordinación recuperable pendientes PC-02/PC-05/PC-08.
7. Validar disponibilidad al confirmar y todas las condiciones de la modalidad. La aplicación y confirmación deben coordinarse consistentemente, sin afirmar que la lista de pasos o una consulta seguida de escritura garantizan atomicidad. Adelanto configurado verificado y aplicado basta para la condición financiera; no se espera al saldo.
8. Registrar confirmación solo si se satisfacen las guardas y la garantía de compatibilidad concurrente. Ante rechazo, falta de verificación/aplicación o condiciones insuficientes no confirmar; reflejar situación según RF19. El cliente inicia el recorrido directo y el sistema evalúa las condiciones.
9. Si existe pago aprobado sin confirmación, conservar operación, receptor, importe, evidencia, motivo, intentos y vínculo disponible para conciliación y devolución cuando corresponda (PC-07/PC-10). No borrar aprobación, forzar Reserva ni fingir devolución realizada. Un fallo tras cobro requiere recuperación, sin garantía automática aquí.
10. Cliente y propietario autorizados consultan estado de Reserva, operación, pago verificado/aplicado, pendiente = total acordado − pago aplicado y recepción posterior separada (RF14/DP-10). Pago total aplicado implica cero, sin recepción ficticia ni etiqueta definitiva inventada.
11. Si la reserva está confirmada y el pendiente es positivo, solo su propietario autorizado registra recepción posterior completa (L1) el día del servicio. Conservar reserva, método declarado, importe, fecha de recepción, referencia aplicable, autor y fecha/hora de registro. Una recepción activa; repetición sin duplicar y corrección L2 con historial. No fraccionar ni volver a cobrar saldo ya recibido; no cambia Reserva o resultado electrónico ni acredita liquidación del proveedor.

**Desfase gráfico:** imagen histórica con pago simulado, sin la verificación/aplicación/conciliación revisadas. Se conserva sin editar y no define el flujo financiero vigente.

![F-02 — Secuencia de reserva](../diagramas/F-02%20%E2%80%94%20Reserva-directa-de-karaoke.png)

## F-03 — Solicitud y confirmación de salón

**Base:** HU05/HU08; RF07/RF10/RF12; HU09/RF11/RF18/RF19; HU10/HU14/RF14; HU14/RF20; DF-02/DF-03/DF-05/DF-06. RN-13 conserva obligación concurrente; RN-14–RN-17/RN-24/RN-25 rigen pago y recepción.

1. El backend identifica y autoriza al cliente; la consulta y operaciones del propietario respetan su establecimiento. Se selecciona salón o ambiente identificado, fecha, personas y servicios; consultar disponibilidad no garantiza reserva.
2. El cliente registra solicitud; propietario autorizado revisa, coordina y acepta o rechaza. Rechazar solicitud no cancela una Reserva. Si continúa, el propietario registra cotización y condiciones en UrbanPulse y el cliente las acepta allí. La aceptación del propietario no sustituye la del cliente; versiones/cambios pendientes PC-01.
3. Mostrar total, adelanto configurado, opciones total/adelanto, importe elegido, moneda y propietario receptor. El cliente elige; al iniciar quedan fijados los datos de operación y condiciones aplicables (DP-03), sin aceptar importes de una ficha Redis como autoridad ni alterar operaciones por cambios posteriores.
4. Pagos correlaciona la intención con cliente, recurso/periodo y reserva o solicitud/intento según modelo por diseñar; comprueba vinculación válida del receptor e inicia operación mediante puerto/adaptador del proveedor. UrbanPulse no recauda para redistribuir manualmente. Contrato de inicio/reintento idempotente pendiente PC-08.
5. Backend verifica el resultado mediante proveedor, tanto ante consulta como notificación auténtica: estado, operación, importe, moneda, receptor y correlación. El retorno del navegador no acredita aprobación; webhook es señal de verificación. Pendiente o timeout conservan incertidumbre sin confirmar ni ordenar automáticamente otro cobro.
6. Con aprobación verificada, coordinar aplicación única del pago por fronteras públicas de Pagos y Reservas. El mismo pago notificado por eventos o canales distintos se aplica como máximo una vez. Un candidato en memoria no es aplicación persistida; modelo y coordinación recuperable pendientes PC-02/PC-05/PC-08.
7. Validar disponibilidad al confirmar y todas las condiciones de la modalidad, incluida evidencia de cotización y aceptación interna vigente. La aplicación y confirmación deben coordinarse consistentemente, sin afirmar que la lista de pasos o una consulta seguida de escritura garantizan atomicidad. Adelanto configurado verificado y aplicado basta para la condición financiera; no se espera al saldo.
8. Registrar confirmación solo si se satisfacen las guardas y la garantía de compatibilidad concurrente. Ante rechazo, falta de verificación/aplicación o condiciones insuficientes no confirmar; reflejar situación según RF19. Iniciador/automatización de confirmación de evento pendiente PC-03.
9. Si existe pago aprobado sin confirmación, conservar operación, receptor, importe, evidencia, motivo, intentos y vínculo disponible para conciliación y devolución cuando corresponda (PC-07/PC-10). No borrar aprobación, forzar Reserva ni fingir devolución realizada. Un fallo tras cobro requiere recuperación, sin garantía automática aquí.
10. Cliente y propietario autorizados consultan estado de Reserva, operación, pago verificado/aplicado, pendiente = total acordado − pago aplicado y recepción posterior separada (RF14/DP-10). Pago total aplicado implica cero, sin recepción ficticia ni etiqueta definitiva inventada.
11. Si la reserva está confirmada y el pendiente es positivo, solo su propietario autorizado registra recepción posterior completa (L1) según condiciones aceptadas. Conservar reserva, método declarado, importe, fecha de recepción, referencia aplicable, autor y fecha/hora de registro. Una recepción activa; repetición sin duplicar y corrección L2 con historial. No fraccionar ni volver a cobrar saldo ya recibido; no cambia Reserva o resultado electrónico ni acredita liquidación del proveedor.

**Desfase gráfico:** imagen histórica con pago simulado, sin la verificación/aplicación/conciliación revisadas. Se conserva sin editar y no define el flujo financiero vigente.

![F-03 — Secuencia de reserva](../diagramas/F-03%20%E2%80%94%20Solicitud-y-confirmaci%C3%B3n-de-sal%C3%B3n.png)

## F-04 — Solicitud y confirmación de evento privado en recreo

**Base:** Vínculos de F-03 más DF-01, HU07/RF09 como contexto de espacio y HU02/RF02 como información; sin driver de origen añadido. RN-13 conserva obligación concurrente; RN-14–RN-17/RN-24/RN-25 rigen pago y recepción.

1. El backend identifica y autoriza al cliente; la consulta y operaciones del propietario respetan su establecimiento. Se selecciona ambiente o espacio definido por propietario para evento privado, fecha, personas y servicios; consultar disponibilidad no garantiza reserva.
2. El cliente registra solicitud; propietario autorizado revisa, coordina y acepta o rechaza. Rechazar solicitud no cancela una Reserva. Si continúa, el propietario registra cotización y condiciones en UrbanPulse y el cliente las acepta allí. La aceptación del propietario no sustituye la del cliente; versiones/cambios pendientes PC-01.
3. Mostrar total, adelanto configurado, opciones total/adelanto, importe elegido, moneda y propietario receptor. El cliente elige; al iniciar quedan fijados los datos de operación y condiciones aplicables (DP-03), sin aceptar importes de una ficha Redis como autoridad ni alterar operaciones por cambios posteriores.
4. Pagos correlaciona la intención con cliente, recurso/periodo y reserva o solicitud/intento según modelo por diseñar; comprueba vinculación válida del receptor e inicia operación mediante puerto/adaptador del proveedor. UrbanPulse no recauda para redistribuir manualmente. Contrato de inicio/reintento idempotente pendiente PC-08.
5. Backend verifica el resultado mediante proveedor, tanto ante consulta como notificación auténtica: estado, operación, importe, moneda, receptor y correlación. El retorno del navegador no acredita aprobación; webhook es señal de verificación. Pendiente o timeout conservan incertidumbre sin confirmar ni ordenar automáticamente otro cobro.
6. Con aprobación verificada, coordinar aplicación única del pago por fronteras públicas de Pagos y Reservas. El mismo pago notificado por eventos o canales distintos se aplica como máximo una vez. Un candidato en memoria no es aplicación persistida; modelo y coordinación recuperable pendientes PC-02/PC-05/PC-08.
7. Validar disponibilidad al confirmar y todas las condiciones de la modalidad, incluida evidencia de cotización y aceptación interna vigente. La aplicación y confirmación deben coordinarse consistentemente, sin afirmar que la lista de pasos o una consulta seguida de escritura garantizan atomicidad. Adelanto configurado verificado y aplicado basta para la condición financiera; no se espera al saldo.
8. Registrar confirmación solo si se satisfacen las guardas y la garantía de compatibilidad concurrente. Ante rechazo, falta de verificación/aplicación o condiciones insuficientes no confirmar; reflejar situación según RF19. Iniciador/automatización de confirmación de evento pendiente PC-03.
9. Si existe pago aprobado sin confirmación, conservar operación, receptor, importe, evidencia, motivo, intentos y vínculo disponible para conciliación y devolución cuando corresponda (PC-07/PC-10). No borrar aprobación, forzar Reserva ni fingir devolución realizada. Un fallo tras cobro requiere recuperación, sin garantía automática aquí.
10. Cliente y propietario autorizados consultan estado de Reserva, operación, pago verificado/aplicado, pendiente = total acordado − pago aplicado y recepción posterior separada (RF14/DP-10). Pago total aplicado implica cero, sin recepción ficticia ni etiqueta definitiva inventada.
11. Si la reserva está confirmada y el pendiente es positivo, solo su propietario autorizado registra recepción posterior completa (L1) según condiciones aceptadas. Conservar reserva, método declarado, importe, fecha de recepción, referencia aplicable, autor y fecha/hora de registro. Una recepción activa; repetición sin duplicar y corrección L2 con historial. No fraccionar ni volver a cobrar saldo ya recibido; no cambia Reserva o resultado electrónico ni acredita liquidación del proveedor.

El espacio no presume exclusividad de todo el recreo o del día; servicios publicados no se incluyen automáticamente en cotización ni habilitan compras de actividades, comidas, entradas o habitaciones. Solapamientos y recursos compartidos siguen PC-04.

**Desfase gráfico:** imagen histórica con pago simulado, sin la verificación/aplicación/conciliación revisadas. Se conserva sin editar y no define el flujo financiero vigente.

![F-04 — Secuencia de reserva](../diagramas/F-04%20%E2%80%94%20Solicitud-y-confirmaci%C3%B3n-de-evento-privado-en-recreo.png)

## Alternativas, errores y límites de respuesta

| ID conservado | Situación | Efecto mínimo / pendiente |
|---|---|---|
| A-01 | Cambia disponibilidad consultada | Verificar al confirmar; sin disponibilidad no confirmar. No retención implícita. |
| A-02 | Propietario rechaza solicitud | S4, sin Reserva confirmada ni cancelación inferida. |
| A-03 | Cliente no acepta condiciones | No confirmar evento; PC-01/PC-09 para rechazo, cambios y reapertura. |
| A-04 | Rechazo verificado del proveedor | P3; no aplicar importe ni confirmar; RF19 refleja resultado. |
| A-05 | Aprobado sin disponibilidad/aceptación o falla confirmación | R2/R6, incidencia financiera; preservar aprobación y aplicación real o ausencia; PC-07. |
| A-06 | Fallo, timeout o estado pendiente | P4; incertidumbre no es rechazo/aprobación. Reconsulta y recuperación PC-08. |
| A-07 | Acceso ajeno a rol/titularidad o receptor inválido | Rechazar acceso/inicio no autorizado; sin exponer datos protegidos. PC-11. |
| A-08 | Importes, moneda, receptor o correlación inconsistentes | No acreditar condición financiera ni confirmar; preservar evidencia para investigación sin atribuir otro pago. PC-06/PC-08. |
| A-09 | Intentos incompatibles concurrentes | RN-13 obligatoria; garantía PC-05 por diseñar/probar; nunca justificar doble confirmación por pago aprobado. |
| A-10 | Reintento/webhook/consulta duplicados o fuera de orden | Misma operación no duplica cobro solicitado, aplicación ni confirmación; deduplicar solo evento no basta. Dos pagos distintos potencialmente cobrados requieren conciliación. PC-08. |
| A-11 | Coordinación por WhatsApp | Solo redirección; registrar condiciones/aceptación dentro de UrbanPulse. |
| A-12 | Consulta de reservas y resumen | Solo acceso autorizado RF14; no otorga cancelación RF13. Distinguir recepción declarada y verificación electrónica. |

Ante caída después del cobro o persistencia parcial, conservar incertidumbre y reconstruir hechos desde evidencia autoritativa; detección, reconsulta y responsables pendientes. Notificaciones antiguas no degradan hechos verificados por orden de llegada. Solicitar devolución no acredita resultado; los contratos deben impedir devolución duplicada y documentar incertidumbre. No se establece política de cancelación.

## Matriz de trazabilidad de flujos

| Flujo | Condiciones y transiciones conceptuales | Calidad / arquitectura y límite |
|---|---|---|
| F-01 | RN-01/RN-02/RN-04/RN-13; P1–P6/AP1/AP2; R1/R2; L1/L2 si positivo | HU03/RF04 contextual; consulta RF03 → AC01/DA04/ADR-009; confirmación RF04/RF12 → AC03/DA02/ADR-004. |
| F-02 | RN-01/RN-03/RN-04/RN-13; mismos hechos de pago, R1/R2 y L1/L2 | HU04/RF06 contextual; consulta RF05 y confirmación RF06/RF12 en cadenas anteriores. |
| F-03 | RN-05/RN-09–RN-13; S1–S4; pago separado; R3–R6; L1/L2 | HU05/RF07; HU08/RF10/RF12. DF-02 sigue pendiente de formalización detallada; RF10 sin driver explícito. |
| F-04 | RN-06/RN-07/RN-09–RN-13/RN-21; hechos de F-03 sobre espacio concreto | DF-01; RF02/RF09/RF10 siguen sin driver de origen explícito. |
| Todos: pagos | HU09 → RF11/RF18/RF19; DF-03/DF-04/DF-06; DP-01–DP-04/DP-12 | AC08/RC07/RC10 → DA06 → ADR-006 y propuesta ADR-012; RF18 origen DA06, RF11/RF19 contexto allí y origen DA08. |
| Todos: consulta y saldo | HU10/HU14 → RF14; HU14 → RF20; RN-16/RN-19/RN-24/RN-25; DF-05; DP-04–DP-11 | AC04/DA05/ADR-007 y RC04/DA08/ADR-008; EQ-04 como evaluación propuesta. |

ADR-001/ADR-002/ADR-003 conservan modularidad, cuatro capas y modalidades; RC03/DA07/ADR-005 mantiene REST. AC05/AC08 de DA07 y AC03/AC05 de DA08 son complementarios. EQ-03/EQ-08 proponen evaluación de concurrencia, duplicados, desorden y fallos; no hay pruebas ejecutadas. AC02/AC07 siguen sin driver ni respuesta explícitos. No se atribuye DA01 → ADR-002.

## Pendientes y sustituciones

F-01–F-04 y A-01–A-12 conservan ID; se sustituyen invocación del simulador, adelanto como única opción y recepción simulada por pago real requerido, verificación, aplicación única y recepción declarada. Solicitud/aceptación y modalidades se conservan. Las secuencias son propuestas; no aprueban contratos, persistencia ni mecanismo concurrente. [PC-01–PC-12](01-reglas-de-negocio.md#restricciones-del-mvp-y-pendientes-contractuales) permanece abierto y RF13 pendiente.

Redis excluye operación/evidencia financiera y disponibilidad; RabbitMQ solo invalidaciones públicas. Consumidor interno; worker independiente: **Preparado arquitectónicamente, no obligatorio inicialmente**. Su extracción posterior conserva puertos/adaptadores sin modificar Dominio ni añadir microservicio. Mensajería para pagos, webhooks o conciliación exige nueva decisión arquitectónica; ADR-011 no la autoriza.
