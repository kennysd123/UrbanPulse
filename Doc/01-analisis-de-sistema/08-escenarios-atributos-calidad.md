# UrbanPulse — Escenarios de atributos de calidad

## Propósito y alcance

Este documento del Sprint 01 transforma AC01–AC08 en ocho escenarios verificables para UrbanPulse. Complementa los [atributos de calidad](04-atributos-de-calidad.md) y conserva la trazabilidad hacia los [drivers arquitectónicos](06-driver-arquitectonicos.md), las [decisiones arquitectónicas](07-decisiones-arquitectonicas.md), las [historias de usuario](02-historias-del-usuarios.md), los [requisitos funcionales](03-requisitos-funcionales.md) y las [restricciones](05-restricciones.md).

Los escenarios son una especificación **pendiente de revisión**. Las reglas funcionales y relaciones documentales existentes se distinguen de las condiciones, medidas y procedimientos de evaluación propuestos. Una ADR adoptada documentalmente no acredita implementación ni validación técnica. Este documento no aprueba métricas, crea drivers o ADR, selecciona tecnologías ni amplía las funcionalidades del MVP.

El alcance comprende una aplicación web para establecimientos de Huamanga y estas modalidades:

| Modalidad | Unidad y condiciones de reserva |
|---|---|
| Canchas | Recurso + fecha + bloque horario definido por el establecimiento. Confirmación directa con disponibilidad verificada, sin adelanto obligatorio en el MVP. |
| Karaoke | Sala + fecha + intervalo de tiempo. Confirmación directa con disponibilidad verificada, sin adelanto obligatorio en el MVP. |
| Salones | Fecha + servicios + coordinación + adelanto; se verifica la disponibilidad del salón o ambiente antes de confirmar. |
| Recreos | Eventos privados sobre un ambiente o espacio definido por el propietario, con fecha, servicios, coordinación y adelanto; se verifica su disponibilidad antes de confirmar. |

Según las [decisiones funcionales DF-01–DF-04](05-restricciones.md#3-decisiones-funcionales-aprobadas-y-alcance-del-mvp), el propietario registra cotización y condiciones del evento y el cliente las acepta dentro de UrbanPulse. Para confirmar eventos se requieren las condiciones aceptadas, el adelanto simulado aprobado y la verificación de disponibilidad; ninguna condición basta por sí sola. La cobertura explícita de DF-02 en HU/RF permanece pendiente de formalización. Los recreos permiten consultar información de actividades, comidas, entradas y hospedaje, sin compra de esos servicios ni reserva de habitaciones desde UrbanPulse.

En EQ-08, el servicio de pago es un sistema externo conceptual y UrbanPulse implementa su componente de simulación detrás de una abstracción de integración durante el MVP. No existe obligación de conexión a una pasarela financiera real ni de desplegar el simulador como sistema externo; esta especificación no acredita implementación o pruebas ejecutadas.

En cada tabla, los seis elementos básicos son fuente, estímulo, artefacto, entorno, respuesta y medida. Se añaden atributo, procedimiento, trazabilidad y aprobación. Los procedimientos son **PROPUESTAS de verificación pendientes de revisión**, ejecutables cuando existan los artefactos correspondientes y se acuerden las condiciones de prueba. La evidencia debe registrar versión evaluada, datos, condiciones, resultados y desviaciones. No se afirma que las pruebas ya se hayan ejecutado.

## Tabla resumen de escenarios

| ID | Atributo | Situación evaluada | Criterio y estado de evaluación |
|---|---|---|---|
| EQ-01 | Rendimiento | Consultas concurrentes de establecimientos y disponibilidad. | Medir latencia y errores; carga y umbral pendientes. |
| EQ-02 | Disponibilidad | Operaciones críticas durante demanda elevada o interrupciones. | Medir acceso al servicio e interrupciones; objetivos y respuesta arquitectónica pendientes. |
| EQ-03 | Consistencia | Intentos de confirmar reservas incompatibles. | No existen dos reservas confirmadas incompatibles para el mismo recurso y periodo; procedimiento y volumen concurrente pendientes. |
| EQ-04 | Seguridad | Acceso o modificación fuera del rol o de la titularidad permitida. | Rechazo sin exposición de datos protegidos ni modificación no autorizada; matriz detallada pendiente. |
| EQ-05 | Mantenibilidad | Modificación de una regla de una modalidad. | Impacto justificado y conservación del comportamiento de las otras modalidades; cambio de referencia pendiente. |
| EQ-06 | Extensibilidad | Evaluación de incorporación de una modalidad futura. | Reglas existentes preservadas e impacto identificado; extensión y criterio de impacto pendientes. |
| EQ-07 | Usabilidad | Búsqueda y reserva o solicitud según modalidad. | Resultado y estado comprendidos por el cliente; métricas y protocolo pendientes. |
| EQ-08 | Interoperabilidad | Interacción y sustitución de integraciones externas. | Contratos y reglas del negocio preservados; casos de fallo y contratos detallados pendientes. |

## EQ-01 — Rendimiento

| Elemento | Especificación |
|---|---|
| Atributo de calidad | AC01 — Rendimiento. |
| Fuente del estímulo | Clientes que consultan UrbanPulse simultáneamente. |
| Estímulo | Búsquedas de establecimientos y consultas de disponibilidad de canchas y salas de karaoke realizadas de forma concurrente. |
| Artefacto afectado | Funciones de búsqueda y consulta, API REST y acceso a información de establecimientos, recursos, fechas y horarios. |
| Entorno o condición | Aplicación web en operación, con datos de referencia y consultas concurrentes. Entorno, volumen de datos, mezcla de consultas, duración y carga pendientes de validación. |
| Respuesta esperada | Entregar resultados correspondientes a los criterios solicitados y a la disponibilidad consultada, con rendimiento adecuado bajo concurrencia. La consulta no sustituye la comprobación de disponibilidad al confirmar. |
| Medida de respuesta | **Métrica cuantitativa pendiente de validación.** **PROPUESTA:** registrar latencia por operación, percentiles de latencia y proporción de consultas fallidas para cada nivel de carga acordado. No hay umbrales de aceptación aprobados. |
| Procedimiento de verificación | **PROPUESTA:** preparar establecimientos y disponibilidad conocidos; acordar entorno y perfil de carga; ejecutar búsquedas y consultas simultáneas; comprobar resultados con los datos de referencia; registrar latencia y fallos por operación y carga. Comparar con umbrales únicamente cuando sean aprobados. |
| Trazabilidad hacia AC, DA, ADR, HU, RF o RC | AC01 → DA04 → ADR-009. HU01 → RF01; HU03 → RF03; HU04 → RF05. RC01 y RC03 delimitan aplicación web y API REST. |
| Estado de aprobación | Base cualitativa y cadena documental existentes. Escenario y procedimiento pendientes de revisión; métricas, carga y entorno sin aprobación. ADR-009 no fija caché ni tecnología concreta. |

## EQ-02 — Disponibilidad

| Elemento | Especificación |
|---|---|
| Atributo de calidad | AC02 — Disponibilidad. |
| Fuente del estímulo | Usuarios concurrentes y una interrupción del servicio o de una dependencia identificada durante la evaluación. |
| Estímulo | Aumento de demanda o interrupción mientras se buscan establecimientos, se consulta información o disponibilidad y se realizan o consultan reservas. |
| Artefacto afectado | Funciones críticas de búsqueda, información, disponibilidad, reserva, solicitud, confirmación y consulta del estado de reservas. |
| Entorno o condición | Periodo de mayor demanda o interrupción controlada en un entorno de evaluación. Periodo de servicio, carga y tipos y duración de interrupción pendientes de validación. |
| Respuesta esperada | Mantener la disponibilidad de las operaciones críticas conforme al objetivo que se acuerde. Durante una interrupción, observar qué operaciones continúan y cuáles se interrumpen, sin considerar confirmada una reserva que incumpla sus condiciones. La respuesta concreta ante fallos y la recuperación quedan pendientes de definición. |
| Medida de respuesta | **Métrica cuantitativa pendiente de validación.** **PROPUESTA:** registrar por operación la proporción de comprobaciones exitosas durante una ventana acordada, la duración de las interrupciones y el tiempo hasta restablecer el servicio. Ventana, frecuencia de comprobación y objetivos pendientes; no existe porcentaje de disponibilidad aprobado. |
| Procedimiento de verificación | **PROPUESTA:** acordar operaciones críticas, ventana y condiciones; comprobarlas antes y durante la carga o interrupción controlada y después de restablecer el servicio; registrar accesibilidad, resultados y estados de reservas. Separar resultados por operación y causa; evaluar cumplimiento cuando existan objetivos y respuesta ante fallos aprobados. |
| Trazabilidad hacia AC, DA, ADR, HU, RF o RC | AC02. Sin driver ni respuesta arquitectónica explícita. Contexto funcional: HU01–HU05, HU08–HU10; RF01–RF07, RF10–RF12, RF14 y RF18–RF19. RC01 y RC07. HU03 → RF04 y HU04 → RF06 son asociaciones contextuales. |
| Estado de aprobación | Necesidad cualitativa existente. Escenario y procedimiento pendientes de revisión. Objetivos de servicio, interrupciones a cubrir, recuperación, driver y respuesta arquitectónica pendientes; no se presume tolerancia a cualquier fallo. |

## EQ-03 — Consistencia

| Elemento | Especificación |
|---|---|
| Atributo de calidad | AC03 — Consistencia. |
| Fuente del estímulo | Clientes o propietarios autorizados que intervienen en la confirmación de reservas según su modalidad. |
| Estímulo | Intentos sucesivos o concurrentes de confirmar reservas incompatibles sobre el mismo recurso y periodo o fecha. |
| Artefacto afectado | Verificación de disponibilidad, proceso de confirmación y datos persistidos de reservas y recursos. |
| Entorno o condición | Recurso inicialmente disponible o con una reserva ya confirmada. Canchas: recurso, fecha y bloque; karaoke: sala, fecha e intervalos incompatibles; eventos: salón, ambiente o espacio definido y fecha. En eventos se consideran las condiciones aceptadas por el cliente dentro de UrbanPulse y el adelanto simulado aprobado. |
| Respuesta esperada | Impedir confirmaciones incompatibles y verificar disponibilidad al confirmar. Una consulta previa favorable no garantiza disponibilidad posterior. Para eventos, no confirmar sin condiciones aceptadas por el cliente dentro de UrbanPulse, adelanto simulado aprobado y disponibilidad. |
| Medida de respuesta | **Criterio funcional confirmado:** no existen dos reservas confirmadas incompatibles para el mismo recurso y periodo. La revisión de estados persistidos no debe encontrar pares que violen esta regla. Este criterio se distingue del procedimiento y volumen de pruebas concurrentes, todavía pendientes de validación. |
| Procedimiento de verificación | **PROPUESTA:** preparar un caso disponible por modalidad; intentar confirmar reservas incompatibles de forma sucesiva y concurrente; contrastar las respuestas con los estados persistidos y detectar pares incompatibles. Añadir controles con recursos distintos o periodos compatibles y casos de eventos sin alguna condición requerida. Registrar intentos y resultados. Número de participantes, repeticiones, sincronización y datos pendientes de acuerdo. |
| Trazabilidad hacia AC, DA, ADR, HU, RF o RC | AC03 → DA02 → ADR-004. RF04, RF06 y RF12 son origen explícito de DA02. Contexto: HU03/RF03–RF04, HU04/RF05–RF06, HU05/RF07, HU07/RF09, HU08/RF10 y RF12, HU09/RF11 y RF18–RF19. RC04, RC06 y RC07. RF04 y RF06 tienen cobertura HU contextual. |
| Estado de aprobación | Regla funcional existente; escenario y procedimiento pendientes de revisión. Mecanismo de garantía concurrente, volumen de pruebas y detalles de incompatibilidad por modalidad pendientes de diseño o validación, sin debilitar la prohibición existente. ADR-004 centraliza la verificación, pero no acredita una garantía concurrente implementada. |

## EQ-04 — Seguridad

| Elemento | Especificación |
|---|---|
| Atributo de calidad | AC04 — Seguridad. |
| Fuente del estímulo | Persona sin autenticación o usuario autenticado que actúa fuera de su rol o responsabilidad sobre un recurso. |
| Estímulo | Intento de consultar datos protegidos de reservas ajenas o modificar establecimientos, recursos, solicitudes o reservas sin autorización. |
| Artefacto afectado | Control de acceso de las operaciones web y de la API REST, datos de usuarios, establecimientos y reservas. |
| Entorno o condición | Cuentas de cliente, propietario y administrador, con recursos propios y ajenos. La información pública de establecimientos se distingue de los datos protegidos. Los permisos detallados por operación quedan pendientes de validación. |
| Respuesta esperada | Rechazar accesos y modificaciones no autorizados sin exponer datos protegidos ni alterar el recurso. Permitir las operaciones propias respaldadas por HU y RF: cliente sobre sus operaciones, propietario sobre su establecimiento y solicitudes, administrador sobre gestión de establecimientos según HU11/RF15. |
| Medida de respuesta | Criterio observable derivado de AC04: cada intento no autorizado evaluado es rechazado, sin divulgación de datos protegidos ni cambios en el recurso. Los casos autorizados de control producen el resultado permitido. **PROPUESTA:** registrar resultado esperado y obtenido por rol, operación y titularidad. |
| Procedimiento de verificación | **PROPUESTA:** acordar una matriz de permisos basada en HU/RF; preparar cuentas y datos propios y ajenos; ejecutar casos autorizados y no autorizados desde la web y directamente sobre la API, incluidos intentos con identificadores ajenos; revisar respuestas y comparar datos antes y después. No evaluar solo la visibilidad de controles de interfaz. |
| Trazabilidad hacia AC, DA, ADR, HU, RF o RC | AC04 → DA05 → ADR-007. HU06 → RF08 y HU11 → RF15 son respaldo explícito del driver. Contexto: HU07 → RF09, HU08 → RF10/RF12 y HU10 → RF14. RC01 y RC03. |
| Estado de aprobación | Control por roles y responsabilidades existente. Escenario, matriz y procedimiento pendientes de revisión; mecanismos de autenticación y autorización pendientes de diseño. No se atribuye administración de usuarios al administrador ni cancelación a HU10. |

## EQ-05 — Mantenibilidad

| Elemento | Especificación |
|---|---|
| Atributo de calidad | AC05 — Mantenibilidad. |
| Fuente del estímulo | Equipo de desarrollo ante una corrección o cambio de regla autorizado. |
| Estímulo | Modificar una regla específica de una modalidad, manteniendo las reglas de las otras modalidades. |
| Artefacto afectado | Módulos y capas involucrados en la modalidad, sus contratos y pruebas; integraciones si el cambio autorizado las afecta. |
| Entorno o condición | Versión de referencia con las cuatro modalidades y comportamiento conocido. **PROPUESTA de cambio de referencia:** corregir la validación de intervalos de karaoke; el caso concreto y su resultado esperado deben acordarse antes de evaluar. |
| Respuesta esperada | Localizar el cambio en las responsabilidades pertinentes, justificar cualquier modificación compartida y conservar el comportamiento esperado de canchas, salones y recreos. Mantener la separación de las reglas de negocio respecto de integraciones y detalles tecnológicos. |
| Medida de respuesta | Criterios observables propuestos: el caso corregido cumple el resultado acordado; los casos de regresión de las otras modalidades conservan su resultado; cada módulo, contrato o regla compartida modificado tiene justificación vinculada al cambio. **PROPUESTA:** inventariar componentes y contratos afectados; no hay límite numérico de impacto aprobado. |
| Procedimiento de verificación | **PROPUESTA:** acordar el cambio y registrar casos y dependencias antes de realizarlo; revisar el diferencial y justificar su alcance; ejecutar el caso modificado y la regresión de las cuatro modalidades; comprobar separación de responsabilidades y documentar efectos sobre contratos o integraciones. |
| Trazabilidad hacia AC, DA, ADR, HU, RF o RC | AC05 → DA01 → ADR-001; AC05 → DA06 → ADR-002/ADR-006, mediante los drivers relacionados en las tablas existentes. ADR-002 es apoyo transversal a mantenibilidad por separación de capas, no una relación directa AC05 → ADR en la tabla de decisiones. Contexto: HU03–HU05 y HU07–HU09; RF03–RF07, RF09–RF12 y RF18–RF19; RC06 y RC10. |
| Estado de aprobación | Organización modular y separación documentadas. Escenario, cambio de referencia, procedimiento y criterio de impacto pendientes de revisión. Las relaciones con ADR se leen mediante los drivers; no se inventa una relación directa DA01 → ADR-002. |

## EQ-06 — Extensibilidad

| Elemento | Especificación |
|---|---|
| Atributo de calidad | AC06 — Extensibilidad. |
| Fuente del estímulo | Equipo de desarrollo ante una necesidad futura de modalidad, aún fuera del MVP. |
| Estímulo | Evaluar la incorporación de una modalidad con reglas diferentes de las cuatro actuales. |
| Artefacto afectado | Organización de reglas por modalidad, núcleo de reservas, contratos y puntos de extensión existentes. |
| Entorno o condición | Evaluación de diseño o ejercicio aislado con una extensión de referencia acordada. No se registra la modalidad futura como funcionalidad aprobada ni se incorpora al MVP. |
| Respuesta esperada | Incorporar reglas específicas mediante la separación de modalidades, preservando las reglas y resultados de las existentes y evitando modificaciones significativas del núcleo. Justificar los cambios compartidos necesarios. |
| Medida de respuesta | Criterios observables propuestos: las cuatro modalidades conservan sus resultados de referencia; las nuevas reglas se identifican separadamente; el informe enumera y justifica cambios del núcleo, contratos y modalidades existentes. La extensión de referencia y el significado aceptable de «modificación significativa» están pendientes de validación. |
| Procedimiento de verificación | **PROPUESTA:** acordar reglas de una extensión exclusivamente para evaluación; comparar el diseño antes y después y revisar dependencias; identificar cambios compartidos. Si se realiza un ejercicio aislado, verificar la extensión y ejecutar regresión de las cuatro modalidades. Emitir evidencia de impacto para revisión, sin ampliar el alcance funcional. |
| Trazabilidad hacia AC, DA, ADR, HU, RF o RC | AC06 → DA03 → ADR-003. RC06 delimita modalidades existentes. HU03–HU05, HU07–HU09 y RF03–RF07, RF09–RF12, RF18–RF19 sirven como referencia de regresión; no respaldan una modalidad nueva. |
| Estado de aprobación | Objetivo cualitativo y separación de modalidades existentes. Escenario, extensión de referencia, procedimiento y criterio de impacto pendientes de revisión. No hay HU o RF aprobado para una modalidad futura. |

## EQ-07 — Usabilidad

| Elemento | Especificación |
|---|---|
| Atributo de calidad | AC07 — Usabilidad. |
| Fuente del estímulo | Cliente que busca un establecimiento y desea reservar o solicitar un evento. |
| Estímulo | Recorrer búsqueda, información, disponibilidad, selección y reserva o solicitud, identificando el estado resultante y las condiciones de confirmación. |
| Artefacto afectado | Interfaz web, información de condiciones y presentación de estados de reservas y solicitudes. |
| Entorno o condición | Navegador web y tareas representativas de cada modalidad con datos conocidos. Perfil de participantes, dispositivos, instrucciones y contexto de evaluación pendientes de acuerdo. |
| Respuesta esperada | Proporcionar un flujo comprensible: cancha por recurso, fecha y bloque; karaoke por sala, fecha e intervalo; evento por fecha, servicios, coordinación y adelanto. El cliente distingue una solicitud de una reserva confirmada y comprende que los eventos requieren condiciones aceptadas por el cliente dentro de UrbanPulse, adelanto simulado aprobado y disponibilidad. Confirmación directa con disponibilidad verificada y sin adelanto obligatorio para canchas o karaoke. |
| Medida de respuesta | **Métrica cuantitativa pendiente de validación.** Criterio observable propuesto: alcanzar el resultado previsto para la tarea y explicar su estado y las condiciones pendientes. **PROPUESTA:** registrar tareas completadas, tiempo, errores y necesidad de ayuda por modalidad; muestra y umbrales sin aprobación. |
| Procedimiento de verificación | **PROPUESTA:** definir tareas por modalidad y resultados esperados; observar el recorrido de participantes y registrar tiempo, errores y ayuda; solicitar que expliquen el estado final. En eventos, evaluar el registro de cotización y condiciones por el propietario, la aceptación del cliente dentro de UrbanPulse, la solicitud y la confirmación con las condiciones requeridas; incluir adelanto rechazado sin confirmación. Comprobar que la información de recreos no sugiera compra de comidas, entradas o actividades ni reserva de habitaciones. |
| Trazabilidad hacia AC, DA, ADR, HU, RF o RC | AC07. Sin driver ni respuesta arquitectónica explícita. HU01–HU05, HU08–HU10; RF01–RF07, RF10–RF12, RF14 y RF18–RF19. RC01, RC06 y RC07. HU03 → RF04 y HU04 → RF06 son asociaciones contextuales pendientes de precisión. |
| Estado de aprobación | Flujo cualitativo existente. Escenario, tareas, protocolo, muestra y métricas pendientes de revisión. Driver y respuesta arquitectónica explícitos pendientes; no se asigna una ADR por inferencia. |

## EQ-08 — Interoperabilidad

| Elemento | Especificación |
|---|---|
| Atributo de calidad | AC08 — Interoperabilidad. |
| Fuente del estímulo | Cliente que utiliza una integración, servicio externo o componente de simulación de pago que devuelve un resultado, o equipo que evalúa su sustitución. |
| Estímulo | Visualizar ubicación, redirigir hacia WhatsApp o recibir aprobación/rechazo de un pago simulado; evaluar un fallo o la sustitución de una implementación detrás de su contrato. |
| Artefacto afectado | Interfaces y adaptadores de mapas, WhatsApp y pago simulado, y casos de uso que consumen sus resultados. |
| Entorno o condición | Integraciones disponibles o fallos representados en un entorno de evaluación, con contratos por concretar y datos de ubicación y contacto conocidos. Proveedor de mapas pendiente; WhatsApp solo redirección y pago exclusivamente simulado en el MVP. |
| Respuesta esperada | Mostrar la ubicación registrada mediante mapas, dirigir al contacto del propietario y procesar aprobación/rechazo simulado según las reglas existentes. Mantener las reglas de reservas desacopladas de implementaciones externas. Un fallo o rechazo no debe interpretarse como adelanto aprobado ni permitir confirmar un evento sin las demás condiciones. |
| Medida de respuesta | Criterios observables propuestos: resultados de interacción corresponden a los datos de referencia; el dominio no depende directamente de implementaciones externas; sustituir una implementación que conserva el contrato mantiene resultados del negocio sin cambios innecesarios en sus reglas. El rechazo de pago no confirma el evento y la aprobación solo permite confirmarlo si se cumplen las demás condiciones. Casos de fallo y tratamiento detallado pendientes. |
| Procedimiento de verificación | **PROPUESTA:** revisar contratos y dependencias; ejecutar casos de mapa, redirección y pago aprobado/rechazado; contrastar datos y estados. Representar fallos de las integraciones y registrar su efecto; sustituir una implementación por otra de evaluación que cumpla el mismo contrato y repetir los casos del negocio. Verificar que UrbanPulse no almacene ni gestione conversaciones de WhatsApp. |
| Trazabilidad hacia AC, DA, ADR, HU, RF o RC | AC08 → DA06 → ADR-006. HU13 → RF16; HU12 → RF17; HU09 → RF11/RF18/RF19. HU08 → RF12 como contexto de confirmación de eventos. RC07–RC10. RF16–RF18 tienen origen explícito en DA06; RF11 y RF19 se citan por contexto funcional, sin asignarles driver directo. |
| Estado de aprobación | Integraciones, límites del MVP e interfaces/adaptadores documentados. Escenario y procedimiento pendientes de revisión; contratos detallados, proveedor de mapas y respuesta concreta a fallos pendientes de diseño o decisión. No se incorporan proveedores, protocolos ni pagos reales. |

## Matriz de trazabilidad

Las cadenas siguientes se contrastaron con las tablas y aclaraciones de los documentos relacionados. Las referencias funcionales de cada escenario describen el contexto de evaluación; no crean relaciones de origen RF → driver adicionales.

| Escenario | AC | Driver | ADR | Respaldo funcional o restricciones | Alcance de la relación y pendientes |
|---|---|---|---|---|---|
| EQ-01 | AC01 | DA04 | ADR-009 | HU01/RF01; HU03/RF03; HU04/RF05; RC01/RC03. | Cadena explícita. Sin métricas ni tecnología de optimización aprobadas. |
| EQ-02 | AC02 | Pendiente | Pendiente | HU01–HU05, HU08–HU10; RF01–RF07, RF10–RF12, RF14, RF18–RF19. | Driver y respuesta arquitectónica explícitos ausentes; no se asignan por analogía. |
| EQ-03 | AC03 | DA02 | ADR-004 | RF04/RF06/RF12; HU03/HU04/HU05/HU07/HU08/HU09; RC04/RC06/RC07. | Cadena explícita. HU03/RF04 y HU04/RF06 contextuales; garantía concurrente pendiente. |
| EQ-04 | AC04 | DA05 | ADR-007 | HU06/RF08; HU11/RF15; HU07/RF09, HU08/RF10/RF12 y HU10/RF14 como contexto. | Cadena explícita; permisos detallados y mecanismos pendientes. |
| EQ-05 | AC05 | DA01 / DA06 | ADR-001 / ADR-002 / ADR-006 | HU03–HU05, HU07–HU09; RF03–RF07, RF09–RF12, RF18–RF19; RC06/RC10. | AC05/DA01/ADR-001 y AC05/DA06/ADR-002–ADR-006 mediante drivers. ADR-002 aporta separación transversal; no existe vínculo directo DA01/ADR-002 documentado. |
| EQ-06 | AC06 | DA03 | ADR-003 | RC06; HU y RF de las cuatro modalidades como regresión. | Cadena explícita. Modalidad futura solo como evaluación; cambio e impacto pendientes. |
| EQ-07 | AC07 | Pendiente | Pendiente | HU01–HU05, HU08–HU10; RF01–RF07, RF10–RF12, RF14, RF18–RF19; RC01/RC06/RC07. | Driver y respuesta arquitectónica explícitos ausentes; tareas y métricas pendientes. |
| EQ-08 | AC08 | DA06 | ADR-006 | HU13/RF16; HU12/RF17; HU09/RF11/RF18/RF19; RC07–RC10. | Cadena explícita. RF11/RF19 son contexto funcional, sin driver de origen explícito. |

No se encontraron discrepancias entre las cadenas solicitadas y la base documental, interpretando las relaciones de EQ-05 mediante los drivers y el apoyo transversal señalado. Se conservan los pendientes de cobertura existentes: RF04 y RF06 tienen asociación contextual con HU03 y HU04; RF02, RF09, RF10, RF11, RF14 y RF19 no tienen relación de origen explícita RF → driver. RF13 permanece pendiente de validación funcional y fuera de los escenarios confirmados; no se usa HU10 para respaldar cancelación.

## Métricas y decisiones pendientes

| Escenario o tema | Pendiente de validar, diseñar o decidir | Consecuencia para la evaluación |
|---|---|---|
| EQ-01 — Rendimiento | Entorno, datos, carga concurrente, mezcla y duración de consultas; medidas y tiempos aceptables. | **Métrica cuantitativa pendiente de validación.** Se pueden registrar resultados, pero no declarar cumplimiento de un umbral sin aprobarlo. |
| EQ-02 — Disponibilidad | Operaciones prioritarias, periodos de servicio, ventana y frecuencia de medición, carga, interrupciones a cubrir y objetivos; respuesta ante fallos y recuperación. | **Métrica cuantitativa pendiente de validación.** Driver y respuesta arquitectónica explícitos pendientes; no se garantiza continuidad absoluta. |
| EQ-03 — Consistencia | Mecanismo de garantía ante concurrencia, detalles de incompatibilidad por modalidad y diseño de la prueba concurrente: sincronización, volumen y repeticiones. | La prohibición de dos confirmaciones incompatibles ya existe. Las pruebas aportan evidencia en las condiciones ejecutadas; no sustituyen el diseño de la garantía. |
| EQ-04 — Seguridad | Matriz detallada de permisos, datos protegidos y casos por operación; mecanismos de autenticación y autorización. | Verificar rol y titularidad con casos autorizados y no autorizados; no ampliar responsabilidades del administrador. |
| EQ-05 — Mantenibilidad | Cambio de referencia, casos de regresión y criterio aceptable de impacto sobre módulos, contratos y reglas compartidas. | Registrar y justificar modificaciones; no imponer cantidad de archivos, esfuerzo o tiempo como umbral aprobado. |
| EQ-06 — Extensibilidad | Extensión de referencia y criterio de modificación significativa del núcleo y modalidades existentes. | Mantener la extensión fuera del MVP y revisar su impacto con evidencia. |
| EQ-07 — Usabilidad | Tareas, contexto, participantes, dispositivos, muestra, medición de éxito, tiempo, errores y ayuda. | **Métrica cuantitativa pendiente de validación.** Driver y respuesta arquitectónica explícitos pendientes. |
| EQ-08 — Interoperabilidad | Contratos y casos de fallo detallados, tratamiento de resultados externos y proveedor de mapas. | Evaluar desacoplamiento y estados sin seleccionar tecnologías ni convertir pago simulado en pago real. |
| Trazabilidad funcional | Precisión de HU03/RF04 y HU04/RF06; revisión de influencia arquitectónica de RF sin driver explícito. | Mantener asociaciones contextuales y referencias funcionales sin inventar HU, drivers o ADR. |
| DF-02 — Formalización | Cobertura explícita en HU/RF del registro de cotización y condiciones por el propietario y de su aceptación por el cliente dentro de UrbanPulse, con criterios de aceptación. | La decisión está aprobada y orienta EQ-03/EQ-07/EQ-08; las referencias actuales aportan contexto, sin ampliar silenciosamente sus enunciados. |
| Aprobación de escenarios | Revisión de los ocho escenarios, sus condiciones, procedimientos y criterios propuestos. | La creación del documento no constituye aprobación ni evidencia de implementación. |

No se adoptan valores de referencia de Marketplace ni umbrales cuantitativos nuevos. Las propuestas de medición y verificación deben revisarse antes de convertirse en compromisos de aceptación. Se mantienen las decisiones existentes y sus límites en [07-decisiones-arquitectonicas.md](07-decisiones-arquitectonicas.md).
