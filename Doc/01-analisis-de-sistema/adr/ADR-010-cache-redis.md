# ADR-010 — Estrategia de caché con Redis

**Proyecto:** UrbanPulse

**Estado: APROBADA CONCEPTUALMENTE — CERRADA DOCUMENTALMENTE — IMPLEMENTACIÓN Y MECANISMOS OPERATIVOS PENDIENTES**

**Fecha:** 16/10/2026

**Decisión relacionada:** ADR-009 — Optimización de consultas de disponibilidad.

## 1. Contexto

UrbanPulse permite buscar establecimientos y consultar sus servicios, precios, ubicación y condiciones. Reutilizar copias de información pública podría reducir accesos repetidos a persistencia. No se dispone de mediciones que demuestren un cuello de botella, una reducción de carga o una mejora de latencia. AC01 expresa una necesidad cualitativa; los procedimientos y métricas de EQ-01 siguen pendientes de revisión.

La solicitud académica selecciona **A3 — Base relacional + Redis + RabbitMQ** como alternativa para documentar. Autoriza estas propuestas, sin aprobar tecnologías operativas, contratos o implementación. No se localizó una evaluación previa de Redis/RabbitMQ en los archivos accesibles del repositorio; se utilizan las conclusiones suministradas en la solicitud como contexto, sin atribuirles un archivo inexistente. El balanceador queda fuera del MVP, como posibilidad futura sin diseño adoptado.

| Referencia | Relación y límite de trazabilidad |
|---|---|
| [HU01/RF01](../03-requisitos-funcionales.md) | Búsqueda de establecimientos; RF01 es origen explícito de DA04. Una ficha cacheada puede apoyar la consulta posterior; no convierte la búsqueda con filtros en alcance inicial de caché. |
| [HU02/RF02](../03-requisitos-funcionales.md) | Consulta de información del establecimiento: contexto funcional directo de las fichas públicas. RF02 carece de origen explícito en drivers; no se inventa RF02 → DA04. |
| [HU06/RF08](../03-requisitos-funcionales.md) | Gestión de información y condiciones por el propietario; contexto de los cambios que podrían requerir invalidación. RF08 figura en DA05 por autorización, sin atribuirle origen DA04. |
| [AC01](../04-atributos-de-calidad.md), [DA04](../06-driver-arquitectonicos.md), [ADR-009](../07-decisiones-arquitectonicas.md) | Cadena existente de rendimiento y consultas. Esta propuesta es una extensión técnica complementaria; ADR-009 no había aprobado caché. |
| AC03 → DA02 → ADR-004 | Límite de consistencia: verificar disponibilidad al confirmar e impedir reservas incompatibles. Redis no satisface esa obligación. |
| AC04 → DA05 → ADR-007 | Límite de seguridad: separar información pública de datos protegidos y conservar autorización por roles y titularidad. |

Las [HU](../02-historias-del-usuarios.md) y RF conservan sus estados. RC04/ADR-008 mantienen persistencia relacional y repositorios sin motor aprobado. ADR-001/ADR-002 mantienen Monolito Modular y cuatro capas. Las DF-01–DF-06 y DP-01–DP-12 de [restricciones](../05-restricciones.md) continúan aprobadas; Redis no modifica modalidades, aceptación interna ni simulación académica.

## 2. Problema arquitectónico

Determinar cómo reutilizar consultas públicas repetidas sin comprometer integridad, privacidad, exactitud de importes, disponibilidad válida al confirmar ni mantenibilidad. Es necesario distinguir una representación informativa posiblemente obsoleta de la información autorizada usada por una operación crítica. La utilidad de la caché debe contrastarse con el coste de mantenerla y con la optimización relacional existente.

## 3. Alternativas consideradas

Comparación cualitativa de alternativas candidatas; no expresa resultados medidos ni una selección operativa aprobada.

| Alternativa | Simplicidad y mantenimiento | Escalabilidad potencial | Coste relativo | Consistencia |
|---|---|---|---|---|
| A. Solo optimización relacional | Menos piezas; continúa ADR-009 y el acceso por repositorios. | Depende de consultas, datos y capacidad relacional; requiere evaluación. | Evita operar una caché adicional; conserva coste de consultas repetidas. | Evita una copia externa, pero no resuelve automáticamente concurrencia de reservas. |
| B. Caché en memoria del backend | Inicio sencillo; ciclo de vida ligado al proceso. | Cada instancia futura tendría su copia; crecimiento de memoria y coordinación por resolver. | Sin servicio adicional; consume memoria del backend. | Invalidación local; reinicios pierden copias y posibles instancias divergen. |
| C. Redis externo al proceso | Separa almacenamiento de copias; añade conexión, configuración y operación. | Permite compartir copias entre eventuales instancias; no aprueba replicar el backend ni garantiza capacidad. | Recursos y soporte adicionales; conveniencia por medir. | Requiere invalidación, control de obsolescencia y tratamiento de fallos. |

Se propone C para la demostración académica A3. A sigue siendo la base y la referencia para comparar resultados; B permite evaluar una alternativa de menor complejidad operativa. La selección para documentar no demuestra que C sea necesaria por volumen real.

## 4. Decisión propuesta

Proponer **Redis como caché externa de fichas públicas de establecimientos**, con estrategia **cache-aside**: el backend consulta la copia y, si falta, obtiene los datos definitivos mediante los repositorios y fronteras públicas pertinentes.

- Redis conserva exclusivamente copias reconstruibles para este alcance; la base relacional mantiene la autoridad definitiva.
- Reservas, adelantos, saldos, aceptación de condiciones y evidencias obligatorias no tienen en Redis su única fuente ni se incluyen en las fichas públicas.
- No se cachean permisos como autoridad. El backend conserva los controles de rol, titularidad y visibilidad.
- No se cachea inicialmente disponibilidad, ni se utiliza Redis para confirmar o retener recursos.
- Los precios y condiciones públicos son informativos. Antes de iniciar una simulación se obtienen y validan los valores autorizados; total y adelanto se muestran antes y quedan fijados al iniciar (DP-03). Una ficha antigua no recalcula importes fijados ni sustituye condiciones aceptadas.
- Las búsquedas públicas son una extensión condicionada a pruebas de filtros, composición e invalidación; no se cachean inicialmente resultados por disponibilidad.

No se fijan cliente, biblioteca, versión, claves, TTL, topología ni proveedor de despliegue. Esta propuesta no modifica RC04: la copia técnica es prescindible y no sustituye la persistencia relacional. Su operación concreta requiere aprobación posterior.

## 5. Diseño conceptual

| Situación | Comportamiento propuesto | Límite pendiente |
|---|---|---|
| Cache hit | Devolver una copia pública válida según la política que se apruebe. | Existir en Redis no prueba vigencia absoluta. Deben definirse visibilidad, antigüedad y versión admisibles. |
| Cache miss | Consultar persistencia mediante repositorios y fronteras públicas; construir la proyección pública y poblar la caché. | No leer tablas privadas de otro módulo ni publicar campos protegidos. Carreras de reconstrucción pendientes. |
| Cambio confirmado | Invalidar la información pública afectada para que una consulta posterior la reconstruya. | Identificar todos los cambios y dependencias de la ficha; no invalidar como si un cambio revertido hubiera sido confirmado. |
| Fallo de Redis al leer o escribir | Recurrir a consulta relacional; si ya se obtuvo el resultado autorizado, un fallo al guardar la copia no lo convierte en dato inexistente. | Detectar fallos sin esperas indefinidas; tiempos y límites de conexión pendientes. La base puede fallar o saturarse: el respaldo no garantiza continuidad absoluta. |

**Política y transporte son decisiones distintas.** Determinar qué ficha invalidar, cuándo y con qué tolerancia pertenece a esta estrategia. RabbitMQ es el transporte candidato de invalidación de ADR-011; no es necesario para atender un hit o un miss, ni una condición para que Redis funcione. Se podría invalidar síncronamente o usar otro mecanismo aprobado después. ADR-010 justifica la caché por sí misma; ADR-011 depende de ese caso de uso y no constituye un prerrequisito circular.

Como asignación candidata, Establecimientos consume la caché en sus consultas públicas. Sus casos de uso de gestión producirían intenciones de invalidación; Recursos y Servicios solo lo harían si sus cambios afectan campos incluidos en la ficha. El [C3 local](../../04-modelo-c4/03-componentes-c3.md) respalda información/gestión en Establecimientos, configuración de unidades en Recursos y oferta informativa en Servicios. No define sus contratos cruzados: la composición de la ficha, la frontera de invalidación y su titular técnico siguen pendientes. No se añaden llamadas obligatorias ni productores a todos los módulos.

## 6. Consistencia

La propuesta admite un riesgo de **obsolescencia de información pública**, no una autorización para usar datos obsoletos en decisiones críticas. La tolerancia aceptable debe acordarse por campo y operación antes de implementar.

| Riesgo | Análisis y alternativas por evaluar |
|---|---|
| Invalidación retrasada o perdida | Una modificación confirmada puede coexistir con una copia antigua mientras se transporta o recupera la invalidación. Una caída del broker prolongaría esa situación; aún no hay garantía de publicación fiable. |
| Carrera de repoblación | Una lectura obtiene datos antiguos; después se confirma un cambio y se invalida; finalmente esa lectura escribe la copia antigua. Borrar una clave no basta para evitarlo. Evaluar versiones o generaciones contrastadas antes de publicar la copia, sin escoger un algoritmo. |
| Cache stampede | Muchos misses simultáneos pueden repetir consultas y sobrecargar la base. Evaluar coordinación de reconstrucciones y dispersión de vencimientos; no adoptar bloqueos ni retenciones sobre recursos reservables. |
| TTL | Puede limitar la vida de una copia bajo condiciones definidas, pero no asegura entrega de invalidaciones ni evita una repoblación antigua. Duración, renovación y tolerancia pendientes. Su expiración es de caché, no de Reserva. |
| Evicción | La retirada de copias por presión de memoria debe tratarse como miss reconstruible. Evaluar capacidad y política; no depende de conservar datos de negocio solo en Redis. |
| Cambios concurrentes y fuera de orden | Varias modificaciones de campos o módulos pueden afectar una ficha. Evaluar invalidación repetible y versiones/generaciones; un evento antiguo no debe reponer una representación anterior. |
| Cambio de visibilidad pública | Una copia antes pública puede dejar de ser publicable. Definir controles y tratamiento del retraso; no declarar resuelto este riesgo mediante TTL. |

La naturaleza reconstruible y el efecto de evicción se apoyan en la documentación técnica de [Redis sobre evicción](https://redis.io/docs/latest/develop/reference/eviction/). La política concreta de UrbanPulse sigue sin seleccionar.

**RN-13 permanece aprobada y PC-05 abierto**, conforme a [RN y PC](../../03-diseño-software/01-reglas-de-negocio.md). Confirmar reservas deberá usar la autoridad transaccional y la coordinación con Disponibilidad que se aprueben posteriormente para PC-05; no una ficha, un TTL, un mensaje o una consulta seguida de escritura. No se aprueban bloqueos, retenciones ni expiraciones de reservas. Consultar o coordinar no retiene el recurso (RN-12, derivada).

## 7. Consecuencias

**Positivas esperadas, sujetas a evaluación:**

- Potencial reducción de consultas repetidas a persistencia.
- Demostración académica de caché con copias reconstruibles.
- Posible mejora de latencia en consultas públicas repetidas.
- Separación del detalle tecnológico mediante puertos y adaptadores.

**Negativas y costes de complejidad:**

- Dependencia operativa adicional y consumo de memoria.
- Riesgo de información obsoleta y de exposición de contenido retirado.
- Configuración, supervisión y diagnóstico de fallos adicionales.
- Complejidad de invalidación y de carreras de reconstrucción.
- Mayor carga relacional durante caídas o vaciado de caché; beneficio incierto en conjuntos pequeños o con poca repetición.

## 8. Seguridad

Se proponen acceso restringido a Redis desde componentes autorizados del backend, protección de credenciales y separación de las interfaces de administración. El navegador no accede a Redis. Los mecanismos, permisos y configuración deberán diseñarse; no se afirma que existan controles implementados.

La proyección debe contener únicamente datos autorizados como públicos, con minimización de información. Se excluyen datos privados de clientes, reservas, cotizaciones particulares, resultados del adelanto, registros del saldo, credenciales y evidencias de aceptación. El contacto del establecimiento solo podrá incluirse según su condición pública autorizada. Se deberá comprobar que retirada de visibilidad, cambios de permisos y fallos no expongan datos protegidos.

Las operaciones críticas validan datos vigentes por la frontera autorizada y conservan importes y evidencia definitivos. Una copia pública no concede permisos ni acredita disponibilidad. AC04/ADR-007 y PC-11 mantienen sus límites, sin ampliar funciones del administrador.

## 9. Costes

| Escenario | Costes por evaluar |
|---|---|
| Desarrollo local | Instalación o entorno de ejecución por decidir, memoria, configuración, tiempo de integración y diagnóstico. No se selecciona herramienta de despliegue. |
| Demostración académica | Preparación de datos y casos de hit/miss/fallo, reproducibilidad y evidencia comparativa; recursos para sostener la demostración. |
| Eventual despliegue | Capacidad, conectividad, credenciales, supervisión, actualizaciones, recuperación y soporte; dimensionamiento según datos medidos. |

No hay cifras aprobadas de precios, memoria, carga o rendimiento. Añadir Redis puede costar más que optimizar consultas para el volumen real; el beneficio debe justificarse con evidencia.

## 10. Criterios de aceptación

Son **pruebas propuestas, pendientes de revisión y ejecución**. Para cada caso se deberán registrar versión, datos de referencia, entorno, resultado esperado y obtenido. Carga, duración, métricas y umbrales permanecen abiertos, en coherencia con [EQ](../08-escenarios-atributos-calidad.md).

| Caso propuesto | Evidencia esperada |
|---|---|
| Hit y miss | Una ficha permitida se obtiene desde copia cuando es válida y se reconstruye desde persistencia cuando falta; contenido público equivalente bajo datos estables. |
| Con y sin caché | Comparar mismas consultas y datos; registrar latencia, fallos y accesos relacionales sin declarar una mejora de antemano. |
| Modificaciones | Cambios confirmados de campos incluidos invalidan todas las fichas afectadas según política acordada; cambios revertidos no generan contenido ficticio. Incluir retirada de visibilidad. |
| Respaldo | Con Redis inaccesible o con fallo de escritura, la consulta recurre a persistencia sin exponer datos protegidos ni inventar resultados si también falla la base. |
| Expiración y evicción | La desaparición de una copia produce reconstrucción, sin pérdida de datos definitivos. TTL y política deben acordarse antes del ensayo. |
| Carreras y stampede | Reproducir lectura antigua/cambio/invalidación/repoblación y misses simultáneos; comprobar el mecanismo elegido frente a la tolerancia acordada. No afirmar frescura fuerte sin evidencia. |
| Broker caído | Observar retraso o pérdida según la garantía seleccionada y evaluar recuperación; TTL no se acepta como prueba de publicación. |
| Aislamiento de operaciones críticas | Una ficha con precio antiguo no cambia importes fijados ni condiciones aceptadas; caché o mensajes no modifican Reserva, adelanto o saldo. |
| RN-13 | Cuando PC-05 tenga diseño e implementación, contrastar intentos incompatibles concurrentes con caché habilitada, deshabilitada y en fallo. No debe haber doble confirmación; estas pruebas no sustituyen el diseño de la garantía. |

No se han ejecutado pruebas de Redis, rendimiento ni concurrencia en esta entrega documental.

## 11. Impacto documental

ADR-009 se **complementa, no se reemplaza**: la optimización de consultas de disponibilidad sigue vigente y la disponibilidad queda fuera de esta caché inicial. No se modifica el catálogo consolidado ni los modelos existentes.

| Vista futura | Cambio condicionado a auditoría, aprobación y autorización de actualización |
|---|---|
| [C1 — Contexto](../../04-modelo-c4/01-contexto-c1.md) | Sin modificación: no cambia el límite funcional ni se incorporan actores o sistemas externos de negocio. |
| [C2 — Contenedores](../../04-modelo-c4/02-contenedores-c2.md) | La alternativa conjunta A3 pasaría conceptualmente de tres a cinco: Aplicación Web, Backend UrbanPulse, Base de datos relacional, Redis y RabbitMQ. Redis sería copia técnica; base relacional definitiva. No se agregan balanceador ni worker independiente. |
| [C3 — Componentes](../../04-modelo-c4/03-componentes-c3.md) | Mantener Usuarios, Establecimientos, Recursos, Disponibilidad, Reservas, Solicitudes, Servicios y Pagos Simulados. Representar consulta pública cacheada en Establecimientos, productores condicionados de gestión y adaptadores técnicos según contratos aprobados. |
| C4 — Código | Impacto conceptual en puertos y adaptadores de caché, composición y representación pública. No se crea una vista de código ni se definen firmas, clases o DTO definitivos. |

La relación con mensajería se desarrolla únicamente en [ADR-011 propuesta](ADR-011-mensajeria-rabbitmq.md); esa referencia describe una colaboración opcional, sin hacer depender esta decisión de su aprobación.

Se consultaron [diseño de módulos](../../03-diseño-software/diseño-interno/diseño-interno-de-modulos.md), [patrones](../../03-diseño-software/diseño-interno/patrones-de-diseño.md) y [principios](../../03-diseño-software/diseño-interno/principios-de-diseño.md). Sus contratos siguen propuestos; Repository, Adapter y DIP orientan la separación, sin aprobar tipos concretos para Redis. Infraestructura implementaría los contratos hacia el núcleo; Dominio no depende de Redis ni de Infraestructura.

**Discrepancias conservadas:** la [arquitectura inicial](../../02-arquitectura-software/01-arquitectura-inicial.md) describe tres capas, frente a las cuatro de ADR-002; el [README](../../../README.md) enumera Presentación, Lógica de negocio, Datos y Sistemas externos sin esa correspondencia. El catálogo afirma una armonización que no coincide con el texto inicial. Rige ADR-002 y no se corrigen esas fuentes. La mención de ORM en [estilo](../../02-arquitectura-software/02-estilo-arquitectonico.md) no aprueba un producto. La aprobación conceptual de patrones no se extiende a clases o firmas pendientes. Las referencias gráficas desactualizadas del catálogo no aportan aprobación técnica; no se inspeccionan ni modifican imágenes en esta tarea.

## 12. Pendientes

- Auditoría y aprobación de Redis/cache-aside para este alcance; consolidación posterior del catálogo mediante autorización.
- TTL y renovación; identidad, alcance y composición de claves; política y cobertura de invalidación; tolerancia a obsolescencia por campo, incluida visibilidad.
- Versionado o generaciones y tratamiento de repoblación concurrente, cambios fuera de orden y stampede, sin mecanismo adoptado.
- Capacidad, política de evicción, fallos de conexión, límites de espera y carga del respaldo relacional.
- Seguridad operativa, credenciales, permisos, administración y supervisión.
- Contratos de puertos/adaptadores, titular técnico de la caché, proyección pública y colaboración modular; búsquedas solo tras evaluar filtros e invalidación.
- Validación de rendimiento y condiciones de aceptación de EQ; no se aprueban métricas nuevas ni se completa por analogía la cobertura de AC02/AC07.
- Transporte y recuperación de invalidaciones según ADR-011, si se aprueba; no sustituye los pendientes de esta política.

PC-01–PC-12 permanecen abiertos con su alcance original. Se conservan especialmente PC-05 (concurrencia), PC-06 (precisión, límites y saldo cero), PC-07/PC-08 (adelanto y recuperación), PC-11 (permisos) y PC-12 (trazabilidad/EQ). No se reabre la fórmula ni el registro completo del saldo aprobados. [Estados](../../03-diseño-software/02-estados-y-transiciones.md) y [flujos](../../03-diseño-software/03-flujos-de-reserva.md) mantienen sus niveles; RF13 sigue pendiente. No se añaden cancelación, devolución, expiración de reservas, pagos reales, pagos parciales del saldo ni mensajería de usuarios.

## Registro de cierre conceptual

**Fecha de cierre:** 16/10/2026.

**Resultado de auditoría:** apta para aprobación conceptual condicionada, según el resultado comunicado en la solicitud de cierre. La verificación documental final de esta ADR, ADR-011, el catálogo ADR-001–ADR-009 y C2/C3 no identifica contradicciones bloqueantes dentro del alcance autorizado. Se registra la aprobación conceptual y el cierre documental; no se aprueban automáticamente implementación, configuraciones, contratos, despliegue ni pruebas.

**Alcance adoptado:** Redis exclusivamente para caché de fichas públicas de establecimientos en la arquitectura objetivo del MVP, mediante cache-aside; copias reconstruibles, base relacional como fuente definitiva y fallback a persistencia ante fallos de Redis. Quedan excluidos inicialmente disponibilidad, reservas, aceptación contractual, adelantos y saldos; los permisos cacheados no constituyen autoridad. Las búsquedas públicas permanecen como ampliación futura condicionada a evaluación y aprobación. No se adopta consistencia fuerte de las fichas ni se acredita capacidad o rendimiento.

Las secciones 1–12 se conservan íntegramente como antecedente de evaluación y diseño. Sus expresiones «propuesta», «candidato» y las referencias a aprobación conceptual pendiente deben leerse con este registro: queda satisfecha la aprobación conceptual del alcance aquí adoptado, incluidas las referencias a ADR-011 ahora aprobada conceptualmente. Las alternativas conservan su carácter comparativo; no sustituyen la selección adoptada de Redis y RabbitMQ para A3. Redis puede funcionar sin RabbitMQ y una consulta cacheada no requiere al broker; esa independencia técnica no deja sin adoptar el transporte asíncrono de ADR-011. Los contratos, mecanismos y ampliaciones señalados como pendientes no quedan aprobados por el cierre.

**Condición de seguridad obligatoria:** la retirada de visibilidad pública requiere una política que impida divulgar información que ya no está autorizada. La invalidación asíncrona y un TTL genérico no constituyen por sí solos una garantía suficiente de confidencialidad. El mecanismo técnico concreto permanece pendiente de diseño y validación antes de acreditar esa protección; no se establece una tolerancia que autorice divulgar contenido retirado.

**Condiciones técnicas abiertas:**

- Definir claves, alcance de la proyección pública, TTL, clientes, bibliotecas, capacidad, evicción, controles de acceso y seguridad operativa, sin selección concreta en este cierre.
- Diseñar y validar invalidación, repoblación obsoleta, cambios concurrentes, eventos fuera de orden y stampede; versionado o generaciones continúan como alternativas, sin afirmar consistencia fuerte mediante un mecanismo no demostrado.
- Precisar puertos, adaptadores, titular técnico de la caché y fronteras entre Establecimientos, Recursos y Servicios. Se conservan las asignaciones candidatas y sus límites documentados en C3.
- Resolver en [ADR-011](ADR-011-mensajeria-rabbitmq.md) publicación y recuperación de invalidaciones. RabbitMQ no aporta atomicidad con la base relacional; publicación directa posterior al commit y Transactional Outbox siguen como alternativas abiertas. La fiabilidad frente a fallos no está acreditada.
- Validar respaldo relacional, vuelta a servicio, confidencialidad al retirar visibilidad y criterios de aceptación; métricas, procedimientos EQ y evidencia siguen pendientes.

**Coherencia conservada:** esta ADR complementa ADR-009 y no sustituye ADR-001–ADR-009. Se mantienen Monolito Modular, Presentación, Aplicación, Dominio e Infraestructura y ocho módulos funcionales, con dependencias hacia el núcleo. Las modalidades y reglas de adelanto y saldo exclusivamente simulados no cambian; no hay integraciones financieras reales. WhatsApp sigue como redirección externa y no se decide proveedor, frontera ni mecanismo de mapas. RN-13 permanece aprobada, PC-05 continúa abierto y Redis/RabbitMQ no resuelven su garantía concurrente; RF13 y PC-01–PC-12 mantienen sus estados anteriores.

**Actualización documental posterior:** consolidar el [catálogo ADR](../07-decisiones-arquitectonicas.md) y actualizar [C2](../../04-modelo-c4/02-contenedores-c2.md) para reflejar la arquitectura objetivo adoptada de cinco contenedores: Aplicación Web, Backend UrbanPulse, Base de datos relacional, Redis y RabbitMQ. [C3](../../04-modelo-c4/03-componentes-c3.md) deberá incorporar responsabilidades técnicas de caché e invalidación manteniendo ocho módulos, y el Diseño Interno y futuro C4 deberán precisar puertos, adaptadores y contratos cuando se aprueben. No se añade balanceador ni worker independiente. C1 no requiere modificación. C2 conserva actualmente tres contenedores y C3 aún no incorpora esta decisión: es un desfase documental identificado para otra tarea autorizada, no una revocación del alcance aprobado aquí. Los desfases previos de capas y referencias gráficas ya señalados permanecen registrados; rige ADR-002 sin modificar sus fuentes en este cierre.

**Evidencia y límites:** no existen pruebas ejecutadas ni implementación acreditada de Redis o de esta estrategia en la entrega. La comprobación documental no demuestra rendimiento, confidencialidad, consistencia fuerte, recuperación ni cumplimiento de EQ. Se actualiza exclusivamente esta ADR junto con ADR-011; catálogo, C1/C2/C3, Diseño Interno, reglas, README y código permanecen sin modificación.

**URBANPULSE — ADR-010 APROBADA CONCEPTUALMENTE — CIERRE DOCUMENTAL COMPLETADO — SIN COMMIT NI PUSH.**
