# Decisiones Arquitectónicas

Las decisiones arquitectónicas definen las principales soluciones
adoptadas para responder a los drivers arquitectónicos identificados
en UrbanPulse.

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

Las [decisiones funcionales DF-01–DF-04](05-restricciones.md#3-decisiones-funcionales-aprobadas-y-alcance-del-mvp) precisan las modalidades: en recreos se reserva un ambiente o espacio definido por el propietario; canchas y karaoke utilizan confirmación directa con disponibilidad verificada y sin adelanto obligatorio en el MVP. Los eventos conservan su proceso de cotización, condiciones y aceptación interna antes de confirmar, sin crear una ADR adicional.

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

Los drivers de origen se conservan en la tabla inicial y se desarrollan en [06-driver-arquitectonicos](06-driver-arquitectonicos.md). Los atributos y restricciones se consultan en [04-atributos-de-calidad](04-atributos-de-calidad.md) y [05-restricciones](05-restricciones.md). Las limitaciones HU → RF y RF → driver están explicitadas en [03-requisitos-funcionales](03-requisitos-funcionales.md); no se incorporan decisiones para completar relaciones sin respaldo.

## 3. Representaciones existentes pendientes de corrección

En esta etapa se conservan los PNG y los documentos de arquitectura para su revisión posterior. Los siguientes detalles no constituyen decisiones confirmadas y deben interpretarse según las aclaraciones de esta base documental:

| Representación | Información contradictoria o insuficientemente respaldada | Criterio vigente |
|---|---|---|
| [Estilo arquitectónico](../diagramas/estilo-arquitectonico.png) | Tres capas sin correspondencia explícita con Clean Architecture; PostgreSQL, archivos `.js`, puerto 5432, nombre de base de datos y ruta de API sin decisión que los respalde; administrador con gestión de usuarios y cancelación representada como función consolidada. | Monolito Modular con las cuatro capas de ADR-002. Tecnología concreta y contratos detallados pendientes. Administrador limitado al alcance HU11 → RF15; RF13 pendiente de validación. |
| [Enfoque arquitectónico](../diagramas/enfoque-arquitectonico.png) | Node.js / Express, puerto 5432, nombre de base de datos y ruta de API sin decisión que los respalde; administrador con gestión de usuarios; cancelación representada como función consolidada. | Mantener las cuatro capas, interfaces y adaptadores. No asumir tecnologías. RF13 pendiente; gestión de usuarios no respaldada. |
| [Arquitectura inicial](../diagramas/arquitectura%20inicial.png) | Tres capas sin correspondencia explícita con las cuatro oficiales; no distingue suficientemente dependencias de código y flujo de ejecución. | Interpretar la separación según ADR-002, sin asumir dependencia de Dominio hacia Infraestructura. |
| [Matriz HU → RF](../diagramas/Matriz%20de%20trazabilidad%20HU%20%E2%86%92%20RF.png) | No distingue el carácter contextual de HU03 → RF04 y HU04 → RF06. | Consultar las aclaraciones de cobertura en [03-requisitos-funcionales](03-requisitos-funcionales.md). |

Google Maps aparece como ejemplo en las imágenes de estilo y enfoque; no se considera proveedor seleccionado. Las etiquetas de protocolos o implementación de los PNG no sustituyen una decisión documentada.

En [../02-arquitectura-software/01-arquitectura-inicial](../02-arquitectura-software/01-arquitectura-inicial.md) quedan pendientes de armonización la vista de tres capas y las menciones de cancelación. En [../02-arquitectura-software/03-enfoque-arquitectonico](../02-arquitectura-software/03-enfoque-arquitectonico.md), la flecha textual de Dominio hacia Infraestructura no debe interpretarse como dependencia de código: rige ADR-002. Estos archivos se revisarán en otra etapa, sin rediseñar ahora toda la arquitectura ni crear vistas C4.
