# UrbanPulse — Reglas de negocio

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
| Adelanto aprobado simulado | Importe asociado a un resultado aprobado del simulador, sin movimiento financiero real. |
| Saldo pendiente | Total acordado menos adelanto simulado aprobado y aplicado; solo admite registro académico manual del saldo completo, sin cobro real. |
| Incompatibilidad | Dos reservas que no pueden confirmarse para el mismo recurso y periodo o fecha. El detalle temporal y los recursos compartidos deben formalizarse. |

## Decisiones funcionales aprobadas

| ID | Decisión vigente | Límite |
|---|---|---|
| DF-01 | En recreos se reserva un ambiente o espacio definido por el propietario para un evento privado. | No se presume que se ocupa todo el recreo ni toda la fecha. |
| DF-02 | El propietario registra cotización y condiciones y el cliente las acepta en UrbanPulse. | Cobertura explícita y criterios de aceptación en HU/RF pendientes de formalización. HU05/HU08 y RF07/RF10/RF12 aportan contexto. |
| DF-03 | El evento se confirma solo con condiciones aceptadas, adelanto simulado aprobado y disponibilidad verificada. | Ninguna condición basta por separado. |
| DF-04 | Canchas y karaoke requieren adelanto simulado obligatorio configurado por recurso y disponibilidad válida al confirmar. | Reserva directa sin solicitud de evento ni cotización obligatoria; importes conocidos previamente. |
| DF-05 | Propietario autorizado registra recepción simulada del saldo completo de reserva confirmada. | Reserva, importe, método, autor, fecha/hora; consulta autorizada; sin cambiar Reserva o adelanto. |
| DF-06 | Simulación académica completa. | Ningún movimiento financiero ni comprobante bancario o evidencia de fondos reales. |

## Catálogo de reglas

La columna de respaldo funcional registra origen o contexto según se indica; el soporte arquitectónico se desarrolla después. No se crean relaciones RF → driver por analogía.

| ID | Regla | Nivel | Respaldo funcional / decisión |
|---|---|---|---|
| RN-01 | Cada reserva identifica el recurso y la fecha y, en cancha/karaoke, el bloque o intervalo correspondiente a su modalidad. | Aprobada | HU03–HU05/HU07; RF03–RF07/RF09; RC06; DF-01/DF-04. |
| RN-02 | La cancha se reserva por bloque definido por el establecimiento, sin exigir duración uniforme. | Aprobada | HU03/HU07; RF03/RF04/RF09. HU03 → RF04 es contextual. |
| RN-03 | El karaoke se reserva por sala, fecha e intervalo de tiempo. | Aprobada | HU04/HU07; RF05/RF06/RF09. HU04 → RF06 es contextual. |
| RN-04 | Cancha y karaoke confirman directamente solo con adelanto simulado aprobado y disponibilidad válida al confirmar, sin solicitud de evento ni cotización obligatoria. El propietario configura el adelanto por recurso y el cliente conoce total y adelanto antes de iniciar. | Aprobada | DF-04; DP-02/DP-12; HU07/HU09; RF04/RF06/RF09/RF11/RF12. |
| RN-05 | El salón utiliza solicitud con fecha, cantidad de personas y servicios, revisión y coordinación; no se confirma como reserva directa. | Aprobada | HU05/HU08/HU09; RF07/RF10–RF12; DF-02/DF-03. |
| RN-06 | En recreo la solicitud corresponde a un evento privado sobre un ambiente o espacio definido por el propietario. | Aprobada | DF-01; HU05/HU07/HU08; RF07/RF09/RF10 como contexto; D2. |
| RN-07 | La oferta publicada es particular de cada establecimiento. Informar un servicio no implica incluirlo en la cotización ni ofrecerlo en todos los recreos. | Aprobada / Derivada | D2 aprueba oferta particular; HU02/HU06; RF02/RF08. La no inclusión automática es derivada. |
| RN-08 | El propietario puede aceptar o rechazar la solicitud de evento según las condiciones del establecimiento. | Aprobada | HU08; RF10. |
| RN-09 | El propietario registra cotización y condiciones y el cliente las acepta dentro de UrbanPulse. La coordinación por WhatsApp no reemplaza esa aceptación. | Aprobada | DF-02; HU05/HU08 y RF07/RF10/RF12 solo como contexto; cobertura explícita pendiente. |
| RN-10 | Aceptar la solicitud, aceptar la cotización y confirmar la reserva son hechos distintos; ninguno de los dos primeros confirma por sí solo. | Derivada | DF-02/DF-03; HU08/HU09; RF10/RF12/RF19; D2. |
| RN-11 | Para confirmar un evento deben concurrir condiciones aceptadas por el cliente dentro de UrbanPulse, adelanto simulado aprobado y disponibilidad válida al confirmar. | Aprobada | DF-02/DF-03; DP-02/DP-12; RF12. |
| RN-12 | Consultar disponibilidad, registrar una solicitud o aceptarla no otorga garantía de reserva ni exclusividad durante la coordinación. | Derivada | AC03; ADR-004; DF-03/DF-04; D2. No hay retenciones aprobadas. |
| RN-13 | No pueden coexistir confirmaciones incompatibles del mismo recurso y periodo o fecha, incluso bajo concurrencia. Se verifica disponibilidad al confirmar junto con las demás condiciones; el adelanto aprobado no elimina conflictos. | Aprobada | DF-03/DF-04; DP-12; AC03/DA02/ADR-004; mecanismo pendiente PC-05. |
| RN-14 | Todos los pagos y registros del MVP son exclusivamente simulados. El simulador produce aprobación/rechazo del adelanto detrás de una abstracción; efectivo, Yape, Plin y transferencia son categorías informativas sin integraciones reales. No hay cobros, transferencias, operaciones bancarias ni comprobantes o evidencia de fondos reales. | Aprobada | DF-06; DP-01/DP-07; HU09/HU14; RF11/RF18/RF20; RC07/ADR-006. |
| RN-15 | Adelanto rechazado o disponibilidad no válida impiden confirmar en todas las modalidades; aprobación aislada no garantiza confirmación. | Aprobada | DF-03/DF-04; DP-12; RF12/RF18/RF19. |
| RN-16 | El resultado del adelanto se refleja en la situación de Reserva sin confundir ambas máquinas. Registrar recepción simulada del saldo no modifica Reserva ni el resultado del adelanto. | Aprobada | DF-05; RF19/RF20; DP-08; nombres intermedios de Reserva propuestos. |
| RN-17 | Se distinguen total acordado, adelanto requerido, adelanto aprobado y aplicado y saldo simulado. Total y adelanto quedan fijados al iniciar la operación de adelanto; cambios posteriores del propietario no alteran esa operación. Rechazo no se cuenta como importe aprobado; sin definir no equivale a cero. | Aprobada / Derivada | DP-03/DP-04; DF-04; RF09/RF11; distinción sin definir/cero derivada. |
| RN-18 | No se fija S/ 10 como tarifa general ni porcentajes, plazos, vencimientos o devoluciones sin acuerdo. | Aprobada | Instrucción de origen de D2; condiciones contractuales pendientes. |
| RN-19 | Cliente consulta sus reservas y resumen simulado propio; propietario autorizado configura sus recursos y registra saldo de reservas confirmadas de su establecimiento y consulta su resumen. | Aprobada | HU07/HU10/HU14; RF09/RF14/RF20; DF-05; DP-10; AC04/ADR-007. |
| RN-20 | WhatsApp solo redirecciona al contacto: no hay gestión de conversaciones ni confirmaciones basadas en mensajes externos. | Aprobada / Derivada | HU12/RF17; RC08; DF-02. La imposibilidad de sustituir aceptación es derivada. |
| RN-21 | Actividades, comidas, entradas, fogatas y hospedaje son información consultable cuando corresponda. No se incorporan compra de comidas/entradas, POS, mesas ordinarias ni reserva de habitaciones. | Aprobada | D2; DF-01 y RC06; HU02/RF02 como contexto. |
| RN-22 | Las reglas permanecen independientes de proveedores y persistencia concreta, dentro del Monolito Modular y las cuatro capas de Clean Architecture. | Aprobada | RC10; ADR-001/ADR-002/ADR-006/ADR-008; ARQ. |
| RN-23 | RF13 no habilita cancelación confirmada; tampoco se presuponen devolución, expiración, reapertura o finalización. | Pendiente | RF13 sin HU de origen; D2. Es una restricción de especificación, no una nueva operación. |
| RN-24 | El saldo simulado es el precio total acordado menos el adelanto simulado aprobado y aplicado a esa reserva. No se admiten pagos parciales del saldo. Saldo cero: representación pendiente sin recepción inexistente. | Aprobada | DP-04/DP-05; HU14/RF20; sustituye la fórmula antes propuesta. |

### Incorporación justificada de RN-25

| ID | Regla | Nivel | Respaldo funcional / decisión |
|---|---|---|---|
| RN-25 | Solo el propietario autorizado registra manualmente el saldo simulado completo de una reserva confirmada propia: reserva asociada, importe completo, método, autor, fecha y hora. Una sola recepción activa por reserva, además de historial de correcciones con autor y fecha; nunca sustitución silenciosa. Estados mínimos: Pendiente de registro y Registrado como recibido en simulación. Cliente y propietario autorizados consultan total, adelanto aplicado, saldo y estado. En cancha/karaoke se representa la liquidación el día del servicio; en eventos según condiciones aceptadas. | Aprobada | DF-05/DF-06; DP-04–DP-11; HU14/RF20/RF14. |

RN-25 se agrega porque RN-24 expresa el cálculo y RN-16 la independencia de estados: el contrato de recepción manual, unicidad activa y corrección histórica requiere una regla propia. Se conservan RN-01–RN-24; las antiguas propuestas ajenas a estas decisiones siguen pendientes.

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

**Cancha/karaoke:** recurso y selección temporal definidos conforme a la modalidad, operación autorizada y disponibilidad verificada al confirmar (RN-01–RN-04/RN-13/RN-19). Se exige además adelanto simulado aprobado (DF-04/DP-02), con importes fijados al iniciar su simulación (RN-17).

**Evento:** solicitud y condiciones del recurso identificado, aceptación del cliente dentro de UrbanPulse, adelanto simulado aprobado y disponibilidad verificada al confirmar (RN-05/RN-06/RN-09/RN-11/RN-13). La aceptación de la solicitud por el propietario pertenece a la revisión, sin sustituir ninguna de esas condiciones. El iniciador de la confirmación sigue pendiente.

| ID | Invariante y respaldo |
|---|---|
| INV-01 | No hay dos reservas confirmadas incompatibles (RN-13, aprobada). |
| INV-02 | Evento confirmado implica las tres condiciones conjuntas de DF-03 (RN-11, aprobada). |
| INV-03 | Solicitud aceptada, cotización aceptada y reserva confirmada representan hechos diferentes (RN-10, derivada). |
| INV-04 | Pago rechazado no aporta adelanto aprobado; pago aprobado no elimina un conflicto (RN-15/RN-17, derivada). |
| INV-05 | Consultar disponibilidad no asigna ni retiene el recurso (RN-12, derivada). |
| INV-06 | La oferta informativa no constituye compra ni inclusión automática en el evento (RN-07/RN-21, derivada). |
| INV-07 | Los accesos respetan rol y titularidad documentados y las reglas no dependen de implementaciones externas (RN-19/RN-22, aprobada). |

La validación numérica de total/adelanto, los límites de intervalos y la prevención de aplicar un resultado repetido son invariantes candidatas pendientes. La fórmula de saldo queda aprobada mediante DP-04/RN-24; los contratos numéricos detallados y soluciones técnicas siguen pendientes.

## Restricciones del MVP y pendientes contractuales

Se conservan aplicación web, API REST y persistencia relacional según RC01/RC03/RC04, sin elegir framework ni motor. El simulador no mueve dinero real. WhatsApp solo redirecciona. RF13, devoluciones y expiraciones no integran los flujos confirmados. No hay código de aplicación ni diseño interno de módulos en esta parte. ADR-002 establece las cuatro capas oficiales. En la auditoría del 16/10/2026, el texto de arquitectura inicial aún describe tres capas; se registra como inconsistencia externa a esta etapa, sin modificar Etapas 1 y 2. Las observaciones gráficas previas de ADR no equivalen a una comprobación visual actual; véanse el inventario y la sección L del informe.

| ID | Pendiente | Límite actual |
|---|---|---|
| PC-01 | Contenido mínimo de cotización, servicios incluidos y evidencia de aceptación, versiones y cambios. | DF-02 aprobada; HU/RF y criterios de aceptación por formalizar. No se permite asumir aceptación de condiciones modificadas. |
| PC-02 | Momento de creación de Reserva, relación con Solicitud y Pago, cardinalidades y persistencia de estados intermedios. | El modelo del documento 02 es conceptual y propuesto. |
| PC-03 | Quién inicia la confirmación del evento y si existe automatización. | El sistema evalúa las reglas; no se asigna ese permiso al cliente o propietario sin decisión. |
| PC-04 | Alcance temporal de eventos, solapamientos, extremos de intervalos y espacios compartidos de un recreo. | DF-01 resuelve la unidad como ambiente/espacio definido; no otorga exclusividad del recreo completo ni de todo el día. |
| PC-05 | Garantía ante concurrencia y disponibilidad durante coordinación. | No confirmar incompatibles; mecanismo pendiente. Sin bloqueos, retenciones ni expiraciones aprobados. |
| PC-06 | Total, adelanto, moneda/precisión, límites numéricos, saldo, porcentajes y plazos. | Importes distinguidos; fórmula aprobada DP-04 y registro manual aprobado DF-05/RN-25. Pendientes precisión monetaria, límites y representación del saldo cero; sin tarifa uniforme ni pagos parciales. |
| PC-07 | Pago aprobado con disponibilidad perdida o condiciones insuficientes. | No confirmar. Resolución posterior pendiente, sin devolución, crédito o reubicación inventados. |
| PC-08 | Ausencia de respuesta, fallos, reintentos, duplicados y asociación inequívoca de resultados. | Sin resultado aprobado no se satisface el adelanto; contrato técnico y recuperación pendientes. |
| PC-09 | Cliente no acepta cotización, rechazo explícito, cambios de fecha/servicios y reapertura. | Sin aceptación no hay confirmación; no se inventan estados o transiciones adicionales. |
| PC-10 | Cancelación, devolución, expiración y cierre del ciclo. | RF13 pendiente de validación; no se habilitan por este diseño. |
| PC-11 | Matriz detallada de permisos y mecanismos de autenticación/autorización. | Mantener AC04/ADR-007; el administrador gestiona establecimientos, no usuarios ni confirmación de eventos. |
| PC-12 | Cobertura HU03/RF04 y HU04/RF06, RF sin driver explícito y evaluación EQ. | Asociaciones contextuales; no se crean identificadores de requisitos o relaciones para cerrar huecos. |

Estos pendientes se mantienen como contratos por decidir y no como funcionalidades autorizadas. El catálogo debe auditarse junto con [estados](02-estados-y-transiciones.md) y [flujos](03-flujos-de-reserva.md).

## Invariantes de pagos simulados aprobadas

Los ID INV-P01–INV-P08 son distintos de INV-01–INV-07; se conservan ambos catálogos.

| ID | Invariante | Regla / política |
|---|---|---|
| INV-P01 | Ninguna reserva de cancha o karaoke se confirma sin adelanto simulado aprobado y disponibilidad válida. | RN-04/RN-13; DF-04/DP-12. |
| INV-P02 | Una aprobación del simulador no garantiza por sí sola la confirmación. | RN-11/RN-15; DF-03/DP-12. |
| INV-P03 | Saldo = total acordado − adelanto simulado aprobado y aplicado a esa reserva. | RN-17/RN-24; DP-03/DP-04. |
| INV-P04 | Solo el propietario autorizado registra el saldo completo de una reserva confirmada de su establecimiento. | RN-19/RN-25; DF-05/DP-05. |
| INV-P05 | Una reserva no mantiene dos recepciones activas del mismo saldo. | RN-25; DP-06. |
| INV-P06 | Correcciones conservan historial, autor y fecha sin borrar silenciosamente el registro anterior. | RN-25; DP-09. |
| INV-P07 | La recepción del saldo no cambia el estado de Reserva ni el resultado del adelanto. | RN-16; DF-05. |
| INV-P08 | Todos los importes y registros de pagos del MVP son simulados. | RN-14; DF-06/DP-01/DP-07. |

PC-06 no reabre la fórmula aprobada ni el registro manual. El procedimiento concreto para corregir conservando historial y unicidad activa sigue pendiente de diseño. No se inventan estados ni nuevas operaciones financieras.
