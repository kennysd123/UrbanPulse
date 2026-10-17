# Decisiones Arquitectónicas

Las decisiones arquitectónicas definen las principales soluciones
adoptadas para responder a los drivers arquitectónicos identificados
en UrbanPulse.

**Estado de esta actualización:** aprobada conceptualmente y cerrada documentalmente. Fecha de actualización: 16/10/2026. Implementación y verificaciones técnicas pendientes.

El catálogo consolidado identifica **once decisiones: ADR-001–ADR-011**. ADR-001–ADR-009 conservan íntegramente su contenido y estado de adoptadas. ADR-010 y ADR-011 se incorporan como **aprobadas conceptualmente y cerradas documentalmente, con implementación y mecanismos operativos pendientes**, según sus documentos independientes y registros de cierre comprobados directamente. La consolidación no constituye una nueva aprobación ni acredita implementación, despliegue o pruebas. Las referencias a «nueve ADR» en las secciones históricas 2 y 4 delimitan la base ADR-001–ADR-009; no expresan el total actual del catálogo.

| ID | Decisión arquitectónica | Driver relacionado | Justificación | Resultado |
|---|---|---|---|---|
| **ADR-001** | **Monolito modular** | **DA01 - Modalidades de reserva; DA03 - Extensibilidad** | Organizar las funcionalidades de UrbanPulse en módulos independientes dentro de una misma aplicación desplegable, evitando inicialmente la complejidad de múltiples servicios. | Módulos de Usuarios, Establecimientos, Recursos, Disponibilidad, Reservas, Solicitudes, Servicios y Pagos. |
| **ADR-002** | **Clean Architecture** | **DA03 - Extensibilidad; DA05 - Seguridad; DA06 - Integraciones externas** | Separar las reglas del negocio de los detalles tecnológicos y de los servicios externos. | Capas de Presentación, Aplicación, Dominio e Infraestructura. |
| **ADR-003** | **Separación de modalidades de reserva** | **DA01 - Modalidades de reserva; DA03 - Extensibilidad** | Las canchas, karaokes, salones y recreos poseen diferentes reglas para gestionar sus reservas, por lo que no deben depender de un único flujo rígido. | Reglas diferenciadas para cancha, karaoke, salón y recreo. |
| **ADR-004** | **Gestión centralizada de disponibilidad y reservas** | **DA02 - Consistencia** | Centralizar la verificación de disponibilidad antes de confirmar una reserva para evitar reservas incompatibles sobre un mismo recurso o fecha. | Control de disponibilidad integrado al proceso de confirmación de reservas. |
| **ADR-005** | **API REST** | **DA07 - Comunicación mediante API REST** | Separar la aplicación web de la lógica de negocio mediante una interfaz de comunicación definida. | API REST para usuarios, establecimientos, disponibilidad, reservas, solicitudes y pagos. |
| **ADR-006** | **Integración mediante interfaces y adaptadores** | **DA06 - Integraciones externas** | Desacoplar las reglas de UrbanPulse de proveedores externos como mapas, WhatsApp y el servicio de pago simulado. | Interfaces y adaptadores para servicios externos. |
| **ADR-007** | **Autenticación y autorización por roles** | **DA05 - Seguridad** | Diferenciar las operaciones permitidas para clientes, propietarios y administradores. | Control de acceso según rol del usuario. |
| **ADR-008** | **Persistencia mediante repositorios** | **DA08 - Persistencia** | Separar las reglas del negocio de la implementación concreta de la base de datos. | Interfaces de repositorio e implementaciones de persistencia. |
| **ADR-009** | **Optimización de consultas de disponibilidad** | **DA04 - Rendimiento** | Reducir consultas innecesarias y organizar el acceso a la información utilizada para determinar la disponibilidad. | Consultas optimizadas sobre establecimientos, recursos, fechas y horarios. |
| **ADR-010** | **[Estrategia de caché con Redis](adr/ADR-010-cache-redis.md)** | Relación complementaria con DA04; límites de DA02/DA05. No amplía los orígenes de los drivers. | Optimizar consultas públicas repetidas mediante copias reconstruibles, complementando ADR-009. | Aprobada conceptualmente y cerrada documentalmente: Redis/cache-aside para fichas públicas, base relacional definitiva y fallback; mecanismos operativos pendientes. |
| **ADR-011** | **[Mensajería asíncrona con RabbitMQ](adr/ADR-011-mensajeria-rabbitmq.md)** | Contexto de DA04 por ADR-010; apoyo de desacoplamiento de ADR-002/ADR-006 y límites de DA05. Sin nuevo driver de origen. | Transportar asíncronamente eventos técnicos de invalidación de fichas públicas según la arquitectura objetivo académica. | Aprobada conceptualmente y cerrada documentalmente: RabbitMQ con consumidor técnico interno, sin worker independiente ni módulo funcional adicional; publicación y recuperación pendientes. |

---

## 1. Resumen de las decisiones

Las decisiones arquitectónicas más importantes para UrbanPulse son:

### ADR-001 — Monolito modular

UrbanPulse se desarrollará inicialmente como una única aplicación
desplegable, organizada internamente mediante módulos con
responsabilidades claramente definidas.

Esta decisión permite mantener una solución sencilla de desarrollar y
desplegar, evitando introducir inicialmente la complejidad de una
arquitectura distribuida.

---

### ADR-002 — Clean Architecture

Se utilizará Clean Architecture para separar las reglas principales
del negocio de los detalles tecnológicos.

La estructura inicial será:

```text
┌──────────────────────────────┐
│        PRESENTACIÓN          │
├──────────────────────────────┤
│         APLICACIÓN           │
├──────────────────────────────┤
│           DOMINIO            │
├──────────────────────────────┤
│       INFRAESTRUCTURA        │
└──────────────────────────────┘
```

Esta enumeración de capas es la representación oficial. Dominio no depende de Infraestructura. Infraestructura implementa los contratos definidos hacia el núcleo; las dependencias de código se orientan hacia ese núcleo. El flujo de ejecución puede utilizar esas implementaciones a través de contratos y no debe confundirse con la dirección de las dependencias de código.

---

### ADR-003 — Separación de modalidades de reserva

Las modalidades de reserva se manejarán según las características de\
cada establecimiento:

| Tipo de establecimiento | Modalidad                                   |
| ----------------------- | ------------------------------------------- |
| **Cancha de gras**      | Bloque horario                              |
| **Karaoke**             | Sala + tiempo                               |
| **Salón de eventos**    | Fecha + servicios + coordinación + adelanto |
| **Recreo**              | Fecha + servicios + coordinación + adelanto |

Esta decisión permite que las reglas particulares de cada modalidad no\
se mezclen innecesariamente.

Las [decisiones funcionales DF-01–DF-06](05-restricciones.md#3-decisiones-funcionales-aprobadas-y-alcance-del-mvp) precisan las modalidades: en recreos se reserva un ambiente o espacio definido por el propietario; canchas y karaoke utilizan confirmación directa con disponibilidad verificada y con adelanto simulado obligatorio y disponibilidad válida al confirmar. Los eventos conservan su proceso de cotización, condiciones y aceptación interna antes de confirmar, sin crear una ADR adicional.

---

### ADR-004 — Gestión centralizada de disponibilidad y reservas

La disponibilidad será verificada antes de confirmar una reserva.
```
Solicitud
    ↓
Consultar disponibilidad
    ↓
¿Disponible?
   ├── Sí → Verificar las demás condiciones antes de confirmar
   └── No → Rechazar
```

Esta decisión responde directamente al problema de evitar reservas incompatibles.

El flujo representa solo la comprobación de disponibilidad. Según DF-02/DF-03, para salones y recreos el propietario registra cotización y condiciones y el cliente las acepta dentro de UrbanPulse. Confirmar exige conjuntamente condiciones aceptadas, adelanto simulado aprobado y disponibilidad verificada (HU05, HU08, HU09; RF07, RF10–RF12, RF18 y RF19). Disponibilidad o pago aprobado por sí solos no autorizan la confirmación. La cobertura explícita del registro y aceptación de DF-02 en HU/RF permanece pendiente de formalización.

La centralización no define todavía el mecanismo que garantiza la consistencia ante solicitudes concurrentes. El diseño de esa garantía queda pendiente, sin seleccionar una tecnología.

---

### ADR-005 — API REST

La aplicación web se comunicará con el backend mediante una API REST.
```
Aplicación Web
      │
      ▼
   API REST
      │
      ▼
Lógica de negocio
      │
      ▼
Persistencia
```

---

### ADR-006 — Interfaces y adaptadores

Las integraciones externas se mantendrán separadas del núcleo de\
UrbanPulse.
```
              URBANPULSE
                   │
       ┌───────────┼───────────┐
       ▼           ▼           ▼
     Mapas      WhatsApp    Pago simulado
```

El proveedor de mapas todavía queda pendiente de decisión.

WhatsApp únicamente se utilizará para redirigir al cliente hacia el\
propietario.

El pago será simulado durante el MVP.

El pago es un sistema externo conceptual en la representación de integraciones. UrbanPulse implementa durante el MVP el componente de simulación que satisface la abstracción de integración; no se conecta con una pasarela financiera real ni requiere que ese componente sea un sistema externo desplegado. La interfaz conserva el desacoplamiento de las reglas del negocio. Esta aclaración no acredita implementación ni pruebas ejecutadas y no selecciona proveedores.

---

### ADR-007 — Autenticación y autorización por roles

Se diferenciarán los permisos de:

- Cliente.
- Propietario.
- Administrador.
```
Cliente
   ↓
Sus operaciones

Propietario
   ↓
Su establecimiento

Administrador
   ↓
Gestión de establecimientos (HU11 / RF15)
```

La autorización por roles limita las operaciones respaldadas por HU y RF; no incorpora administración de usuarios para el administrador. Su alcance funcional confirmado corresponde a HU11 → RF15.

---

### ADR-008 — Persistencia mediante repositorios

El acceso a los datos se realizará mediante abstracciones de\
repositorio.

Esto permitirá mantener las reglas del negocio independientes de la\
implementación específica de la base de datos.

---

### ADR-009 — Optimización de consultas de disponibilidad

Las consultas de disponibilidad serán diseñadas para acceder de forma\
eficiente a la información necesaria.

Se considerarán principalmente:

- Establecimiento.
- Recurso.
- Fecha.
- Horario.
- Estado de disponibilidad.

No se establece todavía una tecnología específica de caché.

---

### ADR-010 — Estrategia de caché con Redis

**Estado:** aprobada conceptualmente — cerrada documentalmente — implementación y mecanismos operativos pendientes. La fuente de alcance y condiciones es [ADR-010 y su registro de cierre](adr/ADR-010-cache-redis.md#registro-de-cierre-conceptual).

Se adopta **Redis**, con estrategia **cache-aside**, exclusivamente para caché de **fichas públicas de establecimientos** en la arquitectura objetivo del MVP. El objetivo es optimizar consultas públicas repetidas; la reducción de consultas y la mejora de latencia son beneficios potenciales, sin resultados medidos. La base relacional conserva la persistencia definitiva; Redis contiene copias reconstruibles y la consulta recurre a persistencia como fallback ante fallos de Redis, sin garantizar continuidad si también falla la base.

Quedan excluidos inicialmente disponibilidad, reservas, aceptación contractual, adelantos, saldos y datos protegidos. Los permisos cacheados no constituyen autoridad. Las búsquedas públicas son una ampliación futura condicionada a evaluación y aprobación. Los precios informativos de una ficha no sustituyen importes autorizados y fijados al iniciar la simulación (DP-03), ni condiciones aceptadas por el cliente.

Persisten los riesgos de obsolescencia, invalidación retrasada o perdida, repoblación concurrente con datos antiguos, eventos fuera de orden y cambios de visibilidad pública. La retirada de visibilidad requiere una política que impida divulgar información ya no autorizada: la invalidación asíncrona y un TTL genérico no bastan por sí solos como garantía de confidencialidad. No se afirma consistencia fuerte de las fichas sin mecanismo demostrado.

**Pendientes:** TTL, claves y proyección pública, cobertura de invalidación, versionado o generaciones, clientes y bibliotecas, capacidad y evicción, fronteras de puertos/adaptadores, seguridad operativa y métricas/pruebas. No se seleccionan mecanismos concretos por esta consolidación.

ADR-010 **complementa y no sustituye ADR-009**. La redacción original de ADR-009 conserva su alcance de optimización de consultas de disponibilidad y no representa aprobación histórica de Redis. La caché no resuelve RN-13 ni PC-05. Puede funcionar sin RabbitMQ y atender consultas cacheadas sin pasar por el broker; ADR-011 adopta el transporte asíncrono de invalidación para la solución conjunta, sin dependencia circular de aprobación.

---

### ADR-011 — Mensajería asíncrona con RabbitMQ

**Estado:** aprobada conceptualmente — cerrada documentalmente — implementación y mecanismos operativos pendientes. La fuente de alcance y condiciones es [ADR-011 y su registro de cierre](adr/ADR-011-mensajeria-rabbitmq.md#registro-de-cierre-conceptual).

Se adopta **RabbitMQ** como broker para el **transporte asíncrono de eventos técnicos de invalidación de caché pública**. Los productores son casos de uso existentes que modifican información pública autorizada incluida en las fichas. Publican mediante puertos internos con adaptadores en Infraestructura; el consumidor es un componente técnico **dentro del Backend UrbanPulse**, que solicita invalidación por la frontera autorizada. No hay worker independiente ni módulo de negocio adicional. El reparto exacto entre Establecimientos, Recursos y Servicios depende de su responsabilidad y de los campos de la proyección pública; no se atribuyen productores a todos los módulos.

El procesamiento **idempotente** es requisito de diseño; la **entrega al menos una vez** es un objetivo condicionado a garantías concretas de publicación, conservación y recuperación. El ACK se exige después de completar el efecto requerido; su configuración, los publisher confirms y el tratamiento de resultados inciertos, duplicados, reintentos limitados y mensajes fallidos deben concretarse. No se promete entrega exactamente una vez ni recuperación de intenciones nunca conservadas.

**Pendientes:** contratos y esquemas de mensajes, colas, exchanges, enrutamiento, durabilidad, publisher confirms y ACK, idempotencia concreta, duplicados, reintentos y sus tiempos, DLQ, recuperación, supervisión, métricas y seguridad. No se adoptan nombres, bibliotecas ni configuraciones operativas.

Permanece abierta la selección entre **publicación directa posterior al commit**, con riesgo de pérdida de la intención o resultado incierto, y **Transactional Outbox**, alternativa con conservación de la intención y complejidad adicional, **no adoptada**. RabbitMQ no garantiza atomicidad con la base relacional. Debe seleccionarse, diseñarse y validarse publicación y recuperación antes de afirmar invalidación fiable frente a fallos; TTL no sustituye entrega fiable ni conservación de intención.

ADR-002/ADR-006 aportan el criterio de desacoplamiento mediante contratos y adaptadores; **ADR-006 no había aprobado RabbitMQ desde el inicio**. Esta adopción corresponde a ADR-011. Los mensajes técnicos no cambian estados de Reserva, resultado del adelanto ni registro del saldo y no sustituyen evidencia obligatoria, aceptación interna o confirmación.

## 2. Estado y consecuencias de las decisiones existentes

Las nueve ADR se mantienen como decisiones adoptadas en la documentación existente. Su estado no acredita implementación ni validación técnica. Las consecuencias siguientes se derivan de su contenido y no seleccionan tecnologías.

| ADR | Estado documental | Consecuencia derivada y límite pendiente |
|---|---|---|
| ADR-001 | Adoptada | Mantener una aplicación desplegable con responsabilidades modulares; concretar límites y dependencias internas posteriormente. |
| ADR-002 | Adoptada | Separar Presentación, Aplicación, Dominio e Infraestructura y orientar las dependencias hacia el núcleo; precisar su aplicación por módulo en el diseño. |
| ADR-003 | Adoptada | Mantener reglas distintas por modalidad; no imponer un flujo único de reserva. |
| ADR-004 | Adoptada | Integrar la comprobación de disponibilidad en la confirmación; falta concretar la garantía ante concurrencia y no se omiten las demás condiciones. |
| ADR-005 | Adoptada | Comunicar la aplicación web y el backend mediante API REST; contratos y endpoints detallados permanecen pendientes. |
| ADR-006 | Adoptada | Acceder a integraciones mediante interfaces/adaptadores; mapas sin proveedor seleccionado, WhatsApp solo como redirección y pago simulado durante el MVP. |
| ADR-007 | Adoptada | Aplicar permisos por rol sobre las operaciones respaldadas; los mecanismos concretos de autenticación y autorización permanecen pendientes. |
| ADR-008 | Adoptada | Separar contratos de repositorio e implementaciones de persistencia; no fija un producto de base de datos. |
| ADR-009 | Adoptada | Diseñar consultas eficientes de disponibilidad; no fija métricas, caché ni otra tecnología. Su evaluación depende de la precisión posterior de AC01. |
| ADR-010 | Aprobada conceptualmente y cerrada documentalmente | Redis/cache-aside para fichas públicas con fallback y base relacional definitiva; diseño operativo, confidencialidad al retirar visibilidad y validación pendientes. |
| ADR-011 | Aprobada conceptualmente y cerrada documentalmente | RabbitMQ para invalidación técnica asíncrona con consumidor interno; garantías de publicación/recuperación, contratos y operación pendientes; Outbox no adoptado. |

Los drivers de origen se conservan en la tabla inicial y se desarrollan en [06-driver-arquitectonicos](06-driver-arquitectonicos.md). Los atributos y restricciones se consultan en [04-atributos-de-calidad](04-atributos-de-calidad.md) y [05-restricciones](05-restricciones.md). Las limitaciones HU → RF y RF → driver están explicitadas en [03-requisitos-funcionales](03-requisitos-funcionales.md); no se incorporan decisiones para completar relaciones sin respaldo.

## 3. Representaciones existentes pendientes de corrección

Se conservan los PNG y el SVG sin modificación; los documentos de arquitectura se armonizan en esta revisión. Los siguientes detalles no constituyen decisiones confirmadas y deben interpretarse según las aclaraciones de esta base documental:

| Representación | Información contradictoria o insuficientemente respaldada | Criterio vigente |
|---|---|---|
| [Estilo arquitectónico](../diagramas/estilo-arquitectonico.png) | Tres capas sin correspondencia explícita con Clean Architecture; PostgreSQL, archivos `.js`, puerto 5432, nombre de base de datos y ruta de API sin decisión que los respalde; administrador con gestión de usuarios y cancelación representada como función consolidada. | Monolito Modular con las cuatro capas de ADR-002. Tecnología concreta y contratos detallados pendientes. Administrador limitado al alcance HU11 → RF15; RF13 pendiente de validación. |
| [Enfoque arquitectónico](../diagramas/enfoque-arquitectonico.png) | Node.js / Express, puerto 5432, nombre de base de datos y ruta de API sin decisión que los respalde; administrador con gestión de usuarios; cancelación representada como función consolidada. | Mantener las cuatro capas, interfaces y adaptadores. No asumir tecnologías. RF13 pendiente; gestión de usuarios no respaldada. |
| [Arquitectura inicial](../diagramas/arquitectura%20inicial.png) | Tres capas sin correspondencia explícita con las cuatro oficiales; no distingue suficientemente dependencias de código y flujo de ejecución. | Interpretar la separación según ADR-002, sin asumir dependencia de Dominio hacia Infraestructura. |
| [Matriz HU → RF](../diagramas/Matriz%20de%20trazabilidad%20HU%20%E2%86%92%20RF.png) | No distingue el carácter contextual de HU03 → RF04 y HU04 → RF06. | Consultar las aclaraciones de cobertura en [03-requisitos-funcionales](03-requisitos-funcionales.md). |

Google Maps aparece como ejemplo en las imágenes de estilo y enfoque; no se considera proveedor seleccionado. Las etiquetas de protocolos o implementación de los PNG no sustituyen una decisión documentada.

Los documentos de arquitectura ya explicitan las cuatro capas, las dependencias hacia el núcleo y la exclusión de RF13. Las imágenes conservadas siguen sujetas al [inventario de sincronización](../diagramas/INVENTARIO-PENDIENTES.md); no se crean vistas C4.

## 4. Consecuencias de DF-04–DF-06 y DP-01–DP-12

| ADR existente | Precisión sin nueva decisión tecnológica |
|---|---|
| ADR-003 | Cancha/karaoke mantienen reserva directa con adelanto simulado obligatorio y disponibilidad válida. Eventos conservan solicitud, cotización y aceptación. |
| ADR-004 | Confirmación exige disponibilidad válida y adelanto aprobado, más aceptación en eventos; no basta resultado del simulador. Mantener prohibición concurrente; mecanismo pendiente. |
| ADR-006 | Simulador desacoplado de reglas; métodos informativos y recepción manual sin integración financiera real. |
| ADR-007 | HU14/RF20 exige propietario autorizado de reserva confirmada propia; RF14 permite resumen autorizado de cliente/propietario. Autor y fecha también en correcciones. |
| ADR-008 | Persistir conceptualmente importes fijados al iniciar, adelanto aplicado, saldo y registro único activo con historial; contratos y modelo de datos pendientes. |

Se conserva íntegramente el contenido histórico de ADR-001–ADR-009. El catálogo vigente comprende once decisiones, incluyendo ADR-010 y ADR-011. Las ampliaciones de origen DA05/DA08 están explicitadas en la sección 7 de drivers; no se aprueba algoritmo de concurrencia, motor, tablas o endpoints. RF13 sigue pendiente. El SVG de enfoque aún muestra “cancelar” y su referencia se advierte en arquitectura, sin modificar el archivo.

## 5. Trazabilidad de ADR-010 y ADR-011

Las relaciones siguientes consolidan lo documentado en ambas ADR independientes y se contrastan con [atributos AC](04-atributos-de-calidad.md), [drivers DA](06-driver-arquitectonicos.md), [HU/RF](03-requisitos-funcionales.md), [restricciones RC/DF/DP](05-restricciones.md) y [reglas RN y pendientes PC](../03-diseño-software/01-reglas-de-negocio.md). Se diferencian procedencia explícita, contexto funcional, consecuencias derivadas y propuestas pendientes, sin crear cadenas de origen nuevas.

| Tipo de relación | Evidencia existente | Aplicación a las nuevas decisiones y límite |
|---|---|---|
| Explícita anterior | AC01 y RF01/RF03/RF05 → DA04 → ADR-009. HU01 → RF01. | Contexto de rendimiento; ADR-010 aporta una respuesta complementaria para fichas públicas repetidas. No se convierten RF03/RF05 en alcance de caché de disponibilidad ni se añade origen DA04 → ADR-010/ADR-011 a las fuentes anteriores. |
| Contexto funcional | HU02 → RF02 para consultar información; HU06 → RF08 para gestionar oferta; HU07 → RF09 para configuración; HU11 → RF15 para gestión administrativa de establecimientos. | Consultas y cambios de campos públicos sustentan el caso técnico de caché/invalidación, sin nuevos requisitos de negocio. RF02/RF09/RF10 siguen sin origen explícito en drivers. RF08/RF15 son origen de DA05 por seguridad, sin atribuirles origen DA04. |
| Explícita anterior y límite de seguridad | AC04 y RF08/RF15, entre otros RF de origen, → DA05 → ADR-007; ADR-002 también se relaciona con DA05. | Redis y RabbitMQ deben respetar autorización y visibilidad. La condición de retirada de publicación es obligatoria; sus controles concretos quedan por diseñar y validar, no aprobados por analogía. |
| Explícita anterior y límite de consistencia | AC03 y RF04/RF06/RF12 → DA02 → ADR-004; RN-13 aprobada, PC-05 abierto. | Ni la caché ni los mensajes garantizan confirmaciones compatibles. HU03/RF04 y HU04/RF06 conservan su asociación contextual; no se resuelven concurrencia o disponibilidad durante coordinación. |
| Contexto de mantenibilidad y desacoplamiento | AC05/AC08 → DA06 → ADR-002/ADR-006, para las integraciones ya documentadas; ADR-001/ADR-002 establecen modularidad y capas. | Puertos y adaptadores orientan la incorporación técnica. No se afirma que DA06 exigiera RabbitMQ ni se amplía el origen funcional a un broker o a mensajería entre usuarios. |
| Persistencia y límites funcionales | RC04 → DA08 → ADR-008; RC03 → DA07 → ADR-005; DF-01–DF-06 y DP-01–DP-12. | La base relacional continúa definitiva, con repositorios y API REST web–backend. Copias y eventos no reemplazan evidencia de aceptación, importes fijados, adelantos ni saldo simulado. AC03/AC05 en DA08 y AC05/AC08 en DA07 son relaciones complementarias, no nuevos orígenes. |
| Consecuencias derivadas del alcance aprobado | Registros de cierre conceptual de ADR-010 y ADR-011; responsabilidades existentes de Establecimientos, Recursos y Servicios en C3. | Añadir dos contenedores de apoyo y un consumidor técnico interno conserva ocho módulos. El ámbito de cada productor depende de campos públicos afectados; la composición de la ficha y sus contratos no se deducen de una asociación de datos. |
| Propuestas técnicas pendientes | TTL, claves, evicción, versiones/generaciones; publicación directa u Outbox; contratos, ACK/confirms, reintentos, DLQ y seguridad operativa. | Son mecanismos por decidir o concretar según cada ADR. El requisito de idempotencia y el ACK posterior al efecto no acreditan mecanismos implementados. |

AC02 y AC07 conservan ausencia de driver y respuesta arquitectónica explícitos en la base documental; no se completa esa cobertura por atribuir beneficios al fallback o al broker. Los [escenarios EQ](08-escenarios-atributos-calidad.md) mantienen procedimientos y métricas pendientes de revisión; no hay pruebas ejecutadas ni cumplimiento acreditado de Redis/RabbitMQ. La necesidad académica de la alternativa A3 procede de las ADR independientes y sus cierres, sin inventar HU, RF, AC o DA para registrarla.

## 6. Evolución arquitectónica y reconciliación documental pendiente

**Arquitectura base C2:** tres contenedores, según el [C2 actual](../04-modelo-c4/02-contenedores-c2.md): Aplicación Web, Backend UrbanPulse y Base de datos relacional.

**Arquitectura objetivo con ADR-010 y ADR-011:** cinco contenedores:

1. Aplicación Web.
2. Backend UrbanPulse.
3. Base de datos relacional.
4. Redis.
5. RabbitMQ.

La arquitectura objetivo acotada está aprobada conceptualmente; no se declara infraestructura implementada o desplegada. Redis contiene copias públicas reconstruibles y RabbitMQ transporta invalidaciones técnicas; la base relacional conserva la autoridad definitiva. No se agregan Nginx, balanceador de carga ni worker independiente. El backend sigue siendo Monolito Modular, no un conjunto de microservicios.

**C2 y C3 todavía no se han actualizado.** Su reconciliación se realizará en tareas posteriores autorizadas: C2 deberá representar los cinco contenedores; [C3](../04-modelo-c4/03-componentes-c3.md) deberá incorporar productores pertinentes, puertos, adaptadores y consumidor técnico interno preservando los ocho módulos de ADR-001. C3 conserva su estado de pendiente de auditoría; incorporar estas decisiones al catálogo no aprueba su representación ni sus contratos. [C1](../04-modelo-c4/01-contexto-c1.md) no requiere modificación para este alcance. Los contratos y mecanismos del Diseño Interno y futuro C4 siguen sujetos a diseño y aprobación posteriores; no se crea ni modifica ningún diagrama en esta actualización.

Se mantienen Presentación, Aplicación, Dominio e Infraestructura con dependencias hacia el núcleo (ADR-002), API REST web–backend, repositorios y persistencia relacional definitiva, sin elegir motor. Se conservan ocho módulos funcionales, modalidades directas y de evento, aceptación interna del cliente e importes fijados al iniciar la simulación. Adelantos y saldo siguen exclusivamente simulados; los mensajes técnicos no alteran sus reglas ni estados. WhatsApp sigue como redirección externa; proveedor, frontera y mecanismo de mapas continúan pendientes.

RN-13 permanece aprobada y **PC-05 continúa abierto**: Redis/RabbitMQ no resuelven la garantía de concurrencia. RF13 y PC-01–PC-12 mantienen sus estados y límites anteriores; no se reabren fórmula ni registro manual completo del saldo, ya aprobados. No se habilitan cancelación, devolución, expiración de reservas, reapertura, pagos reales ni ampliaciones funcionales por esta consolidación.

**Desfases conservados:** la afirmación previa de armonización de la sección 3 no coincide con el texto de tres capas de arquitectura inicial; rige ADR-002 y sus cuatro capas. Los enlaces gráficos históricos de arquitectura inicial y matriz HU/RF ya señalados como desactualizados se conservan sin corregir su contenido. Las menciones de nueve decisiones, de ausencia de selección de caché en ADR-009 y de consolidación futura en los cierres independientes corresponden a sus respectivos antecedentes: esta actualización incorpora las dos decisiones posteriores sin atribuirlas a aprobaciones históricas ni modificar sus fuentes. La revisión de esta consolidación concluye con aprobación conceptual y cierre documental tras auditoría favorable; no reabre la aprobación conceptual de ADR-010/ADR-011 ni acredita implementación o pruebas.

**URBANPULSE — CATÁLOGO ADR-001–ADR-011 APROBADO CONCEPTUALMENTE — CIERRE DOCUMENTAL COMPLETADO — SIN COMMIT NI PUSH.**
