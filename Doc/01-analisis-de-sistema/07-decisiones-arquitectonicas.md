# Decisiones Arquitectónicas

**Revisión de alcance financiero — 07/11/2026:** las decisiones funcionales de pagos reales sustituyen la exclusividad de simulación del MVP. Pago requerido significa pago total o adelanto configurado, verificado por el backend y aplicado una sola vez a la reserva. El proveedor sigue pendiente de validación; véanse [restricciones](05-restricciones.md) y [ADR-012](adr/ADR-012-modelo-pagos-mvp.md). No se acredita implementación ni aprobación de la integración de producción.

Las decisiones arquitectónicas definen las principales soluciones
adoptadas para responder a los drivers arquitectónicos identificados
en UrbanPulse.

**Estado histórico:** catálogo ADR-001–ADR-011 aprobado conceptualmente y cerrado documentalmente el 16/10/2026. **Revisión del 07/11/2026:** alcance funcional financiero establecido por solicitud; ADR-012 propuesta y proveedor candidato pendientes de validación/aprobación de producción. No se extiende el cierre histórico a esta propuesta.

El catálogo consolidado identifica **doce registros: ADR-001–ADR-012**. ADR-001–ADR-009 conservan sus decisiones estructurales adoptadas; el supuesto financiero simulado de ADR-006 y las precisiones de adelanto evolucionan conforme al registro de sustitución de RC07/DF/DP y ADR-012, sin atribuir pagos reales a su aprobación histórica. ADR-010 y ADR-011 se incorporan como **aprobadas conceptualmente y cerradas documentalmente, con implementación y mecanismos operativos pendientes**, según sus documentos independientes y registros de cierre comprobados directamente. La consolidación no constituye una nueva aprobación ni acredita implementación, despliegue o pruebas. Las referencias a «nueve ADR» en las secciones históricas 2 y 4 delimitan la base ADR-001–ADR-009; no expresan el total actual del catálogo.

| ID | Decisión arquitectónica | Driver relacionado | Justificación | Resultado |
|---|---|---|---|---|
| **ADR-001** | **Monolito modular** | **DA01 - Modalidades de reserva; DA03 - Extensibilidad** | Organizar las funcionalidades de UrbanPulse en módulos independientes dentro de una misma aplicación desplegable, evitando inicialmente la complejidad de múltiples servicios. | Módulos de Usuarios, Establecimientos, Recursos, Disponibilidad, Reservas, Solicitudes, Servicios y Pagos. |
| **ADR-002** | **Clean Architecture** | **DA03 - Extensibilidad; DA05 - Seguridad; DA06 - Integraciones externas** | Separar las reglas del negocio de los detalles tecnológicos y de los servicios externos. | Capas de Presentación, Aplicación, Dominio e Infraestructura. |
| **ADR-003** | **Separación de modalidades de reserva** | **DA01 - Modalidades de reserva; DA03 - Extensibilidad** | Las canchas, karaokes, salones y recreos poseen diferentes reglas para gestionar sus reservas, por lo que no deben depender de un único flujo rígido. | Reglas diferenciadas para cancha, karaoke, salón y recreo. |
| **ADR-004** | **Gestión centralizada de disponibilidad y reservas** | **DA02 - Consistencia** | Centralizar la verificación de disponibilidad antes de confirmar una reserva para evitar reservas incompatibles sobre un mismo recurso o fecha. | Control de disponibilidad integrado al proceso de confirmación de reservas. |
| **ADR-005** | **API REST** | **DA07 - Comunicación mediante API REST** | Separar la aplicación web de la lógica de negocio mediante una interfaz de comunicación definida. | API REST para usuarios, establecimientos, disponibilidad, reservas, solicitudes y pagos. |
| **ADR-006** | **Integración mediante interfaces y adaptadores** | **DA06 - Integraciones externas** | Desacoplar las reglas de UrbanPulse de proveedores externos como mapas, WhatsApp y el proveedor de pago electrónico. | Interfaces y adaptadores para servicios externos. |
| **ADR-007** | **Autenticación y autorización por roles** | **DA05 - Seguridad** | Diferenciar las operaciones permitidas para clientes, propietarios y administradores. | Control de acceso según rol del usuario. |
| **ADR-008** | **Persistencia mediante repositorios** | **DA08 - Persistencia** | Separar las reglas del negocio de la implementación concreta de la base de datos. | Interfaces de repositorio e implementaciones de persistencia. |
| **ADR-009** | **Optimización de consultas de disponibilidad** | **DA04 - Rendimiento** | Reducir consultas innecesarias y organizar el acceso a la información utilizada para determinar la disponibilidad. | Consultas optimizadas sobre establecimientos, recursos, fechas y horarios. |
| **ADR-010** | **[Estrategia de caché con Redis](adr/ADR-010-cache-redis.md)** | Relación complementaria con DA04; límites de DA02/DA05. No amplía los orígenes de los drivers. | Optimizar consultas públicas repetidas mediante copias reconstruibles, complementando ADR-009. | Aprobada conceptualmente y cerrada documentalmente: Redis/cache-aside para fichas públicas, base relacional definitiva y fallback; mecanismos operativos pendientes. |
| **ADR-011** | **[Mensajería asíncrona con RabbitMQ](adr/ADR-011-mensajeria-rabbitmq.md)** | Contexto de DA04 por ADR-010; apoyo de desacoplamiento de ADR-002/ADR-006 y límites de DA05. Sin nuevo driver de origen. | Transportar asíncronamente eventos técnicos de invalidación de fichas públicas según la arquitectura objetivo académica. | Aprobada conceptualmente y cerrada documentalmente: RabbitMQ con consumidor técnico interno, sin worker independiente obligatorio inicialmente ni módulo funcional adicional; extracción posterior preparada, publicación y recuperación pendientes. |
| **ADR-012** | **[Modelo de pagos del MVP y proveedor candidato](adr/ADR-012-modelo-pagos-mvp.md)** | DA02/DA06/DA08; DA05 como apoyo de autorización, sin alterar los orígenes RF existentes. | Separar pago, aplicación, confirmación y registro de saldo con verificación backend, idempotencia y trazabilidad. | Funcionalidad establecida; arquitectura propuesta; Mercado Pago Marketplace Split 1:1 candidato sin validación ni aprobación de producción. |

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
| **Salón de eventos**    | Fecha + servicios + coordinación + pago total o adelanto |
| **Recreo**              | Fecha + servicios + coordinación + pago total o adelanto |

Esta decisión permite que las reglas particulares de cada modalidad no\
se mezclen innecesariamente.

Las [decisiones funcionales DF-01–DF-06](05-restricciones.md#3-decisiones-funcionales-aprobadas-y-alcance-del-mvp) precisan las modalidades: en recreos se reserva un ambiente o espacio definido por el propietario; canchas y karaoke utilizan confirmación directa con disponibilidad verificada y con pago total o adelanto configurado y disponibilidad válida al confirmar. Los eventos conservan su proceso de cotización, condiciones y aceptación interna antes de confirmar; la evolución financiera se registra en ADR-012.

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

El flujo representa solo la comprobación de disponibilidad. Según DF-02/DF-03, para salones y recreos el propietario registra cotización y condiciones y el cliente las acepta dentro de UrbanPulse. Confirmar exige conjuntamente condiciones aceptadas, pago requerido verificado y aplicado y disponibilidad verificada (HU05, HU08, HU09; RF07, RF10–RF12, RF18 y RF19). Disponibilidad o pago aprobado por sí solos no autorizan la confirmación. La cobertura explícita del registro y aceptación de DF-02 en HU/RF permanece pendiente de formalización.

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
     Mapas      WhatsApp    Pago electrónico
```

El proveedor de mapas todavía queda pendiente de decisión.

WhatsApp únicamente se utilizará para redirigir al cliente hacia el\
propietario.

El supuesto histórico de pago exclusivamente simulado queda sustituido para el MVP objetivo por RC07/DF-06/DP-01 revisados el 07/11/2026. La decisión de interfaces y adaptadores permanece adoptada.

Los pagos electrónicos reales usan una integración financiera externa cuyo proveedor se verifica antes de aprobar producción. Mercado Pago Marketplace Split 1:1 es candidato. El backend valida resultados; navegador o notificación sin verificar no acreditan aprobación. ADR-012 propone separación entre operación, importe aplicado, Reserva y recepción posterior de saldo, sin afirmar implementación.

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

Quedan excluidos inicialmente disponibilidad, reservas, aceptación contractual, adelantos, saldos y datos protegidos. Los permisos cacheados no constituyen autoridad. Las búsquedas públicas son una ampliación futura condicionada a evaluación y aprobación. Los precios informativos de una ficha no sustituyen importes autorizados y fijados al iniciar la operación de pago (DP-03), ni condiciones aceptadas por el cliente.

Persisten los riesgos de obsolescencia, invalidación retrasada o perdida, repoblación concurrente con datos antiguos, eventos fuera de orden y cambios de visibilidad pública. La retirada de visibilidad requiere una política que impida divulgar información ya no autorizada: la invalidación asíncrona y un TTL genérico no bastan por sí solos como garantía de confidencialidad. No se afirma consistencia fuerte de las fichas sin mecanismo demostrado.

**Pendientes:** TTL, claves y proyección pública, cobertura de invalidación, versionado o generaciones, clientes y bibliotecas, capacidad y evicción, fronteras de puertos/adaptadores, seguridad operativa y métricas/pruebas. No se seleccionan mecanismos concretos por esta consolidación.

ADR-010 **complementa y no sustituye ADR-009**. La redacción original de ADR-009 conserva su alcance de optimización de consultas de disponibilidad y no representa aprobación histórica de Redis. La caché no resuelve RN-13 ni PC-05. Puede funcionar sin RabbitMQ y atender consultas cacheadas sin pasar por el broker; ADR-011 adopta el transporte asíncrono de invalidación para la solución conjunta, sin dependencia circular de aprobación.

---

### ADR-011 — Mensajería asíncrona con RabbitMQ

**Estado:** aprobada conceptualmente — cerrada documentalmente — implementación y mecanismos operativos pendientes. La fuente de alcance y condiciones es [ADR-011 y su registro de cierre](adr/ADR-011-mensajeria-rabbitmq.md#registro-de-cierre-conceptual).

Se adopta **RabbitMQ** como broker para el **transporte asíncrono de eventos técnicos de invalidación de caché pública**. Los productores son casos de uso existentes que modifican información pública autorizada incluida en las fichas. Publican mediante puertos internos con adaptadores en Infraestructura; el consumidor es un componente técnico **dentro del Backend UrbanPulse**, que solicita invalidación por la frontera autorizada. Durante el MVP no se exige worker independiente ni módulo de negocio adicional. Su estado posterior es **Preparado arquitectónicamente, no obligatorio inicialmente**; la extracción del consumidor técnico respetará puertos/adaptadores sin modificar dominio ni constituir microservicio. No se extiende ADR-011 a pagos o conciliación. El reparto exacto entre Establecimientos, Recursos y Servicios depende de su responsabilidad y de los campos de la proyección pública; no se atribuyen productores a todos los módulos.

El procesamiento **idempotente** es requisito de diseño; la **entrega al menos una vez** es un objetivo condicionado a garantías concretas de publicación, conservación y recuperación. El ACK se exige después de completar el efecto requerido; su configuración, los publisher confirms y el tratamiento de resultados inciertos, duplicados, reintentos limitados y mensajes fallidos deben concretarse. No se promete entrega exactamente una vez ni recuperación de intenciones nunca conservadas.

**Pendientes:** contratos y esquemas de mensajes, colas, exchanges, enrutamiento, durabilidad, publisher confirms y ACK, idempotencia concreta, duplicados, reintentos y sus tiempos, DLQ, recuperación, supervisión, métricas y seguridad. No se adoptan nombres, bibliotecas ni configuraciones operativas.

Permanece abierta la selección entre **publicación directa posterior al commit**, con riesgo de pérdida de la intención o resultado incierto, y **Transactional Outbox**, alternativa con conservación de la intención y complejidad adicional, **no adoptada**. RabbitMQ no garantiza atomicidad con la base relacional. Debe seleccionarse, diseñarse y validarse publicación y recuperación antes de afirmar invalidación fiable frente a fallos; TTL no sustituye entrega fiable ni conservación de intención.

ADR-002/ADR-006 aportan el criterio de desacoplamiento mediante contratos y adaptadores; **ADR-006 no había aprobado RabbitMQ desde el inicio**. Esta adopción corresponde a ADR-011. Los mensajes técnicos no cambian estados de Reserva, resultado del pago ni registro del saldo y no sustituyen evidencia obligatoria, aceptación interna o confirmación.

## 2. Estado y consecuencias de las decisiones existentes

Las nueve ADR se mantienen como decisiones adoptadas en la documentación existente. Su estado no acredita implementación ni validación técnica. Las consecuencias siguientes se derivan de su contenido y no seleccionan tecnologías.

| ADR | Estado documental | Consecuencia derivada y límite pendiente |
|---|---|---|
| ADR-001 | Adoptada | Mantener una aplicación desplegable con responsabilidades modulares; concretar límites y dependencias internas posteriormente. |
| ADR-002 | Adoptada | Separar Presentación, Aplicación, Dominio e Infraestructura y orientar las dependencias hacia el núcleo; precisar su aplicación por módulo en el diseño. |
| ADR-003 | Adoptada | Mantener reglas distintas por modalidad; no imponer un flujo único de reserva. |
| ADR-004 | Adoptada | Integrar la comprobación de disponibilidad en la confirmación; falta concretar la garantía ante concurrencia y no se omiten las demás condiciones. |
| ADR-005 | Adoptada | Comunicar la aplicación web y el backend mediante API REST; contratos y endpoints detallados permanecen pendientes. |
| ADR-006 | Adoptada | Acceder a integraciones mediante interfaces/adaptadores; mapas sin proveedor seleccionado, WhatsApp solo como redirección y pago real objetivo mediante candidato por validar; supuesto de simulación sustituido, manteniendo desacoplamiento (ADR-012). |
| ADR-007 | Adoptada | Aplicar permisos por rol sobre las operaciones respaldadas; los mecanismos concretos de autenticación y autorización permanecen pendientes. |
| ADR-008 | Adoptada | Separar contratos de repositorio e implementaciones de persistencia; no fija un producto de base de datos. |
| ADR-009 | Adoptada | Diseñar consultas eficientes de disponibilidad; no fija métricas, caché ni otra tecnología. Su evaluación depende de la precisión posterior de AC01. |
| ADR-010 | Aprobada conceptualmente y cerrada documentalmente | Redis/cache-aside para fichas públicas con fallback y base relacional definitiva; diseño operativo, confidencialidad al retirar visibilidad y validación pendientes. |
| ADR-011 | Aprobada conceptualmente y cerrada documentalmente | RabbitMQ para invalidación técnica asíncrona con consumidor interno; garantías de publicación/recuperación, contratos y operación pendientes; Outbox no adoptado. |

Los drivers de origen se conservan en la tabla inicial y se desarrollan en [06-driver-arquitectonicos](06-driver-arquitectonicos.md). Los atributos y restricciones se consultan en [04-atributos-de-calidad](04-atributos-de-calidad.md) y [05-restricciones](05-restricciones.md). Las limitaciones HU → RF y RF → driver están explicitadas en [03-requisitos-funcionales](03-requisitos-funcionales.md); no se incorporan decisiones para completar relaciones sin respaldo.

## 3. Representaciones existentes pendientes de corrección

Se conservan las imágenes sin modificación. Tarea 4 sincroniza README y los textos de Etapa 2 con las cuatro capas de ADR-002; las observaciones siguientes corresponden a los PNG históricos, que permanecen intactos. Los siguientes detalles no constituyen decisiones confirmadas y deben interpretarse según las aclaraciones de esta base documental:

| Representación | Información contradictoria o insuficientemente respaldada | Criterio vigente |
|---|---|---|
| [Estilo arquitectónico](../diagramas/estilo-arquitectonico.png) | Tres capas sin correspondencia explícita con Clean Architecture; PostgreSQL, archivos `.js`, puerto 5432, nombre de base de datos y ruta de API sin decisión que los respalde; administrador con gestión de usuarios y cancelación representada como función consolidada. | Monolito Modular con las cuatro capas de ADR-002. Tecnología concreta y contratos detallados pendientes. Administrador limitado al alcance HU11 → RF15; RF13 pendiente de validación. |
| [Enfoque arquitectónico](../diagramas/enfoque-arquitectonico.png) | Node.js / Express, puerto 5432, nombre de base de datos y ruta de API sin decisión que los respalde; administrador con gestión de usuarios; cancelación representada como función consolidada. | Mantener las cuatro capas, interfaces y adaptadores. No asumir tecnologías. RF13 pendiente; gestión de usuarios no respaldada. |
| [Arquitectura inicial](../diagramas/arquitectura-inicial.png) | Tres capas sin correspondencia explícita con las cuatro oficiales; no distingue suficientemente dependencias de código y flujo de ejecución. | Interpretar la separación según ADR-002, sin asumir dependencia de Dominio hacia Infraestructura. |
| [Matriz HU → RF](../diagramas/matriz-HU-→-RF.png) | No distingue el carácter contextual de HU03 → RF04 y HU04 → RF06. | Consultar las aclaraciones de cobertura en [03-requisitos-funcionales](03-requisitos-funcionales.md). |

Google Maps aparece como ejemplo en las imágenes de estilo y enfoque; no se considera proveedor seleccionado. Las etiquetas de protocolos o implementación de los PNG no sustituyen una decisión documentada.

Los textos de arquitectura inicial, estilo y enfoque explicitan ahora las cuatro capas oficiales. RF13 continúa pendiente y las referencias gráficas históricas no lo aprueban. Las imágenes requieren revisión posterior; el inventario auxiliar, cuando esté disponible, no constituye fuente normativa. No se crean vistas ni se afirma inspección visual de PNG en esta tarea.

## 4. Consecuencias de DF-04–DF-06 y DP-01–DP-12

| ADR existente | Precisión sin nueva decisión tecnológica |
|---|---|
| ADR-003 | Cancha/karaoke mantienen reserva directa con pago total o adelanto configurado y disponibilidad válida. Eventos conservan solicitud, cotización y aceptación. |
| ADR-004 | Confirmación exige disponibilidad válida y pago requerido verificado y aplicado, más aceptación en eventos; no basta aprobación del proveedor ni respuesta del navegador. Mantener prohibición concurrente; mecanismo pendiente. |
| ADR-006 | Integración desacoplada de reglas; supuesto simulado sustituido por pago real objetivo y candidato pendiente. Recepción manual posterior separada de verificación electrónica. |
| ADR-007 | HU14/RF20 exige propietario autorizado de reserva confirmada propia; RF14 permite resumen autorizado de cliente/propietario. Autor y fecha también en correcciones. |
| ADR-008 | Persistir conceptualmente importes fijados al iniciar, pago aplicado, saldo y registro único activo con historial; contratos y modelo de datos pendientes. |

Se conservan las decisiones estructurales de ADR-001–ADR-011 y se registra la sustitución del supuesto financiero anterior en restricciones y ADR-012. El catálogo contiene doce registros, con ADR-012 propuesta. Las ampliaciones de origen DA05/DA08 están explicitadas en la sección 7 de drivers; no se aprueba algoritmo de concurrencia, motor, tablas o endpoints. RF13 sigue pendiente. La advertencia histórica sobre “cancelar” en la representación de enfoque no constituye aprobación funcional ni evidencia de inspección visual en esta revisión.

## 5. Trazabilidad de ADR-010 y ADR-011

Las relaciones siguientes consolidan lo documentado en ambas ADR independientes y se contrastan con [atributos AC](04-atributos-de-calidad.md), [drivers DA](06-driver-arquitectonicos.md), [HU/RF](03-requisitos-funcionales.md), [restricciones RC/DF/DP](05-restricciones.md) y [reglas RN y pendientes PC](../03-diseño-software/01-reglas-de-negocio.md). Se diferencian procedencia explícita, contexto funcional, consecuencias derivadas y propuestas pendientes, sin crear cadenas de origen nuevas.

| Tipo de relación | Evidencia existente | Aplicación a las nuevas decisiones y límite |
|---|---|---|
| Explícita anterior | AC01 y RF01/RF03/RF05 → DA04 → ADR-009. HU01 → RF01. | Contexto de rendimiento; ADR-010 aporta una respuesta complementaria para fichas públicas repetidas. No se convierten RF03/RF05 en alcance de caché de disponibilidad ni se añade origen DA04 → ADR-010/ADR-011 a las fuentes anteriores. |
| Contexto funcional | HU02 → RF02 para consultar información; HU06 → RF08 para gestionar oferta; HU07 → RF09 para configuración; HU11 → RF15 para gestión administrativa de establecimientos. | Consultas y cambios de campos públicos sustentan el caso técnico de caché/invalidación, sin nuevos requisitos de negocio. RF02/RF09/RF10 siguen sin origen explícito en drivers. RF08/RF15 son origen de DA05 por seguridad, sin atribuirles origen DA04. |
| Explícita anterior y límite de seguridad | AC04 y RF08/RF15, entre otros RF de origen, → DA05 → ADR-007; ADR-002 también se relaciona con DA05. | Redis y RabbitMQ deben respetar autorización y visibilidad. La condición de retirada de publicación es obligatoria; sus controles concretos quedan por diseñar y validar, no aprobados por analogía. |
| Explícita anterior y límite de consistencia | AC03 y RF04/RF06/RF12 → DA02 → ADR-004; RN-13 aprobada, PC-05 abierto. | Ni la caché ni los mensajes garantizan confirmaciones compatibles. HU03/RF04 y HU04/RF06 conservan su asociación contextual; no se resuelven concurrencia o disponibilidad durante coordinación. |
| Contexto de mantenibilidad y desacoplamiento | AC05/AC08 → DA06 → ADR-002/ADR-006, para las integraciones ya documentadas; ADR-001/ADR-002 establecen modularidad y capas. | Puertos y adaptadores orientan la incorporación técnica. No se afirma que DA06 exigiera RabbitMQ ni se amplía el origen funcional a un broker o a mensajería entre usuarios. |
| Persistencia y límites funcionales | RC04 → DA08 → ADR-008; RC03 → DA07 → ADR-005; DF-01–DF-06 y DP-01–DP-12. | La base relacional continúa definitiva, con repositorios y API REST web–backend. Copias y eventos no reemplazan evidencia de aceptación, importes fijados, adelantos ni saldo y su registro posterior. AC03/AC05 en DA08 y AC05/AC08 en DA07 son relaciones complementarias, no nuevos orígenes. |
| Consecuencias derivadas del alcance aprobado | Registros de cierre conceptual de ADR-010 y ADR-011; responsabilidades existentes de Establecimientos, Recursos y Servicios en C3. | Añadir dos contenedores de apoyo y un consumidor técnico interno conserva ocho módulos. El ámbito de cada productor depende de campos públicos afectados; la composición de la ficha y sus contratos no se deducen de una asociación de datos. |
| Propuestas técnicas pendientes | TTL, claves, evicción, versiones/generaciones; publicación directa u Outbox; contratos, ACK/confirms, reintentos, DLQ y seguridad operativa. | Son mecanismos por decidir o concretar según cada ADR. El requisito de idempotencia y el ACK posterior al efecto no acreditan mecanismos implementados. |

AC02 y AC07 conservan ausencia de driver y respuesta arquitectónica explícitos en la base documental; no se completa esa cobertura por atribuir beneficios al fallback o al broker. Los [escenarios EQ](08-escenarios-atributos-calidad.md) mantienen procedimientos y métricas pendientes de revisión; no hay pruebas ejecutadas ni cumplimiento acreditado de Redis/RabbitMQ. La necesidad académica de la alternativa A3 procede de las ADR independientes y sus cierres, sin inventar HU, RF, AC o DA para registrarla.

## 6. Evolución arquitectónica y reconciliación documental pendiente

**Base histórica:** C2 tuvo tres contenedores. **Estado documental inspeccionado el 07/11/2026:** [C2](../04-modelo-c4/02-contenedores-c2.md) ya representa Aplicación Web, Backend, Base relacional, Redis y RabbitMQ; [C3](../04-modelo-c4/03-componentes-c3.md) ya incorpora responsabilidades técnicas de caché/invalidación, con ocho módulos. Ambos tienen cierre conceptual; las tres vistas C4 son ilustrativas y sus participantes no constituyen clases o contratos aprobados. Se corrige la afirmación desactualizada de que C2/C3 no se habían actualizado, sin editar las vistas.

Se mantienen Monolito Modular, cuatro capas, REST, repositorios y persistencia relacional definitiva sin motor seleccionado. Redis limita sus copias a fichas públicas reconstruibles; RabbitMQ transporta invalidaciones técnicas con consumidor interno. Worker posterior: **Preparado arquitectónicamente, no obligatorio inicialmente**. Preparar fronteras de consumo/invocación de invalidación para extraerlo sin modificar dominio, sin microservicio ni noveno módulo. No se aprueba ahora otro contenedor de aplicación.

Las seis fuentes Mermaid C1–C4 revisadas en Tarea 3 ya representan el objetivo financiero y se auditan en Tarea 4. Se conservan sus cierres técnicos históricos sin extenderlos a la revisión financiera, sus contratos o ADR-012. La validación visual y actualización de PNG siguen pendientes; el proveedor continúa candidato.

ADR-010/ADR-011 conservan sus cierres y alcance técnico. Sus referencias a exclusividad simulada son antecedentes sustituidos por RC07/DF-06/DP-01 y ADR-012; no permiten trasladar pagos o conciliación a RabbitMQ. Adoptar mensajería financiera exigiría una decisión arquitectónica independiente. Outbox continúa alternativa no adoptada para invalidación; no se adopta por analogía para pagos.

RN-13 y la prohibición concurrente se conservan; PC-05 y PC-08 requieren diseño, no implementación presumida. RF13, formalización DF-02, precisión monetaria, correcciones y políticas del ciclo de Reserva siguen pendientes. La devolución financiera cuando corresponda ante pago sin confirmación es parte del nuevo alcance, con políticas y ejecución pendientes; no aprueba cancelar reservas.

## 7. Trazabilidad y estado de ADR-012

| Necesidad establecida | HU → RF | AC/RC → DA → ADR | Evaluación propuesta |
|---|---|---|---|
| Elegir total/adelanto y verificar al receptor sin recaudación manual | HU09 → RF11/RF18/RF19; HU07 → RF09 para configuración, sin driver de origen asignado a RF09. | AC08/RC07/RC10 → DA06 (RF18 explícito) → ADR-006/ADR-012. RF11/RF19 son contexto de DA06. | EQ-08; EQ-07 como contexto de comprensión, sin driver asignado. |
| Confirmación compatible y aplicación única | RF04/RF06/RF12; HU03/HU04 contextuales. HU09 → RF19 para aplicación. | AC03 → DA02 → ADR-004/ADR-012. RC04 y RF11/RF19 → DA08 → ADR-008/ADR-012; AC03 complementario en DA08. | EQ-03 y EQ-08. |
| Resumen y recepción posterior completa | HU10/HU14 → RF14; HU14 → RF20. | AC04 → DA05 → ADR-007 (apoyo de ADR-012); RF14/RF20 → DA08 → ADR-008/ADR-012. | EQ-04/EQ-03; EQ-07 como contexto. |
| Aprobado sin confirmación, conciliación y devolución cuando corresponda | HU09 → RF19; RF14 para resumen autorizado. | RC04/RF19 → DA08 → ADR-008/ADR-012; DA06 como contexto del proveedor. | EQ-03/EQ-08: fallos, reintentos y evidencia persistida. |

**Estado de ADR-012:** decisiones funcionales establecidas por solicitud; respuesta arquitectónica propuesta, proveedor y capacidades por verificar. Revisión documental, diseño, aprobación de producción y evidencias pendientes. Ningún cierre anterior acredita estos mecanismos o una integración implementada. Se conserva el antecedente de cierre ADR-001–ADR-011 del 16/10/2026; no se emite un cierre aprobado para ADR-012.
