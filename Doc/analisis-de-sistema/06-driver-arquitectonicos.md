# Drivers Arquitectónicos

Los drivers arquitectónicos representan aquellos requisitos, atributos
de calidad y restricciones que tienen una influencia significativa en
las decisiones de arquitectura de UrbanPulse.

Estos drivers permiten identificar los aspectos que deben considerarse
prioritariamente durante el diseño de la solución arquitectónica.

---

## 1. Drivers arquitectónicos identificados

| ID | Driver arquitectónico | Origen | ¿Por qué influye en la arquitectura? |
|---|---|---|---|
| **DA01** | **Soporte para diferentes modalidades de reserva** | RC06 / RF03–RF07 | La arquitectura debe permitir manejar diferentes reglas de reserva para canchas, karaokes, salones y recreos sin forzar un único flujo para todos los establecimientos. |
| **DA02** | **Consistencia de disponibilidad** | AC03 / RF04 / RF06 / RF12 | La arquitectura debe evitar que un mismo recurso sea confirmado para reservas incompatibles durante el mismo periodo. |
| **DA03** | **Extensibilidad de modalidades** | AC06 / RC06 | La solución debe permitir incorporar nuevos tipos de establecimientos o modalidades de reserva sin modificar significativamente el núcleo existente. |
| **DA04** | **Rendimiento en consultas** | AC01 / RF01 / RF03 / RF05 | La arquitectura debe permitir responder adecuadamente las búsquedas y consultas de disponibilidad incluso cuando existan múltiples usuarios concurrentes. |
| **DA05** | **Seguridad y control de acceso** | AC04 / RF08 / RF15 | La arquitectura debe separar las responsabilidades y permisos de clientes, propietarios y administradores. |
| **DA06** | **Integración con servicios externos** | AC08 / RC09 / RC10 / RF16–RF18 | La arquitectura debe permitir integrar mapas, WhatsApp y pago simulado sin acoplar estas dependencias con las reglas principales del negocio. |
| **DA07** | **Comunicación mediante API REST** | RC03 | La arquitectura debe establecer una comunicación definida entre la aplicación web y el backend mediante una API REST. |
| **DA08** | **Persistencia de información transaccional** | RC04 / RF04 / RF06 / RF07 / RF12 | La arquitectura debe garantizar el almacenamiento consistente de reservas, disponibilidad, establecimientos y operaciones relacionadas. |

---

# 2. Descripción de los drivers

## DA01 — Soporte para diferentes modalidades de reserva

**Origen:** RC06 / RF03–RF07

UrbanPulse debe manejar diferentes modalidades de reserva debido a las
características de los establecimientos incluidos en el alcance.

Actualmente se contemplan:

| Establecimiento | Modalidad de reserva |
|---|---|
| **Cancha de gras** | Recurso + bloque horario |
| **Karaoke** | Sala + intervalo de tiempo |
| **Salón de eventos** | Fecha + servicios + coordinación + adelanto |
| **Recreo** | Fecha + servicios + coordinación + adelanto |

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
Fecha + servicios + adelanto

Recreo
   ↓
Fecha + servicios + adelanto
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

**Origen:** AC04 / RF08 / RF15

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
   └── Administración de la plataforma
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

**Origen:** AC08 / RC09 / RC10 / RF16–RF18

UrbanPulse contempla inicialmente tres integraciones externas:

| Servicio | Función |
|---|---|
| **Proveedor de mapas** | Visualizar la ubicación de establecimientos. |
| **WhatsApp** | Redirigir al cliente para contactar al propietario. |
| **Pago simulado** | Simular el resultado de un pago o adelanto. |

Estas integraciones no deben convertirse en dependencias directas de las reglas centrales de reservas.

### Flujo conceptual

```text
                  URBANPULSE
                      │
          ┌───────────┼───────────┐
          │           │           │
          ▼           ▼           ▼
        Mapas      WhatsApp    Pago simulado
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

**Origen:** RC04 / RF04 / RF06 / RF07 / RF12

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
| **Media** | **DA06 — Integraciones externas** | Mapas, WhatsApp y pago simulado deben mantenerse desacoplados. |
| **Media** | **DA07 — API REST** | Condiciona la comunicación entre frontend y backend. |
| **Media** | **DA08 — Persistencia transaccional** | Es necesaria para mantener la información de reservas y disponibilidad. |

---

# 4. Relación entre drivers y atributos de calidad

Los drivers arquitectónicos se relacionan directamente con los atributos de calidad definidos anteriormente.

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
| **DA06 — Integraciones externas** | RC08 — WhatsApp / RC09 — Mapas / RC10 — Integraciones desacopladas |
| **DA07 — API REST** | RC03 — API REST |
| **DA08 — Persistencia** | RC04 — Base de datos relacional |