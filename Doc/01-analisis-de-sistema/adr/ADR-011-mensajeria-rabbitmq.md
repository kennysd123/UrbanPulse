# ADR-011 — Mensajería asíncrona con RabbitMQ

**Proyecto:** UrbanPulse

**Estado: APROBADA CONCEPTUALMENTE — CERRADA DOCUMENTALMENTE — IMPLEMENTACIÓN Y MECANISMOS OPERATIVOS PENDIENTES**

**Fecha:** 16/10/2026

**Decisiones relacionadas:** ADR-001, ADR-002, ADR-006 y ADR-010 propuesta.

## 1. Contexto

La solicitud académica requiere documentar mensajería asíncrona dentro de la alternativa **A3 — Base relacional + Redis + RabbitMQ**. La oportunidad candidata es desacoplar la invalidación técnica de fichas públicas de las operaciones que modifican la oferta. No se crea un requisito de negocio ni se afirma que la carga actual exija un broker.

El [catálogo ADR](../07-decisiones-arquitectonicas.md) mantiene adoptadas ADR-001–ADR-009. [ADR-010 propuesta](ADR-010-cache-redis.md) justifica copias públicas reconstruibles con base relacional definitiva. Esta ADR depende de ese caso de uso; ADR-010 puede evaluarse y utilizarse sin RabbitMQ, por lo que no se establece una dependencia circular de aprobación.

No se localizó una evaluación previa de Redis/RabbitMQ en los archivos accesibles del repositorio. Se usan las conclusiones suministradas por la solicitud: consumidor dentro del backend, sin worker independiente ni balanceador en el MVP, tolerancia a duplicados y fallos, y Outbox como alternativa pendiente. Su selección para documentar no aprueba contratos ni operación.

| Responsabilidad verificada | Relación candidata con la invalidación | Evidencia y límite |
|---|---|---|
| Establecimientos: búsqueda, información y gestión autorizada | Sus casos de uso de gestión producirían intenciones cuando cambien campos públicos; sus consultas serían consumidoras de caché. | HU01/RF01, HU02/RF02, HU06/RF08 y HU11/RF15 en [HU/RF](../03-requisitos-funcionales.md) y [C3](../../04-modelo-c4/03-componentes-c3.md). No se inventan nuevas operaciones. |
| Recursos: unidades reservables y configuración | Productor candidato únicamente si modifica datos incorporados en la ficha pública. | HU07/RF09, DF-01/DF-04, DP-02/DP-03. El reparto exacto con otros módulos y la proyección pública siguen pendientes. No se transporta disponibilidad para confirmar. |
| Servicios: información de oferta por establecimiento | Productor candidato si cambia oferta pública incluida en la ficha. | HU02/RF02 y HU06/RF08; RF07 es contexto de servicios solicitados. La oferta pública no equivale a servicios aceptados en una cotización. |

Las [restricciones RC/DF/DP](../05-restricciones.md), [atributos AC](../04-atributos-de-calidad.md) y [drivers DA](../06-driver-arquitectonicos.md) conservan sus estados. AC01 → DA04 → ADR-009 es contexto de consultas; AC04 → DA05 → ADR-007 limita acceso. ADR-002/ADR-006 apoyan el desacoplamiento, sin significar que DA06 hubiera requerido RabbitMQ. RF02/RF09/RF10 siguen sin origen explícito en drivers; AC02/AC07 no adquieren driver o respuesta aprobada por esta propuesta. Los [EQ](../08-escenarios-atributos-calidad.md) no prueban implementación ni cumplimiento.

## 2. Problema arquitectónico

Determinar cómo comunicar modificaciones confirmadas para invalidar copias públicas con recuperación de fallos definida, sin alterar la confirmación de reservas, diferir evidencia obligatoria, crear módulos de negocio ni convertir el backend en microservicios. La confirmación del cambio en la base y su comunicación al broker son operaciones distintas; un mensaje no debe hacer pasar un cambio revertido por definitivo ni esconder una invalidación perdida.

## 3. Alternativas consideradas

| Alternativa | Complejidad y mantenimiento | Recuperación de fallos | Despliegue y coste |
|---|---|---|---|
| A. Invalidación síncrona | Menos piezas; operación de gestión ligada al intento de invalidar. | Persiste la ventana entre commit y acceso a Redis; tratar el error no deshace automáticamente el cambio. Recuperación por diseñar. | Sin broker ni consumidor; alternativa viable si se acepta su política de fallos. |
| B. Asíncrona en proceso sin broker | Desacopla ejecución inmediata, pero añade gestión de tareas y supervisión local. | Una tarea solo en memoria puede perderse al caer el proceso; persistencia y reintento no vienen dados. | Misma aplicación; menos operación externa, más responsabilidad de recuperación propia. |
| C. RabbitMQ con consumidor dentro del backend | Añade broker, publicación, consumo y observación; separa transporte de la política de caché. | Puede soportar redelivery y recuperación con configuración y contratos adecuados; no cierra por sí solo la ventana commit/publicación. | Backend único más broker; comparte ciclo de vida del consumidor con la aplicación. Es la alternativa candidata A3. |
| D. RabbitMQ con worker independiente | Añade otro ejecutable, composición, supervisión y coordinación de versiones. | Permite separar ciclo de vida y capacidad del consumidor; conserva problemas de publicación y duplicados. | Más unidades operativas; fuera del alcance solicitado y sin justificación aprobada para el MVP. |

Se propone C por el objetivo académico y el caso técnico acotado. A y B siguen como alternativas de menor operación externa; no se declara que C sea superior por rendimiento medido. D no forma parte de la arquitectura objetivo candidata.

## 4. Decisión propuesta

Proponer **RabbitMQ para transportar eventos técnicos de invalidación de caché pública**. No transporta órdenes de confirmar reservas, resultados del adelanto, registro del saldo ni mensajes entre usuarios.

| Elemento candidato | Ubicación y responsabilidad |
|---|---|
| Productores | Casos de uso existentes de gestión que confirman cambios de campos públicos; no un nuevo módulo de negocio. |
| Puerto de publicación | Abstracción definida hacia el núcleo apropiado; Aplicación solicita la comunicación sin conocer el cliente RabbitMQ. Ubicación y contrato exactos pendientes. |
| Adaptador de publicación | Infraestructura implementa el puerto y traduce al broker; no introduce reglas de reserva. |
| Broker RabbitMQ | Transportar mensajes conforme a enrutamiento, durabilidad y garantías que se aprueben. |
| Consumidor técnico interno | Recibir y validar mensajes dentro del Backend UrbanPulse y solicitar invalidación por la frontera autorizada. |
| Frontera de invalidación de Redis | Aplicar la política de ADR-010 a las copias afectadas; titular y contrato por diseñar, sin acceder a tablas o clases privadas ajenas. |

Presentación recibe operaciones REST; Aplicación coordina; Dominio expresa reglas y contratos apropiados; Infraestructura implementa adaptadores. Dependencias de código hacia el núcleo, sin referencias de Dominio a RabbitMQ, Redis o Infraestructura. No se selecciona biblioteca, protocolo concreto, versión, firmas, esquema de mensaje, cola o exchange. Tampoco se adopta un framework de tareas.

El consumidor estará dentro del mismo backend propuesto: no se añade worker independiente, noveno módulo funcional, microservicio ni balanceador. Publicar y consumir mensajes técnicos no sustituye las interfaces públicas internas de colaboración entre módulos.

## 5. Flujo conceptual

Secuencia explicativa **propuesta**; no constituye un contrato implementado ni una garantía atómica:

1. El propietario modifica información pública de su establecimiento mediante una operación existente.
2. El backend verifica autorización, titularidad y reglas aplicables.
3. El cambio se confirma en la base relacional mediante los repositorios pertinentes.
4. Se genera o conserva la intención de invalidación según el mecanismo de publicación que se apruebe. Si se elige Outbox, la intención deberá registrarse junto con el cambio en la misma transacción: esta condición pertenece al commit del paso 3, aunque aquí se explique separada.
5. RabbitMQ recibe el mensaje, sujeto a la publicación y enrutamiento diseñados.
6. El consumidor interno valida el mensaje y procesa la petición de invalidación.
7. Redis elimina o invalida las copias afectadas mediante su frontera autorizada.
8. Una consulta posterior reconstruye la ficha desde la fuente definitiva, conforme a ADR-010.

El paso 4 exige resolver la **ventana de fallo entre commit y publicación**. En publicación directa posterior, el backend puede caer después del paso 3 y antes de conservar o enviar la intención. No se garantiza que llegue al paso 5. Si el mensaje llega y falla Redis, tampoco se considera terminada la invalidación. Confirmar el cambio de negocio no equivale a confirmar publicación, recepción o procesamiento.

Una gestión administrativa existente que cambie información pública necesitaría el mismo análisis de impacto, sin ampliar HU11/RF15 ni atribuir al administrador gestión de usuarios.

## 6. Entrega y recuperación

Las siguientes son opciones y obligaciones por diseñar, **sin configuración adoptada ni garantía operativa acreditada**. Las distinciones entre confirmación del productor y ACK del consumidor se contrastan con la documentación oficial de [RabbitMQ sobre acknowledgements y publisher confirms](https://www.rabbitmq.com/docs/confirms).

| Tema | Evaluación y límite pendiente |
|---|---|
| Entrega al menos una vez | Candidata para tareas conservadas y recuperables; exige diseñar publicación fiable, almacenamiento, reenvíos y consumo. No basta con instalar el broker ni cubre una intención perdida antes de publicar. |
| Publisher confirms | Permiten al productor conocer la aceptación del broker bajo la configuración seleccionada; no prueban commit relacional, consumo ni invalidación de Redis. Confirmación perdida deja resultado incierto y puede motivar reenvío duplicado. |
| Enrutamiento y durabilidad | Una confirmación del broker no demuestra por sí sola que el mensaje llegó a la cola esperada. Decidir detección de mensajes sin ruta, persistencia del mensaje y durabilidad/tipo de colas antes de prometer supervivencia a reinicios. |
| ACK de consumidor | Evaluar reconocimiento después de completar la invalidación requerida. Un ACK anterior puede perder trabajo; un fallo después de invalidar y antes del ACK puede causar redelivery. |
| Duplicados | Diseñar procesamiento idempotente respecto del efecto de invalidación. Repetir eliminación puede ser inocuo, pero no resuelve por sí solo repoblaciones concurrentes o efectos futuros. No prometer exactamente una vez. |
| Reintentos limitados | Definir errores recuperables, límite, espera y tratamiento al agotarse; evitar reencolado inmediato interminable y saturación. No se fijan cantidades ni tiempos. |
| DLQ | Evaluar destino de fallos, inspección y eventual reproceso autorizado. Una DLQ conserva casos para tratamiento según configuración; no demuestra recuperación automática ni efecto completado. |
| Mensajes inválidos | Validar forma, versión y alcance; impedir invalidaciones no autorizadas. Definir rechazo y diagnóstico sin un ciclo infinito de reintentos ni datos sensibles en registros. |
| Fallo del consumidor | Con ACK manual y configuración adecuada, tareas no reconocidas pueden volver a entregarse; definir reconexión, recuperación y supervisión del consumidor interno al reiniciar el backend. |
| Fallo del broker | Nuevas publicaciones pueden fallar o quedar inciertas; copias públicas podrían quedar desactualizadas. Recuperar intenciones solo cuando el mecanismo aprobado las conserve; no inventar una cola local durable implícita. |
| Fuera de orden | No presumir orden global entre productores, reenvíos o consumidores. Evaluar versiones/generaciones y eventos de invalidación que no reintroduzcan valores antiguos. |

Estas limitaciones y la posibilidad de redelivery se apoyan en la [guía de fiabilidad de RabbitMQ](https://www.rabbitmq.com/docs/reliability). La documentación de producto no aprueba los contratos de UrbanPulse. El número de consumidores, las conexiones y sus límites siguen pendientes; se deberá considerar que el consumidor comparte recursos con las consultas y operaciones del backend.

## 7. Consistencia y Transactional Outbox

| Estrategia de publicación | Garantía posible y ventana de fallo |
|---|---|
| Antes del commit relacional | El broker puede aceptar un evento cuyo cambio posteriormente se revierte. Un consumidor podría invalidar y reconstruir con datos previos; tampoco hay atomicidad entre los sistemas. |
| Directa después del commit | Evita anunciar intencionalmente cambios no confirmados si el orden se respeta. Puede perder la intención si el proceso falla antes de publicar; un error de red puede dejar entrega incierta. Los confirms no eliminan esa ventana. |
| Transactional Outbox | Alternativa: conservar cambio e intención en una misma transacción relacional y publicar posteriormente intenciones pendientes. Evita perder esa intención por un fallo posterior al commit, si la persistencia y recuperación se diseñan correctamente. No proporciona entrega exactamente una vez ni consumo atómico con Redis. |

**Transactional Outbox sigue pendiente de decisión.** Para evaluarlo se deben precisar unidad transaccional entre cambio e intención, propiedad modular, repositorio, lectura y despacho de pendientes, confirmaciones, marcado de publicación, concurrencia, reintentos, retención y recuperación. Un despacho candidato podría ejecutarse dentro del backend, sin exigir worker separado; no se aprueba ese mecanismo por describirlo.

Una caída tras publicar y antes de marcar la intención como enviada puede producir duplicados incluso con Outbox. El consumidor necesita tratamiento idempotente y control de carreras de caché. No se añaden tablas, esquemas, tareas programadas ni contratos en esta entrega.

Si se elige publicación directa sin registro durable de intención ni reconciliación aprobada, se deberá aceptar y documentar que una invalidación puede perderse sin recuperación garantizada. Los reintentos en memoria no sobreviven necesariamente al proceso. **TTL limita la vida de ciertas copias bajo una política definida; no sustituye entrega fiable, conservación de intención ni recuperación.** Sin TTL definido, tampoco existe un plazo máximo de obsolescencia comprometido.

Redis caído implica respaldo relacional para consultas conforme a ADR-010; invalidaciones pendientes requieren recuperación o tratamiento antes de reutilizar copias recuperadas. RabbitMQ caído no impide por sí mismo consultar la base ni atender una copia admisible, pero puede dejar copias antiguas. El tratamiento durante interrupciones y la vuelta a servicio siguen pendientes: no se promete frescura inmediata ni disponibilidad absoluta.

## 8. Relación con el Monolito Modular

ADR-001 permanece vigente: **Usuarios, Establecimientos, Recursos, Disponibilidad, Reservas, Solicitudes, Servicios y Pagos Simulados** son los ocho módulos. El consumidor técnico interno no es un microservicio ni un noveno módulo funcional. El backend continúa como un único contenedor de aplicación; broker, caché y base son infraestructura de apoyo, sin separar los módulos en desplegables de negocio.

ADR-002 conserva las cuatro capas y las dependencias hacia el núcleo. ADR-006 ofrece el criterio de interfaces/adaptadores, sin convertir mensajería técnica en una integración funcional ya aprobada por los drivers. ADR-008 mantiene repositorios; RC03/ADR-005 mantiene REST entre web y backend. Las colaboraciones internas conservan interfaces públicas y no acceden a implementaciones o tablas privadas ajenas.

Se contrastaron [diseño de módulos](../../03-diseño-software/diseño-interno/diseño-interno-de-modulos.md), [patrones](../../03-diseño-software/diseño-interno/patrones-de-diseño.md) y [principios](../../03-diseño-software/diseño-interno/principios-de-diseño.md). Sus clases, firmas y composición siguen propuestas. Esta ADR no amplía puertos de Reserva ni traslada al consumidor las responsabilidades del simulador.

**RN-13 aprobada y PC-05 abierto** permanecen independientes de Redis/RabbitMQ. La confirmación requiere disponibilidad válida y adelanto simulado aprobado; eventos requieren también aceptación interna del cliente (DF-02–DF-04/DP-12). Los mensajes de invalidación no confirman, rechazan ni cambian Reserva, adelanto o saldo; tampoco conservan en exclusiva su evidencia obligatoria. RN-12 continúa derivada: consultar o coordinar no retiene recursos.

DP-03 conserva total y adelanto fijados al iniciar. DP-04 y HU14/RF20 conservan fórmula y registro posterior completo del saldo por propietario autorizado de reserva confirmada propia, una recepción activa e historial; registrar o corregir saldo no cambia Reserva ni resultado del adelanto. Todo pago sigue simulado (RC07/DF-06/DP-01/DP-07), sin integraciones financieras ni pagos parciales del saldo. [RN/PC](../../03-diseño-software/01-reglas-de-negocio.md), [estados](../../03-diseño-software/02-estados-y-transiciones.md) y [flujos](../../03-diseño-software/03-flujos-de-reserva.md) mantienen sus niveles originales; PC-08 sobre resultados de pago no queda resuelto por reintentar mensajes técnicos.

## 9. Seguridad

Se proponen acceso restringido al broker, credenciales protegidas de publicación y consumo y permisos mínimos según las funciones que se definan. Las interfaces administrativas deberán tener acceso controlado. No se seleccionan protocolos, bibliotecas, mecanismos concretos de autenticación ni configuración; no se afirma que estos controles estén implementados.

El consumidor debe validar mensajes antes de actuar y limitar su efecto a las fichas autorizadas. La información transportada debería ser la mínima necesaria para localizar el ámbito afectado, sin enviar credenciales, datos privados de reservas, cotizaciones particulares, resultados de adelanto o registros de saldo. Esquema, identificación y versión siguen pendientes.

Se deberá diseñar trazabilidad de errores y correlación técnica sin volcar datos sensibles. Los permisos del broker no sustituyen la autorización del usuario en el caso de uso productor (AC04/ADR-007/PC-11). La mensajería técnica no es mensajería entre usuarios ni sustituye la aceptación dentro de UrbanPulse por conversaciones de WhatsApp.

## 10. Costes

| Escenario | Recursos y trabajo por evaluar |
|---|---|
| Desarrollo local | Ejecución del broker, almacenamiento, conexiones, configuración de productores/consumidor, diagnóstico y preparación de fallos reproducibles. |
| Demostración académica | Recursos simultáneos para backend, base, Redis y RabbitMQ; datos de prueba, evidencia de entrega/duplicados/fallos y tiempo de preparación y recuperación. |
| Eventual despliegue | Capacidad del broker, almacenamiento y retención, conexiones, supervisión, actualizaciones, seguridad, recuperación y soporte. Outbox añadiría carga y mantenimiento relacional si se aprueba. |

El consumidor interno comparte recursos y ciclo de vida con el backend; no es gratuito por evitar otro ejecutable. Frente a A/B de la sección 3, C incrementa operación y complejidad para demostrar transporte y recuperación bajo garantías definidas. No se presentan precios, dimensionamiento ni rendimientos medidos; versiones, licencias y modalidad de despliegue deberán revisarse antes de adoptarlas.

## 11. Criterios de aceptación

Son **pruebas propuestas, pendientes de revisión y ejecución**. Cada demostración deberá registrar versión, configuración, datos, punto de fallo, resultado esperado/obtenido y límites de la garantía. Los procedimientos y métricas de EQ siguen pendientes; no se crean objetivos cuantitativos aprobados.

| Caso propuesto | Evidencia esperada |
|---|---|
| Publicación y consumo | Un cambio autorizado confirmado produce invalidación de todas las fichas afectadas por la política acordada; la consulta posterior reconstruye desde datos definitivos. |
| Confirm del productor y ACK | Distinguir aceptación del broker de procesamiento; demostrar ACK posterior al efecto requerido y tratamiento de publicación incierta o sin ruta según diseño. |
| Mensaje duplicado | Reprocesar sin modificar negocio ni corromper la caché; contrastar también repoblaciones concurrentes, no solo repetir una eliminación aislada. |
| Reintento recuperable | Un fallo temporal de Redis se trata según límite y política acordados, sin ACK de éxito prematuro ni reencolado infinito. |
| Caída antes del ACK | Interrumpir tras invalidar y antes de reconocer; observar redelivery cuando la configuración lo garantice y verificar efecto idempotente. |
| Broker no disponible | Distinguir cambios confirmados, intenciones conservadas y publicaciones fallidas o inciertas; evidenciar obsolescencia posible y respuesta acordada. |
| Ventana commit/publicación | Interrumpir tras commit y antes de envío. Con publicación directa, exhibir la pérdida posible; con mecanismo durable aprobado, demostrar conservación y posterior despacho. |
| Recuperación | Reiniciar backend/broker y recuperar únicamente tareas cuya conservación esté garantizada por diseño y configuración. No declarar recuperación de una intención nunca persistida. |
| Mensaje inválido y agotamiento | Rechazo y diagnóstico controlados; demostrar destino y reproceso solo si se aprueba DLQ, sin ciclos infinitos ni exposición de datos. |
| Fuera de orden | Entregar invalidaciones en orden invertido y comprobar que no reintroducen representaciones antiguas según el mecanismo aprobado en ADR-010. |
| Aislamiento funcional | Comparar Reserva, resultado del adelanto, importes fijados, aceptación y registros del saldo antes/después de consumir, duplicar o fallar. No deben modificarse por eventos técnicos. |
| Consistencia concurrente | Una vez resuelto PC-05, verificar RN-13 ante fallos de caché/broker y concurrencia; el consumidor no participa como autoridad de confirmación. |

No se han ejecutado pruebas de publicación, ACK, recuperación, Redis, RabbitMQ ni concurrencia en esta entrega documental.

## 12. Impacto documental

No se modifica el catálogo ADR-001–ADR-009 ni C1/C2/C3. La consolidación y actualización de vistas requieren autorización posterior y decisiones auditadas/aprobadas.

| Vista futura | Impacto conceptual de A3 |
|---|---|
| [C1 — Contexto](../../04-modelo-c4/01-contexto-c1.md) | Sin modificación: no cambian actores, límite funcional ni sistemas externos de negocio. |
| [C2 — Contenedores](../../04-modelo-c4/02-contenedores-c2.md) | Pasaría de tres a cinco contenedores: Aplicación Web, Backend UrbanPulse, Base de datos relacional, Redis y RabbitMQ. RabbitMQ como broker; Redis como copia reconstruible. Sin balanceador ni worker independiente. No equivale a cinco microservicios. |
| [C3 — Componentes](../../04-modelo-c4/03-componentes-c3.md) | Mantener ocho módulos. Mostrar productores candidatos en gestión de Establecimientos y, condicionadamente, Recursos/Servicios; consulta cacheada en Establecimientos; puerto/adaptadores y consumidor técnico internos según fronteras por aprobar. No atribuir productores a Disponibilidad, Reservas o Pagos por inferencia. |
| C4 — Código | Documentar después puertos, adaptadores, contratos de publicación/consumo, tratamiento de fallos y composición. No se crea esta vista ni se fijan firmas definitivas ahora. |

La [arquitectura inicial](../../02-arquitectura-software/01-arquitectura-inicial.md) conserva tres capas frente a las cuatro oficiales ADR-002; el [README](../../../README.md) enumera Presentación, Lógica de negocio, Datos y Sistemas externos sin esa correspondencia. El catálogo afirma armonización textual que no coincide con el archivo inicial. Se aplica ADR-002 sin editar esas fuentes. La mención de ORM en [estilo](../../02-arquitectura-software/02-estilo-arquitectonico.md) no aprueba producto, y la aprobación conceptual de patrones no aprueba contratos concretos. Referencias gráficas desactualizadas del catálogo no validan tecnologías; no se generan diagramas ni se acredita inspección visual de imágenes.

## 13. Pendientes

- Auditoría y aprobación de RabbitMQ para invalidación técnica y de ADR-010 para su caché pública; consolidación del catálogo en tarea autorizada posterior.
- Esquemas, identidad y versiones de mensajes; contratos de publicación/consumo y frontera autorizada de invalidación; alcance de cada productor y composición de la ficha.
- Exchanges, colas, enrutamiento, detección de mensajes sin destino, durabilidad, persistencia y garantías ante reinicios; sin configuración adoptada.
- Publisher confirms, ACK, reintentos limitados, esperas, agotamiento, DLQ, inspección y eventual reproceso.
- Idempotencia, duplicados, desorden y coordinación con versionado/generaciones y carreras de repoblación de ADR-010.
- Decidir publicación directa o Transactional Outbox, con sus garantías, ventanas de pérdida, límites y mecanismo de despacho/recuperación dentro del backend si corresponde. Outbox no está aprobado.
- Políticas de recuperación de broker, consumidor y Redis; manejo de copias antiguas al volver a servicio y de intenciones conservadas frente a las perdidas.
- Supervisión y métricas técnicas, trazabilidad de errores, recursos compartidos, conexiones, capacidad y costes, sin umbrales seleccionados.
- Seguridad y operación: credenciales, permisos mínimos, administración, protección de datos y mecanismos concretos por definir.

PC-01–PC-12 de RN permanecen abiertos. Estas decisiones técnicas de invalidación no resuelven PC-05 ni los contratos de adelanto PC-08, y no alteran los límites aprobados de DF/DP. PC-06 conserva pendiente precisión/límites y saldo cero sin reabrir fórmula ni registro completo aprobados. RF13 y PC-09/PC-10 siguen pendientes: no se habilitan cancelación, devolución, reapertura, expiración o cierre de reservas. Queda pendiente validar cobertura y EQ (PC-12) antes de afirmar cumplimiento de calidad o actualizar diagramas.

## Registro de cierre conceptual

**Fecha de cierre:** 16/10/2026.

**Resultado de auditoría:** apta para aprobación conceptual condicionada, según el resultado comunicado en la solicitud de cierre. La verificación documental final de esta ADR, ADR-010, el catálogo ADR-001–ADR-009 y C2/C3 no identifica contradicciones bloqueantes dentro del alcance autorizado. Se registra la aprobación conceptual y el cierre documental de la arquitectura objetivo acotada; no se aprueban automáticamente implementación, configuraciones, contratos, despliegue ni pruebas.

**Alcance adoptado:** RabbitMQ como broker de eventos técnicos para invalidación asíncrona de fichas públicas de [ADR-010](ADR-010-cache-redis.md), con publicación a través de puertos internos, adaptadores en Infraestructura y consumidor técnico dentro del Backend UrbanPulse. No se añade worker independiente, noveno módulo funcional ni balanceador de carga. Los productores se limitan a casos de uso existentes que modifiquen información incluida en las fichas; la composición de la proyección, el reparto exacto y los contratos siguen pendientes.

Se conserva **entrega al menos una vez como objetivo de diseño condicionado a garantías concretas** de publicación, conservación y recuperación. Se exige procesamiento idempotente y ACK después de completar el efecto requerido, con tratamiento de duplicados, reintentos y mensajes fallidos. Estos criterios conceptuales no acreditan su implementación: no se promete entrega exactamente una vez ni recuperación de intenciones perdidas antes de publicarse o conservarse.

Las secciones 1–13 se conservan íntegramente como antecedente de evaluación y diseño. Sus expresiones «propuesta», «candidato» y las referencias a aprobación conceptual pendiente deben leerse con este registro: queda satisfecha la aprobación conceptual del alcance aquí adoptado y de ADR-010, sin adoptar mecanismos pendientes. Las alternativas síncrona y asíncrona sin broker conservan su valor comparativo; no dejan abierta la selección conceptual de RabbitMQ para A3. Redis funciona sin depender del broker para cada consulta; ADR-011 utiliza el caso de caché aprobado en ADR-010 sin establecer dependencia circular de aprobación.

**Condición de fiabilidad obligatoria:** permanece abierta la decisión entre publicación directa posterior al commit, con sus riesgos de pérdida y resultado incierto, y Transactional Outbox, con conservación de la intención y complejidad adicional. RabbitMQ no garantiza atomicidad con la base relacional. Outbox no queda aprobado implícitamente; el mecanismo de publicación y recuperación deberá seleccionarse, diseñarse y validarse antes de afirmar que la invalidación es fiable frente a fallos. TTL no sustituye conservación de intención, entrega fiable ni recuperación. Los duplicados siguen siendo posibles con Outbox.

**Condiciones técnicas abiertas:**

- Seleccionar publicación directa u Outbox y precisar sus garantías, riesgos aceptados, ámbito transaccional si corresponde, despacho y recuperación de intenciones dentro del backend, sin aprobar tablas, tareas ni contratos concretos.
- Definir esquemas y versiones de mensajes, puertos, adaptadores y frontera autorizada de invalidación; nombres de colas, exchanges y routing keys, bibliotecas y configuración de durabilidad permanecen sin seleccionar.
- Concretar publisher confirms, ACK posterior al efecto requerido, idempotencia, reintentos limitados y sus tiempos, tratamiento de mensajes inválidos, agotamiento, DLQ y eventual reproceso; no se presume que esos mecanismos estén configurados.
- Diseñar recuperación ante caídas del broker, consumidor y Redis, duplicados, desorden y repoblación concurrente, coordinada con ADR-010; fijar capacidad, supervisión, métricas y seguridad operativa.
- Validar retirada de visibilidad pública: una invalidación asíncrona y un TTL genérico no bastan por sí solos para impedir divulgación de información ya no autorizada. La política y el mecanismo de confidencialidad de ADR-010 permanecen pendientes de diseño y validación.
- Mantener pendientes procedimientos, condiciones y evidencia de aceptación; ninguna garantía de entrega, procesamiento o recuperación se deduce exclusivamente de esta aprobación conceptual.

**Coherencia conservada:** ADR-001–ADR-009 siguen vigentes y se complementan. Se mantienen ocho módulos funcionales en un único backend, cuatro capas y dependencias hacia el núcleo, interfaces públicas internas y adaptadores de Infraestructura; REST sigue en la frontera web–backend. No se modifican modalidades, aceptación interna del evento ni reglas de adelantos y saldos exclusivamente simulados, ni se incorporan integraciones financieras. WhatsApp permanece como redirección externa y mapas mantiene proveedor, frontera y mecanismo pendientes. Los mensajes técnicos no cambian estados de reserva, adelanto ni registro del saldo. RN-13 continúa aprobada, PC-05 abierto y RF13 y PC-01–PC-12 conservan sus estados; RabbitMQ/Redis no resuelven la concurrencia de confirmaciones.

**Actualización documental posterior:** consolidar el [catálogo ADR](../07-decisiones-arquitectonicas.md) y actualizar [C2](../../04-modelo-c4/02-contenedores-c2.md) para reflejar los cinco contenedores de A3: Aplicación Web, Backend UrbanPulse, Base de datos relacional, Redis y RabbitMQ. [C3](../../04-modelo-c4/03-componentes-c3.md) deberá incorporar productores según responsabilidad verificada, puertos, adaptadores y consumidor técnico interno manteniendo ocho módulos. El Diseño Interno y futuro C4 deberán desarrollar contratos y mecanismos cuando se aprueben; C1 no requiere modificación. C2 conserva actualmente tres contenedores y C3 no incorpora caché ni mensajería: se registra el desfase para otra tarea autorizada, sin modificar esas vistas. Los desfases previos de capas y referencias gráficas permanecen señalados; rige ADR-002.

**Evidencia y límites:** no existen pruebas ejecutadas ni implementación acreditada de RabbitMQ o de este flujo en la entrega. El cierre no demuestra entrega, ACK, idempotencia, recuperación, rendimiento ni cumplimiento de EQ. Solo se actualizan esta ADR y ADR-010; catálogo, C1/C2/C3, Diseño Interno, reglas, README y código permanecen sin modificación.

**URBANPULSE — ADR-011 APROBADA CONCEPTUALMENTE — CIERRE DOCUMENTAL COMPLETADO — SIN COMMIT NI PUSH.**
