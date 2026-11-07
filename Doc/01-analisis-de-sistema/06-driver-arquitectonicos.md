# Drivers Arquitectónicos

**Revisión de alcance financiero — 07/11/2026:** las decisiones funcionales de pagos reales sustituyen la exclusividad de simulación del MVP. Pago requerido significa pago total o adelanto configurado, verificado por el backend y aplicado una sola vez a la reserva. El proveedor sigue pendiente de validación; véanse [restricciones](05-restricciones.md) y [ADR-012](adr/ADR-012-modelo-pagos-mvp.md). No se acredita implementación ni aprobación de la integración de producción.

Los drivers arquitectónicos representan aquellos requisitos, atributos
de calidad y restricciones que tienen una influencia significativa en
las decisiones de arquitectura de UrbanPulse.

Estos drivers permiten identificar los aspectos que deben considerarse
prioritariamente durante el diseño de la solución arquitectónica.

---

## 1. Drivers arquitectónicos identificados

| ID | Driver arquitectónico | Origen | ¿Por qué influye en la arquitectura? |
|---|---|---|---|
| **DA01** | **Soporte para diferentes modalidades de reserva** | AC05 / AC06 / RC06 / RF03–RF07 | La arquitectura debe permitir manejar diferentes reglas de reserva para canchas, karaokes, salones y recreos sin forzar un único flujo para todos los establecimientos. |
| **DA02** | **Consistencia de disponibilidad** | AC03 / RF04 / RF06 / RF12 | La arquitectura debe evitar que un mismo recurso sea confirmado para reservas incompatibles durante el mismo periodo. |
| **DA03** | **Extensibilidad de modalidades** | AC06 / RC06 | La solución debe permitir incorporar nuevos tipos de establecimientos o modalidades de reserva sin modificar significativamente el núcleo existente. |
| **DA04** | **Rendimiento en consultas** | AC01 / RF01 / RF03 / RF05 | La arquitectura debe permitir responder adecuadamente las búsquedas y consultas de disponibilidad incluso cuando existan múltiples usuarios concurrentes. |
| **DA05** | **Seguridad y control de acceso** | AC04 / RF08 / RF14 / RF15 / RF20 | La arquitectura debe separar las responsabilidades y permisos de clientes, propietarios y administradores. |
| **DA06** | **Integración con servicios externos** | AC05 / AC08 / RC07 / RC08 / RC09 / RC10 / RF16–RF18 | La arquitectura debe permitir integrar mapas, WhatsApp y pago electrónico real sin acoplar estas dependencias con las reglas principales del negocio. |
| **DA07** | **Comunicación mediante API REST** | RC03 | La arquitectura debe establecer una comunicación definida entre la aplicación web y el backend mediante una API REST. |
| **DA08** | **Persistencia de información transaccional** | RC04 / RF04 / RF06 / RF07 / RF11 / RF12 / RF14 / RF19 / RF20 | La arquitectura debe garantizar el almacenamiento consistente de reservas, disponibilidad, establecimientos y operaciones relacionadas. |

---

# 2. Descripción de los drivers

## DA01 — Soporte para diferentes modalidades de reserva

**Origen:** AC05 / AC06 / RC06 / RF03–RF07

UrbanPulse debe manejar diferentes modalidades de reserva debido a las
características de los establecimientos incluidos en el alcance.

Actualmente se contemplan:

| Establecimiento | Modalidad de reserva |
|---|---|
| **Cancha de gras** | Recurso + bloque horario |
| **Karaoke** | Sala + intervalo de tiempo |
| **Salón de eventos** | Fecha + servicios + coordinación + pago total o adelanto |
| **Recreo** | Fecha + servicios + coordinación + pago total o adelanto |

La lectura de estas modalidades se precisa mediante [DF-01–DF-06](05-restricciones.md#3-decisiones-funcionales-aprobadas-y-alcance-del-mvp): el recreo reserva un ambiente o espacio definido por el propietario; el propietario registra cotización y condiciones y el cliente las acepta dentro de UrbanPulse. Los eventos requieren esa aceptación, pago requerido verificado y aplicado y disponibilidad verificada; canchas y karaoke usan confirmación directa con pago total o adelanto configurado y disponibilidad válida al confirmar. DF-02 mantiene su precisión pendiente de formalización en HU/RF.

Este driver tiene una influencia directa en el modelo de dominio y en
la organización de la lógica de reservas.

La arquitectura no debería asumir que todos los establecimientos
utilizan exactamente las mismas reglas.

### Influencia arquitectónica

Puede influir en:

- Modelo de dominio.
- Módulo de reservas.
- Gestión de disponibilidad.
- Separación de reglas de negocio.
- Diseño de componentes.

---

## DA02 — Consistencia de disponibilidad

**Origen:** AC03 / RF04 / RF06 / RF12

UrbanPulse debe impedir que un mismo recurso sea confirmado
simultáneamente para reservas incompatibles.

Por ejemplo:

```text
Cancha 01
10/10/2026
09:00 – 10:00
```

Si este intervalo ya fue confirmado, otra solicitud no debe poder confirmar el mismo recurso durante el mismo periodo.

La misma consideración se aplica a las salas de karaoke y a los recursos que funcionen mediante intervalos.

En salones y recreos, la disponibilidad de la fecha deberá considerarse antes de confirmar una reserva.

### Influencia arquitectónica

Puede influir en:

- Modelo de datos.
- Gestión de transacciones.
- Lógica de disponibilidad.
- Control de concurrencia.
- Confirmación de reservas.

Este constituye uno de los principales drivers arquitectónicos de UrbanPulse.

---

## DA03 — Extensibilidad de modalidades

**Origen:** AC06 / RC06

La arquitectura debe permitir que UrbanPulse pueda incorporar posteriormente nuevos tipos de establecimientos o modalidades de reserva.

La situación actual es:

```text
Cancha
   ↓
Bloque horario

Karaoke
   ↓
Sala + tiempo

Salón
   ↓
Fecha + servicios + coordinación + aceptación + pago total o adelanto

Recreo
   ↓
Ambiente o espacio + fecha + servicios + coordinación + aceptación + pago total o adelanto
```

En el futuro podría existir otro establecimiento con reglas diferentes.

La arquitectura deberá evitar que la incorporación de una nueva modalidad implique modificar significativamente las reglas centrales de las modalidades existentes.

### Influencia arquitectónica

Puede influir en:

- Separación de responsabilidades.
- Diseño del dominio.
- Organización del módulo de reservas.
- Patrones de diseño.
- Dependencias entre componentes.

---

## DA04 — Rendimiento en consultas

**Origen:** AC01 / RF01 / RF03 / RF05

Los usuarios deberán poder realizar consultas de establecimientos y disponibilidad de manera adecuada.

Las principales operaciones involucradas son:

- Búsqueda de establecimientos.
- Consulta de información.
- Consulta de disponibilidad de canchas.
- Consulta de disponibilidad de salas.

### Influencia arquitectónica

Puede influir en:

- Diseño de consultas.
- Acceso a datos.
- Comunicación entre frontend y backend.
- Estrategias de almacenamiento.
- Manejo de concurrencia.

El mecanismo tecnológico concreto para alcanzar el rendimiento requerido será definido posteriormente.

---

## DA05 — Seguridad y control de acceso

**Origen:** AC04 / RF08 / RF14 / RF15 / RF20

UrbanPulse tendrá diferentes tipos de actores con responsabilidades distintas.

```text
Cliente
   │
   └── Operaciones propias

Propietario
   │
   └── Su establecimiento y reservas

Administrador
   │
   └── Gestión de establecimientos (HU11 / RF15)
```

La arquitectura debe garantizar que cada actor pueda acceder solamente a las operaciones correspondientes a sus responsabilidades.

### Influencia arquitectónica

Puede influir en:

- Autenticación.
- Autorización.
- Gestión de roles.
- Protección de información.
- Seguridad de la API.

Los mecanismos tecnológicos concretos de autenticación y autorización se definirán posteriormente.

---

## DA06 — Integración con servicios externos

**Origen:** AC05 / AC08 / RC07 / RC08 / RC09 / RC10 / RF16–RF18

UrbanPulse contempla mapas, WhatsApp y la integración de pagos reales detrás de una abstracción:

| Servicio | Función |
|---|---|
| **Proveedor de mapas** | Visualizar la ubicación de establecimientos. |
| **WhatsApp** | Redirigir al cliente para contactar al propietario. |
| **Proveedor de pago** | Procesar total o adelanto para el propietario receptor; backend verifica resultados. Mercado Pago Marketplace Split 1:1 candidato pendiente. |

Estas integraciones no deben convertirse en dependencias directas de las reglas centrales de reservas.

La propuesta de integración financiera de ADR-012 exige verificar resultados desde el backend y correlacionar operación, importe, moneda y propietario receptor, sin confiar en el navegador. Pagos y webhooks requieren procesamiento idempotente. No se aprueba aún el candidato ni se acredita implementación o pruebas. Mapas conserva proveedor pendiente y WhatsApp solo redirección.

### Flujo conceptual

```text
                  URBANPULSE
                      │
          ┌───────────┼───────────┐
          │           │           │
          ▼           ▼           ▼
        Mapas      WhatsApp    Pago electrónico
          │           │           │
          ▼           ▼           ▼
       Ubicación   Contacto    Resultado
```

### Influencia arquitectónica

Puede influir en:

- Interfaces de integración.
- Adaptadores.
- Separación de responsabilidades.
- Manejo de errores externos.
- Sustitución de proveedores.

---

## DA07 — Comunicación mediante API REST

**Origen:** RC03

UrbanPulse debe utilizar una API REST para la comunicación entre la aplicación web y el backend.

Las operaciones principales estarán relacionadas con:

- Usuarios.
- Establecimientos.
- Recursos.
- Disponibilidad.
- Reservas.
- Solicitudes.
- Pagos.

### Flujo conceptual

```text
┌──────────────────┐
│  Aplicación Web  │
└────────┬─────────┘
         │
         │ HTTP / REST
         ▼
┌──────────────────┐
│      Backend     │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│    Persistencia  │
└──────────────────┘
```

### Influencia arquitectónica

Este driver condiciona:

- Diseño de la interfaz del backend.
- Contratos de comunicación.
- Organización de endpoints.
- Manejo de solicitudes y respuestas.
- Separación entre presentación y lógica de negocio.

---

## DA08 — Persistencia de información transaccional

**Origen:** RC04 / RF04 / RF06 / RF07 / RF11 / RF12 / RF14 / RF19 / RF20

UrbanPulse deberá mantener información persistente relacionada con las operaciones principales del sistema.

Entre los datos relevantes se encuentran:

- Usuarios.
- Establecimientos.
- Recursos.
- Horarios.
- Disponibilidad.
- Reservas.
- Solicitudes.
- Servicios.
- Pagos y adelantos.

La información relacionada con las reservas requiere especial atención debido a su relación con la disponibilidad de los recursos.

#### Influencia arquitectónica

Puede influir en:

- Modelo de datos.
- Transacciones.
- Integridad de información.
- Relaciones entre entidades.
- Persistencia de reservas.

---

# 3. Priorización de drivers arquitectónicos

Los drivers no tienen necesariamente el mismo nivel de influencia en las decisiones arquitectónicas.

| Prioridad | Driver | Motivo |
|---|---|---|
| **Alta** | **DA01 — Diferentes modalidades de reserva** | Constituye el principal reto de diseño debido a las diferencias entre canchas, karaokes, salones y recreos. |
| **Alta** | **DA02 — Consistencia de disponibilidad** | Una reserva doble o incompatible afecta directamente la integridad del negocio. |
| **Alta** | **DA03 — Extensibilidad** | La plataforma debe poder incorporar nuevas modalidades sin alterar significativamente las existentes. |
| **Alta** | **DA05 — Seguridad** | Existen diferentes tipos de actores y niveles de acceso. |
| **Media** | **DA04 — Rendimiento** | Las consultas deben responder adecuadamente bajo concurrencia. |
| **Alta** | **DA06 — Integraciones externas** | Mapas, WhatsApp y pago electrónico real deben mantenerse desacoplados. |
| **Media** | **DA07 — API REST** | Condiciona la comunicación entre frontend y backend. |
| **Alta** | **DA08 — Persistencia transaccional** | Es necesaria para mantener la información de reservas y disponibilidad. |

---

# 4. Relación entre drivers y atributos de calidad

La siguiente tabla reúne relaciones de origen y relaciones complementarias con atributos de calidad. No todas las asociaciones representan un atributo declarado como origen del driver.

| Driver | Atributos de calidad relacionados |
|---|---|
| **DA01 — Modalidades de reserva** | AC06 — Extensibilidad, AC05 — Mantenibilidad |
| **DA02 — Consistencia** | AC03 — Consistencia |
| **DA03 — Extensibilidad** | AC06 — Extensibilidad |
| **DA04 — Rendimiento** | AC01 — Rendimiento |
| **DA05 — Seguridad** | AC04 — Seguridad |
| **DA06 — Integraciones externas** | AC05 — Mantenibilidad, AC08 — Interoperabilidad |
| **DA07 — API REST** | AC05 — Mantenibilidad, AC08 — Interoperabilidad |
| **DA08 — Persistencia** | AC03 — Consistencia, AC05 — Mantenibilidad |

---

# 5. Relación entre drivers y restricciones

| Driver | Restricción relacionada |
|---|---|
| **DA01 — Modalidades de reserva** | RC06 — Diferentes modalidades de reserva |
| **DA02 — Consistencia** | RC04 — Base de datos relacional |
| **DA03 — Extensibilidad** | RC06 — Diferentes modalidades de reserva |
| **DA04 — Rendimiento** | RC01 — Aplicación web / RC03 — API REST |
| **DA05 — Seguridad** | RC01 — Aplicación web / RC03 — API REST |
| **DA06 — Integraciones externas** | RC07 — Pagos reales y propietario receptor / RC08 — WhatsApp / RC09 — Mapas / RC10 — Integraciones desacopladas |
| **DA07 — API REST** | RC03 — API REST |
| **DA08 — Persistencia** | RC04 — Base de datos relacional |

## 6. Alcance de las relaciones y pendientes

Las referencias de origen y las tablas complementarias se leen conjuntamente. DA01 incorpora AC05 y AC06, ya relacionados en la sección 4. DA06 explicita AC05 y RC08, ya presentes en las tablas complementarias, y RC07, que respalda el pago electrónico real descrito por el propio driver.

La columna **Origen** de la sección 1 y los enunciados **Origen** de cada driver registran su procedencia explícita. Las secciones 4 y 5 describen además efectos o relaciones complementarias; no amplían automáticamente esa procedencia. En particular, DA07 tiene RC03 como origen y sus relaciones con AC05/AC08 son complementarias; DA08 tiene RC04 y RF04/RF06/RF07/RF11/RF12/RF14/RF19/RF20 como origen y sus relaciones con AC03/AC05 son complementarias. En DA01, DA02, DA03, DA04, DA05 y DA06, los AC de la sección 4 sí figuran como origen explícito. Esta distinción no agrega drivers ni cadenas de origen.

AC02 — Disponibilidad y AC07 — Usabilidad continúan identificados en [04-atributos-de-calidad](04-atributos-de-calidad.md), pero no tienen driver explícito ni respuesta arquitectónica documentada. No se asignan a un driver existente sin justificación. Las limitaciones de cobertura de RF se registran en [03-requisitos-funcionales](03-requisitos-funcionales.md).

La relación de cada driver con decisiones se mantiene en [07-decisiones-arquitectonicas](07-decisiones-arquitectonicas.md). Ninguna relación con una ADR convierte RF13 en funcionalidad confirmada ni amplía las responsabilidades del administrador a la gestión de usuarios.

## 7. Influencia revisada del modelo financiero

| Driver existente | Aplicación del alcance establecido y propuesta de respuesta | Origen y límite |
|---|---|---|
| DA01 | Directa en cancha/karaoke frente a cotización/aceptación en eventos; ambos admiten total o adelanto. | RC06, RF04/RF06, DF-03/DF-04; no unificar modalidades. |
| DA02 | Pago verificado no sustituye disponibilidad; impedir incompatibles bajo concurrencia. | AC03/RF04/RF06/RF12 → ADR-004; ADR-012 propone coordinación con aplicación única, sin mecanismo aprobado. |
| DA05 | Autorizar recepción/corrección/consulta según titularidad y conservar autor/fecha; proteger datos del proveedor. | RF14/RF20 como origen conservado; verificación financiera de RF18 es contexto de seguridad, no nuevo origen atribuido a DA05. |
| DA06 | Adaptador financiero, verificación backend, webhooks idempotentes y propietario receptor; candidato por validar. | AC05/AC08/RC07/RC10/RF18 → ADR-006 y propuesta ADR-012. RF11/RF19 son contexto de integración. |
| DA08 | Operación, resultado, aplicación única, registro de saldo e historial separados; pendientes de conciliación/devolución sin perder evidencia. | RC04/RF11/RF14/RF19/RF20 → ADR-008 y propuesta ADR-012. AC03/AC05 siguen complementarios. |

DA06 y DA08 pasan de prioridad media a alta por el impacto de fondos reales, duplicados y aprobaciones sin confirmación; se conserva el ID y se documenta la justificación. No se crea driver ni se completa el origen ausente de RF02/RF09/RF10. Las ampliaciones anteriores de RF14/RF20 a DA05 y RF11/RF14/RF19/RF20 a DA08 se conservan.

## 8. Consumidor técnico y worker posterior

ADR-010/ADR-011 conservan Redis para fichas públicas reconstruibles y RabbitMQ exclusivamente para invalidación técnica. Consumidor dentro del backend durante el MVP. El worker independiente está **Preparado arquitectónicamente, no obligatorio inicialmente**; su extracción posterior reutilizará fronteras de consumo e invalidación sin modificar dominio, sin convertirlo en microservicio ni agregar módulo funcional. No se aprueba ahora un proceso, contrato operativo o despliegue separado.

No usar RabbitMQ automáticamente para confirmar pagos o conciliar: requeriría una decisión arquitectónica independiente. La propuesta financiera de ADR-012 no amplía ADR-011 ni selecciona Outbox, bloqueos, retenciones, motor o endpoints.
