# UrbanPulse — Reglas de negocio

**Reconciliación Tarea 2 — 07/11/2026; pendiente de auditoría.** El alcance funcional de pagos reales sustituye la exclusividad simulada histórica conforme a [RC/DF/DP revisados](../01-analisis-de-sistema/05-restricciones.md) y [ADR-012](../01-analisis-de-sistema/adr/ADR-012-modelo-pagos-mvp.md). Las decisiones arquitectónicas financieras de ADR-012 siguen propuestas; Mercado Pago Marketplace Split 1:1 es candidato, sin capacidades verificadas ni integración de producción aprobada. Esta revisión no acredita implementación o pruebas. AGENTS.md y la arquitectura general se sincronizan en Tarea 4 con el alcance funcional vigente; la arquitectura financiera de ADR-012 sigue propuesta y los cierres históricos no la aprueban.

## Propósito y alcance

Especificar las reglas de cancha, karaoke, salón y evento privado en recreo para el MVP de Huamanga. Este catálogo es la base de [estados y transiciones](02-estados-y-transiciones.md) y [flujos de reserva](03-flujos-de-reserva.md). Su creación no acredita implementación ni aprobación de las propuestas de diseño.

Se mantienen el Monolito Modular y Clean Architecture: Dominio expresa las reglas; Aplicación coordina los casos de uso; Presentación recibe operaciones y muestra resultados; Infraestructura implementa repositorios y adaptadores. Dominio no depende de Infraestructura. No se seleccionan frameworks, motor de base de datos, protocolos adicionales ni mecanismos de concurrencia.

## Fuentes y criterio de trazabilidad

Se revisaron los ocho documentos de análisis y los tres de arquitectura antes de crear esta carpeta. No existían documentos equivalentes. Ese antecedente corresponde a la creación de la carpeta. En la revisión de incorporación de pagos ya existían sin seguimiento estos tres documentos, cinco PNG y `REVISION-ETAPA-01.diff`. Es un antecedente histórico; la situación comprobada para el cierre del 16/10/2026 se registra en la sección L del informe documental.

| Clave | Fuente documental |
|---|---|
| ACT | [Actores](../01-analisis-de-sistema/01-actores.md) |
| HU | [Historias de usuario](../01-analisis-de-sistema/02-historias-del-usuarios.md) |
| RF | [Requisitos funcionales](../01-analisis-de-sistema/03-requisitos-funcionales.md) |
| AC | [Atributos de calidad](../01-analisis-de-sistema/04-atributos-de-calidad.md) |
| RC / DF | [Restricciones y decisiones funcionales](../01-analisis-de-sistema/05-restricciones.md#3-decisiones-funcionales-aprobadas-y-alcance-del-mvp) |
| DA | [Drivers arquitectónicos](../01-analisis-de-sistema/06-driver-arquitectonicos.md) |
| ADR | [Decisiones arquitectónicas](../01-analisis-de-sistema/07-decisiones-arquitectonicas.md) |
| EQ | [Escenarios de calidad](../01-analisis-de-sistema/08-escenarios-atributos-calidad.md) |
| ARQ | [Arquitectura inicial](../02-arquitectura-software/01-arquitectura-inicial.md), [estilo](../02-arquitectura-software/02-estilo-arquitectonico.md) y [enfoque](../02-arquitectura-software/03-enfoque-arquitectonico.md) |
| D2 | Diagnóstico recuperado del chat «Documentar arquitectura de UrbanPul», ID `01a13be7-133b-7071-8e66-4121096a1522`: respuesta «DIAGNÓSTICO DE ETAPA 2 TERMINADO PARA REVISIÓN». Su instrucción de origen aprueba el alcance de recreos y la distinción de importes. Los estados y cálculos del diagnóstico eran propuestas. Esta revisión aprueba el cálculo solo por DP-04 y los dos estados informativos del saldo por DP-08. |

Los identificadores de las tablas remiten a estas fuentes. Las RN son identificadores nuevos de este catálogo, sin reemplazar HU, RF, DF, AC, DA, ADR o EQ. Los R- e I- del diagnóstico D2 eran referencias locales; no se reutilizan como requisitos aprobados. Rigen DF-01–DF-06 para las precisiones posteriores al diagnóstico.

**Niveles:** Aprobada = decisión explícita o regla documentada vigente; Derivada = consecuencia de esa base sin función nueva; Propuesta = modelado para auditoría; Pendiente = no hay decisión suficiente. Una regla aprobada no convierte automáticamente en aprobado el nombre de un estado o un contrato técnico. Los EQ son especificaciones pendientes de revisión, no pruebas ejecutadas ni umbrales aprobados.

## Glosario del dominio

| Término | Significado |
|---|---|
| Establecimiento | Negocio que publica información y ofrece recursos según su modalidad. |
| Recurso reservable | Cancha, sala de karaoke, salón, ambiente o espacio identificado del establecimiento. |
| Bloque / intervalo | Periodo seleccionable del recurso; en canchas los bloques pueden tener distinta duración. Los límites temporales exactos siguen pendientes. |
| Disponibilidad consultada | Resultado para un recurso y fecha o periodo; no crea una reserva ni garantiza disponibilidad futura. |
| Solicitud de evento | Petición de fecha, cantidad de personas y servicios, sujeta a revisión del propietario. |
| Coordinación | Aclaración de servicios y condiciones entre cliente y propietario; no equivale a aceptación registrada. |
| Cotización | Precio y condiciones del evento registrados por el propietario en UrbanPulse; contenido contractual mínimo pendiente. |
| Solicitud aceptada | El propietario acepta atender la solicitud; no significa que el cliente haya aceptado la cotización. |
| Condiciones aceptadas | El cliente acepta dentro de UrbanPulse la cotización y condiciones registradas por el propietario. |
| Reserva confirmada | Resultado de satisfacer las condiciones de la modalidad y verificar disponibilidad al confirmar. |
| Monto total | Precio total aplicable a la reserva directa o acordado para el evento y sus servicios. |
| Adelanto requerido | Importe configurado por recurso de cancha/karaoke o según condiciones aceptadas del evento. No es un pago realizado. |
| Pago verificado y aplicado | Importe total o adelanto cuya aprobación se verificó en backend y cuya aplicación única a la reserva está registrada. No equivale a liquidación del proveedor. |
| Saldo pendiente | Total acordado menos pago verificado y aplicado. La recepción manual completa positiva se representa separadamente; no es una nueva aprobación electrónica. |
| Incompatibilidad | Dos reservas que no pueden confirmarse para el mismo recurso y periodo o fecha. El detalle temporal y los recursos compartidos deben formalizarse. |

## Decisiones funcionales aprobadas

| ID | Decisión vigente | Límite |
|---|---|---|
| DF-01 | En recreos se reserva un ambiente o espacio definido por el propietario para un evento privado. | No se presume que se ocupa todo el recreo ni toda la fecha. |
| DF-02 | El propietario registra cotización y condiciones y el cliente las acepta en UrbanPulse. | Cobertura explícita y criterios de aceptación en HU/RF pendientes de formalización. HU05/HU08 y RF07/RF10/RF12 aportan contexto. |
| DF-03 | Evento confirma con condiciones aceptadas en UrbanPulse, pago requerido verificado y aplicado y disponibilidad válida aun bajo concurrencia. | Total o adelanto configurado suficiente; ninguna condición basta aislada. |
| DF-04 | Cancha/karaoke mantienen reserva directa; cliente elige total o adelanto configurado por recurso, verificado y aplicado, y disponibilidad válida al confirmar. | Sin solicitud ni cotización obligatoria; sin incompatibles concurrentes ni importes universales. |
| DF-05 | Propietario autorizado registra recepción posterior del saldo completo positivo de reserva confirmada propia. | Método, importe, fecha de recepción, referencia cuando corresponda, autor y fecha/hora de registro; una activa e historial; no cambia Reserva ni resultado electrónico. |
| DF-06 | Pago electrónico real para propietario receptor; UrbanPulse no recauda para redistribuir manualmente. | Verificación backend, idempotencia y trazabilidad de aprobados sin confirmación; proveedor y producción pendientes de validación. |

## Catálogo de reglas

La columna de respaldo funcional registra origen o contexto según se indica; el soporte arquitectónico se desarrolla después. No se crean relaciones RF → driver por analogía.

| ID | Regla | Nivel | Respaldo funcional / decisión |
|---|---|---|---|
| RN-01 | Cada reserva identifica el recurso y la fecha y, en cancha/karaoke, el bloque o intervalo correspondiente a su modalidad. | Aprobada | HU03–HU05/HU07; RF03–RF07/RF09; RC06; DF-01/DF-04. |
| RN-02 | La cancha se reserva por bloque definido por el establecimiento, sin exigir duración uniforme. | Aprobada | HU03/HU07; RF03/RF04/RF09. HU03 → RF04 es contextual. |
| RN-03 | El karaoke se reserva por sala, fecha e intervalo de tiempo. | Aprobada | HU04/HU07; RF05/RF06/RF09. HU04 → RF06 es contextual. |
| RN-04 | Cancha y karaoke confirman directamente con pago total o adelanto configurado verificado y aplicado y disponibilidad válida al confirmar. Sin solicitud ni cotización obligatoria; propietario configura adelanto por recurso y cliente conoce total, opción e importe antes de iniciar. | Aprobada; formulación anterior sustituida | DF-04; DP-02/DP-03/DP-12; HU07/HU09; RF04/RF06/RF09/RF11/RF12. |
| RN-05 | El salón utiliza solicitud con fecha, cantidad de personas y servicios, revisión y coordinación; no se confirma como reserva directa. | Aprobada | HU05/HU08/HU09; RF07/RF10–RF12; DF-02/DF-03. |
| RN-06 | En recreo la solicitud corresponde a un evento privado sobre un ambiente o espacio definido por el propietario. | Aprobada | DF-01; HU05/HU07/HU08; RF07/RF09/RF10 como contexto; D2. |
| RN-07 | La oferta publicada es particular de cada establecimiento. Informar un servicio no implica incluirlo en la cotización ni ofrecerlo en todos los recreos. | Aprobada / Derivada | D2 aprueba oferta particular; HU02/HU06; RF02/RF08. La no inclusión automática es derivada. |
| RN-08 | El propietario puede aceptar o rechazar la solicitud de evento según las condiciones del establecimiento. | Aprobada | HU08; RF10. |
| RN-09 | El propietario registra cotización y condiciones y el cliente las acepta dentro de UrbanPulse. La coordinación por WhatsApp no reemplaza esa aceptación. | Aprobada | DF-02; HU05/HU08 y RF07/RF10/RF12 solo como contexto; cobertura explícita pendiente. |
| RN-10 | Aceptar la solicitud, aceptar la cotización y confirmar la reserva son hechos distintos; ninguno de los dos primeros confirma por sí solo. | Derivada | DF-02/DF-03; HU08/HU09; RF10/RF12/RF19; D2. |
| RN-11 | Evento confirma solo con cotización y condiciones aceptadas por cliente en UrbanPulse, pago total o adelanto configurado verificado y aplicado y disponibilidad válida al confirmar. | Aprobada; formulación anterior sustituida | DF-02/DF-03; DP-02/DP-12; RF12. |
| RN-12 | Consultar disponibilidad, registrar una solicitud o aceptarla no otorga garantía de reserva ni exclusividad durante la coordinación. | Derivada | AC03; ADR-004; DF-03/DF-04; D2. No hay retenciones aprobadas. |
| RN-13 | No pueden coexistir confirmaciones incompatibles del mismo recurso y periodo o fecha, incluso bajo concurrencia. Se verifica disponibilidad al confirmar junto con las demás condiciones; el pago aprobado no elimina conflictos. | Aprobada; obligación conservada | DF-03/DF-04; DP-12; AC03/DA02/ADR-004; mecanismo pendiente PC-05. |
| RN-14 | Pago electrónico real para el propietario receptor identificado; UrbanPulse no recauda ni redistribuye manualmente fondos. Backend verifica autenticidad y contrasta operación, estado, importe, moneda, receptor y correlación mediante proveedor; el navegador no acredita pago. Reintentos y webhooks no duplican cobro solicitado ni aplicación, incluso entre canales y eventos diferentes del mismo pago. | Aprobada en alcance funcional; simulación exclusiva sustituida; mecanismo pendiente | DF-06; DP-01/DP-03/DP-12; HU09; RF11/RF18/RF19; RC07/RC10; ADR-006 y propuesta ADR-012. |
| RN-15 | Rechazo, ausencia de verificación o aplicación, condiciones insuficientes o disponibilidad inválida impiden confirmar; aprobación aislada no confirma. Un timeout no es aprobación ni rechazo de negocio. Aprobados sin confirmación conservan evidencia para conciliación y devolución cuando corresponda. | Aprobada; formulación anterior sustituida | DF-03/DF-04/DF-06; DP-12; RF12/RF18/RF19; PC-07/PC-08. |
| RN-16 | Reflejar el resultado verificado del pago en la situación de Reserva conforme a RF19, separando operación electrónica, aplicación del importe, Reserva y recepción posterior. Registrar o corregir saldo no cambia Reserva ni resultado electrónico y no equivale a confirmación del proveedor. | Aprobada; formulación anterior sustituida | DF-05; RF14/RF19/RF20; DP-08/DP-10. |
| RN-17 | Distinguir total acordado, adelanto requerido, opción elegida, importe de operación y pago verificado y aplicado. Mostrar y fijar total, adelanto, opción, importe, moneda y propietario receptor al iniciar; cambios posteriores no alteran la operación. Aprobado sin aplicar, rechazo e incierto no se descuentan; sin definir no equivale a cero. | Aprobada / Derivada; formulación financiera sustituida | DP-03/DP-04; RF09/RF11; distinción sin definir/cero derivada. Precisión y límites PC-06. |
| RN-18 | No fijar S/ 10, comisión de plataforma, porcentajes, plazos de depósito, vencimientos o políticas de devolución universales. Devolución financiera cuando corresponda requiere política y ejecución diferenciadas; no aprueba cancelación. | Aprobada; precisión de nuevo alcance | RC07; DP-02; RF19; ADR-012; PC-06/PC-10. |
| RN-19 | Cliente consulta reservas y resumen propio; propietario autorizado configura sus recursos, registra saldo de confirmadas de su establecimiento y consulta su resumen. Vinculación financiera válida del propietario receptor es condición para habilitar cobro; onboarding, revocación y permisos detallados pendientes. | Aprobada; mecanismo pendiente | HU07/HU10/HU14; RF08/RF09/RF14/RF20; DF-05/DF-06; DP-10; AC04/ADR-007; ADR-012. |
| RN-20 | WhatsApp solo redirecciona al contacto: no hay gestión de conversaciones ni confirmaciones basadas en mensajes externos. | Aprobada / Derivada | HU12/RF17; RC08; DF-02. La imposibilidad de sustituir aceptación es derivada. |
| RN-21 | Actividades, comidas, entradas, fogatas y hospedaje son información consultable cuando corresponda. No se incorporan compra de comidas/entradas, POS, mesas ordinarias ni reserva de habitaciones. | Aprobada | D2; DF-01 y RC06; HU02/RF02 como contexto. |
| RN-22 | Las reglas permanecen independientes de proveedores y persistencia concreta, dentro del Monolito Modular y las cuatro capas de Clean Architecture. | Aprobada | RC10; ADR-001/ADR-002/ADR-006/ADR-008; ARQ. |
| RN-23 | RF13 sigue pendiente: no habilitar cancelación, expiración, reapertura o cierre por inferencia. La devolución financiera cuando corresponda es distinta de cancelar; su elegibilidad, autorización y ejecución deben diseñarse sin fingir resultado completado. | RF13 pendiente; límite conservado y exclusión financiera anterior sustituida | RF13; RF19; ADR-012; PC-10. |
| RN-24 | Importe pendiente = total acordado menos pago verificado y aplicado a esa reserva, sea total o adelanto. Recepción posterior se consulta separadamente para no descontar dos veces ni volver a cobrar saldo recibido. Solo saldo completo positivo, sin fraccionamiento posterior. Cero sin recepción ficticia; etiqueta pendiente. | Aprobada; fórmula anterior sustituida | DP-04/DP-05/DP-10; HU14/RF14/RF20. |

### Incorporación justificada de RN-25

| ID | Regla | Nivel | Respaldo funcional / decisión |
|---|---|---|---|
| RN-25 | Solo propietario autorizado registra manualmente recepción del saldo completo positivo de confirmada propia: reserva, importe, método declarado, fecha de recepción, referencia cuando corresponda, autor y fecha/hora de registro. Una recepción activa, reintentos sin duplicados y correcciones con historial, autor y fecha. Estados informativos: Pendiente de registro y Registrado como recibido. No es verificación del proveedor ni modifica Reserva o resultado electrónico. Consulta autorizada; cancha/karaoke el día del servicio, eventos según condiciones aceptadas, sin presumir liquidación del proveedor. | Aprobada; formulación anterior sustituida | DF-05; DP-04–DP-11; HU14/RF20/RF14. |

RN-25 se incorporó en la revisión histórica para separar cálculo, independencia de estados y recepción con historial. Esta tarea conserva RN-01–RN-25 y actualiza su alcance financiero; no crea una nueva regla ni elimina las propuestas pendientes.

## Correspondencia con calidad y arquitectura

Cada RN queda situada en uno de estos grupos. Las cadenas AC → DA → ADR son las existentes, mientras que asociar una RN a ellas describe apoyo de diseño. Los EQ no aprueban reglas adicionales.

| RN | AC / DA / ADR / EQ relacionados y alcance |
|---|---|
| RN-01–RN-07 | Modalidades: AC05 → DA01 → ADR-001; AC06 → DA03 → ADR-003; EQ-05/EQ-06. RF03–RF07 son origen de DA01; RF02/RF08/RF09 citados en reglas no se convierten por ello en origen de DA01. |
| RN-08–RN-13 | Confirmación: AC03 → DA02 → ADR-004 → contexto de EQ-03. RF04/RF06/RF12 son origen de DA02; RF10 no tiene driver de origen explícito. DF-02 aporta el registro y aceptación pendientes de formalización. |
| RN-14–RN-16 | Pago: AC08 → DA06 → ADR-006; EQ-08 y control de confirmación EQ-03. RF18 es origen de DA06; RF11/RF19 tienen origen explícito en DA08 para persistencia; son contexto de DA06 para integración. |
| RN-17/RN-18/RN-24/RN-25 | Economía: DF-04–DF-06, DP-01–DP-12, HU09/HU14/RF11/RF14/RF18–RF20; EQ-03/EQ-08 ayudan a evaluar el efecto sobre confirmación. DA05/ADR-007 respalda autorización y DA08/ADR-008 la persistencia trazable; no aprueban nuevas condiciones comerciales. |
| RN-19 | AC04 → DA05 → ADR-007; EQ-04. RF08/RF15 son origen de DA05; RF09/RF10 siguen como contexto sin origen explícito; RF14/RF20 se incorporan explícitamente a DA05/DA08. |
| RN-20/RN-21 | Comunicación: AC08 → DA06 → ADR-006; EQ-08 para RF17. Información de recreos: HU02/RF02 y D2, sin driver de origen explícito para RF02; EQ-07 como contexto de comprensión. |
| RN-22 | AC05 → DA06 → ADR-002/ADR-006; AC06 → DA03 → ADR-001/ADR-003; EQ-05/EQ-06. ADR-008 responde a DA08 (RC04/RF04/RF06/RF07/RF12); AC03/AC05 son relaciones complementarias de DA08. |
| RN-23 | RF13 queda fuera de la cadena confirmada; no hay HU, DA, ADR o EQ que apruebe la cancelación. |

Para las consultas de RN-01–RN-04 y RN-12: AC01 → DA04 → ADR-009 → EQ-01 respalda RF03/RF05, sin métricas aprobadas. AC02/EQ-02 y AC07/EQ-07 son contexto transversal sin driver ni respuesta arquitectónica explícita. DA07 → ADR-005 procede de RC03; su asociación con AC05/AC08 es complementaria. No se atribuye DA01 → ADR-002 ni se completa artificialmente la cobertura ausente de RF02/RF09/RF10.

## Condiciones de confirmación e invariantes

**Cancha/karaoke:** recurso, selección temporal, identidad y autorización; pago total o adelanto configurado verificado y aplicado; disponibilidad válida al confirmar sin incompatibles concurrentes (RN-04/RN-13). Importes y receptor fijados al iniciar (RN-17).

**Evento:** solicitud y condiciones del recurso identificado, aceptación del cliente dentro de UrbanPulse, pago requerido verificado y aplicado y disponibilidad verificada al confirmar (RN-05/RN-06/RN-09/RN-11/RN-13). La aceptación de la solicitud por el propietario pertenece a la revisión, sin sustituir ninguna de esas condiciones. El iniciador de la confirmación sigue pendiente.

| ID | Invariante y respaldo |
|---|---|
| INV-01 | No hay dos reservas confirmadas incompatibles (RN-13, aprobada). |
| INV-02 | Evento confirmado implica las tres condiciones conjuntas de DF-03 (RN-11, aprobada). |
| INV-03 | Solicitud aceptada, cotización aceptada y reserva confirmada representan hechos diferentes (RN-10, derivada). |
| INV-04 | Pago rechazado no aporta importe aplicado; pago aprobado no elimina un conflicto (RN-15/RN-17, derivada). |
| INV-05 | Consultar disponibilidad no asigna ni retiene el recurso (RN-12, derivada). |
| INV-06 | La oferta informativa no constituye compra ni inclusión automática en el evento (RN-07/RN-21, derivada). |
| INV-07 | Los accesos respetan rol y titularidad documentados y las reglas no dependen de implementaciones externas (RN-19/RN-22, aprobada). |

La validación numérica y los límites de intervalos requieren diseño. La aplicación única del pago es obligación funcional de RF11/RF18/RF19 y DP-12; su mecanismo permanece pendiente. La fórmula de saldo queda aprobada mediante DP-04/RN-24; los contratos numéricos detallados y soluciones técnicas siguen pendientes.

## Restricciones del MVP y pendientes contractuales

Se conservan RC01/RC03/RC04, ADR-001/ADR-002 y ADR-006–ADR-008: web, REST, persistencia relacional sin motor seleccionado, cuatro capas y adaptadores hacia el núcleo. Redis solo contiene fichas públicas reconstruibles, nunca autoridad o evidencia financiera; RabbitMQ solo invalidaciones técnicas. Consumidor interno; worker independiente: **Preparado arquitectónicamente, no obligatorio inicialmente**. Extraerlo posteriormente requiere conservar fronteras de consumo e invalidación sin modificar Dominio; no añade microservicio ni módulo. Outbox no adoptado. Los textos de arquitectura inicial/README y AGENTS.md se sincronizan en Tarea 4 con las cuatro capas oficiales y el objetivo financiero; las seis fuentes C1–C4 ya están revisadas. PNG e informes históricos conservan antecedentes, sin aprobar ADR-012.

| ID | Pendiente | Límite actual |
|---|---|---|
| PC-01 | Contenido mínimo de cotización, servicios incluidos y evidencia de aceptación, versiones y cambios. | DF-02 aprobada; HU/RF y criterios de aceptación por formalizar. No se permite asumir aceptación de condiciones modificadas. |
| PC-02 | Modelo relacional, creación y asociaciones Reserva/Solicitud/operación/pago/aplicación/incidencia y recepción posterior. | Cardinalidades, identidad, evidencia mínima y propiedad modular pendientes; conservar correlación aun sin Reserva confirmada. Sin tablas adoptadas. |
| PC-03 | Quién inicia la confirmación del evento y si existe automatización. | El sistema evalúa las reglas; no se asigna ese permiso al cliente o propietario sin decisión. |
| PC-04 | Alcance temporal de eventos, solapamientos, extremos de intervalos y espacios compartidos de un recreo. | DF-01 resuelve la unidad como ambiente/espacio definido; no otorga exclusividad del recreo completo ni de todo el día. |
| PC-05 | Garantía ante concurrencia y disponibilidad durante coordinación; coordinación de aplicación única y confirmación. | RN-13 obligatoria; unidad transaccional o protocolo recuperable por diseñar y validar. Consulta seguida de escritura no basta. Retención temporal: mecanismo por diseñar y evaluar, sin adopción ni expiración aprobadas. |
| PC-06 | Representación de importes y moneda, precisión, límites, bruto/neto y saldo cero. | Fórmula DP-04 y recepción completa positiva vigentes; no restar comisiones automáticamente al pago reconocido. Sin porcentajes o plazos universales; no fraccionar saldo. |
| PC-07 | Pago aprobado sin confirmación, aplicado o aún no aplicado, y caída tras cobro antes de persistencia. | Conservar correlación, receptor, importe, motivo, intentos y resolución pendiente. Conciliación y devolución cuando corresponda; responsables, recuperación y política por definir; no forzar confirmación ni borrar aprobación. |
| PC-08 | Contratos del proveedor: inicio/consulta/webhook/devolución, identidades, reintentos e idempotencia. | Diseñar autenticidad, correlación y deduplicación persistente entre canales, aplicación única por pago, eventos fuera de orden y recuperación. Timeout conserva incertidumbre; no autoriza otro cobro automático. Capacidades del candidato no verificadas. |
| PC-09 | Cliente no acepta cotización, rechazo explícito, cambios de fecha/servicios y reapertura. | Sin aceptación no hay confirmación; no se inventan estados o transiciones adicionales. |
| PC-10 | Cancelación y ciclo posterior frente a devolución financiera. | RF13 pendiente; devolución cuando corresponda requiere política, iniciador autorizado, importe, evidencia final y tratamiento idempotente de incertidumbre; no implica cancelar ni devolución garantizada. |
| PC-11 | Permisos, autenticación/autorización y seguridad de integraciones. | Mantener rol/titularidad; diseñar vinculación, renovación/revocación del receptor, credenciales y autenticidad de notificaciones. No ampliar administrador a usuarios o conciliación por inferencia. |
| PC-12 | Cobertura HU/RF/DA, evaluación EQ y coherencia de responsabilidades técnicas. | Conservar vacíos de origen; formalizar onboarding si requiere HU/RF. Revisar coordinación Pagos/Reservas/Disponibilidad, integración candidata y evidencia de recuperación; no usar RabbitMQ financiero sin nueva decisión. |

Los PC mantienen pendientes sus mecanismos, contratos y políticas; las obligaciones funcionales sí están establecidas donde lo indica el Análisis revisado. El catálogo debe auditarse junto con [estados](02-estados-y-transiciones.md) y [flujos](03-flujos-de-reserva.md).

## Invariantes financieras reconciliadas

Los ID INV-P01–INV-P08 son distintos de INV-01–INV-07; se conservan ambos catálogos.

| ID | Invariante | Regla / política |
|---|---|---|
| INV-P01 | Ninguna reserva directa se confirma sin pago requerido verificado y aplicado y disponibilidad válida; RN-13 rige aun bajo concurrencia. | RN-04/RN-13; DF-04/DP-12. |
| INV-P02 | Aprobación del proveedor no confirma por sí sola; eventos exigen además aceptación interna. | RN-11/RN-15; DF-03/DP-12. |
| INV-P03 | Pendiente = total acordado − pago verificado y aplicado; recepción posterior separada y sin doble descuento. | RN-17/RN-24; DP-03/DP-04. |
| INV-P04 | Solo el propietario autorizado registra el saldo completo de una reserva confirmada de su establecimiento. | RN-19/RN-25; DF-05/DP-05. |
| INV-P05 | Una reserva no mantiene dos recepciones activas del mismo saldo. | RN-25; DP-06. |
| INV-P06 | Correcciones conservan historial, autor y fecha sin borrar silenciosamente el registro anterior. | RN-25; DP-09. |
| INV-P07 | Recepción/corrección del saldo no cambia Reserva ni resultado electrónico; declaración manual no confirma al proveedor. | RN-16; DF-05. |
| INV-P08 | Fondos para propietario receptor; UrbanPulse no recauda ni redistribuye manualmente. Verificación backend y aplicación única, con evidencia para conciliación si no hay confirmación. | RN-14/RN-15; DF-06/DP-01/DP-12; RF18/RF19. |

PC-06 conserva la fórmula revisada y el registro completo positivo; corrección con historial y unicidad activa sigue pendiente de diseño. INV-P08 sustituye la exclusividad simulada; los mecanismos financieros no quedan aprobados por formular invariantes.

## Sustituciones y propuestas de esta reconciliación

RN-01–RN-25, INV-01–INV-07, INV-P01–INV-P08 y PC-01–PC-12 conservan identificadores. RN-04/RN-11/RN-14–RN-19/RN-23–RN-25 e INV-P01–INV-P03/INV-P07/INV-P08 sustituyen formulaciones financieras anteriores; RN-13 conserva su obligación, cambiando solo la referencia al pago. La exclusividad simulada y el estado «Registrado como recibido en simulación» son antecedentes sustituidos, no reglas vigentes. El informe histórico (antecedente auxiliar local, fuera del repositorio) se preserva íntegro.

**Propuesta de diseño:** separar evidencia de operación, verificación, aplicación, confirmación e incidencia; coordinar mediante API públicas internas. No se aprueban clases, contratos, transacciones, retenciones o enumeraciones persistidas. Véanse [estados](02-estados-y-transiciones.md), [flujos](03-flujos-de-reserva.md) e informe de Tarea 2 (antecedente auxiliar local, fuera del repositorio).

HU09 → RF11/RF18/RF19 → RC07/RC10/AC08 → DA06 → ADR-006 y propuesta ADR-012 respalda integración: RF18 es origen explícito de DA06, RF11/RF19 son contexto allí y origen de DA08. RF04/RF06/RF12 → AC03/DA02/ADR-004 sustenta confirmación. HU10/HU14 → RF14 y HU14 → RF20 tienen DA05/DA08 para autorización/persistencia. ADR-012 no adquiere aprobación por esta relación. Las asociaciones contextuales y vacíos descritos arriba se conservan.
