# Historias de Usuario — UrbanPulse

Las historias de usuario describen las principales necesidades de los
actores que interactúan con UrbanPulse.

Se utiliza la estructura:

> Como [actor], quiero [acción], para [beneficio].

---

## 1. Resumen de historias de usuario

| ID | Actor | Historia de usuario | Modalidad / área |
|---|---|---|---|
| **HU01** | Cliente | Como cliente, quiero buscar establecimientos de entretenimiento y recreación, para encontrar opciones según mi necesidad. | Descubrimiento |
| **HU02** | Cliente | Como cliente, quiero consultar la información de un establecimiento, para conocer sus servicios, precios, ubicación y condiciones de reserva. | Información |
| **HU03** | Cliente | Como cliente, quiero consultar la disponibilidad de una cancha por fecha y horario, para reservar un bloque de tiempo disponible. | Canchas |
| **HU04** | Cliente | Como cliente, quiero consultar la disponibilidad de una sala de karaoke por fecha y horario, para seleccionar una sala disponible. | Karaoke |
| **HU05** | Cliente | Como cliente, quiero solicitar la reserva de un salón o recreo indicando la fecha y los servicios requeridos, para organizar mi evento. | Salones / Recreos |
| **HU06** | Propietario | Como propietario, quiero registrar y administrar mi establecimiento, para ofrecer sus servicios en UrbanPulse. | Gestión de establecimiento |
| **HU07** | Propietario | Como propietario, quiero administrar los recursos, horarios y disponibilidad, para evitar reservas sobre recursos no disponibles. | Disponibilidad |
| **HU08** | Propietario | Como propietario, quiero gestionar las solicitudes de reserva de salones y recreos, para confirmar las condiciones del evento. | Salones / Recreos |
| **HU09** | Cliente | Como cliente, quiero realizar el pago simulado del adelanto requerido, para confirmar una reserva. | Pago |
| **HU10** | Cliente | Como cliente, quiero consultar mis reservas y su estado, para conocer las actividades que tengo programadas. | Reservas |
| **HU11** | Administrador | Como administrador, quiero gestionar los establecimientos registrados, para mantener información válida dentro de la plataforma. | Administración |
| **HU12** | Cliente | Como cliente, quiero contactar al propietario mediante WhatsApp, para realizar consultas adicionales sobre disponibilidad, servicios o condiciones. | Comunicación |
| **HU13** | Cliente | Como cliente, quiero visualizar la ubicación de un establecimiento en un mapa, para conocer dónde se encuentra antes de desplazarme o reservar. | Ubicación |

---

## 2. Historias de usuario por modalidad

UrbanPulse contempla diferentes formas de reserva debido a las
características de los establecimientos.

![Historias de usuario por modalidad](../diagramas/Historias%20de%20usuario%20por%20modalidad.png)

# Historias de Usuario — UrbanPulse

## 3. Historias relacionadas con el cliente

### HU01 — Buscar establecimientos

**Como cliente**, quiero buscar establecimientos de entretenimiento y recreación, **para encontrar opciones según mi necesidad**.

El cliente podrá consultar establecimientos disponibles en UrbanPulse utilizando información como categoría, ubicación u otros criterios que se definan posteriormente.

---

### HU02 — Consultar información del establecimiento

**Como cliente**, quiero consultar la información de un establecimiento, **para conocer sus servicios, precios, ubicación y condiciones de reserva**.

La información podrá incluir:

- Nombre del establecimiento.
- Categoría.
- Descripción.
- Servicios.
- Precios.
- Horarios.
- Condiciones de reserva.
- Ubicación.

---

### HU03 — Consultar disponibilidad de una cancha

**Como cliente**, quiero consultar la disponibilidad de una cancha por fecha y horario, **para reservar un bloque de tiempo disponible**.

La modalidad contempla bloques de tiempo como:

| Ejemplo | Horario |
|---|---|
| Bloque 1 | 07:00 – 09:00 |
| Bloque 2 | 09:00 – 10:00 |
| Bloque 3 | 10:00 – 11:00 |
| Bloque 4 | 11:00 – 12:00 |

Los horarios no necesariamente tendrán una duración uniforme. El establecimiento podrá definir sus intervalos disponibles.

---

### HU04 — Consultar disponibilidad de karaoke

**Como cliente**, quiero consultar la disponibilidad de una sala de karaoke por fecha y horario, **para seleccionar una sala disponible**.

La reserva considera dos elementos principales:

```text
Sala + Intervalo de tiempo
```

Por ejemplo:

| Sala | Horario | Estado |
|---|---|---|
| Sala 01 | 19:00 – 21:00 | Disponible |
| Sala VIP | 19:00 – 21:00 | Reservada |
| Sala Premium | 21:00 – 23:00 | Disponible |

---

### HU05 — Solicitar reserva de salón o recreo

**Como cliente**, quiero solicitar la reserva de un salón o recreo indicando la fecha y los servicios requeridos, **para organizar mi evento**.

Esta modalidad no se considera inicialmente una reserva directa simple.

Puede requerir:

1. Seleccionar la fecha.
2. Verificar disponibilidad.
3. Indicar cantidad de personas.
4. Seleccionar o solicitar servicios.
5. Coordinar las condiciones con el establecimiento.
6. Conocer el precio o cotización.
7. Realizar el adelanto requerido.
8. Confirmar la reserva.

Ejemplo de servicios:

| Servicio | Ejemplo |
|---|---|
| Local | Salón o recreo |
| Mesas y sillas | Incluido / solicitado |
| Sonido | Incluido / adicional |
| Decoración | Opcional |
| Catering | Opcional |
| Otros | Según establecimiento |

---

## 4. Historias relacionadas con el propietario

### HU06 — Administrar establecimiento

**Como propietario**, quiero registrar y administrar mi establecimiento, **para ofrecer sus servicios en UrbanPulse**.

El propietario podrá gestionar información como:

- Nombre.
- Categoría.
- Descripción.
- Dirección.
- Ubicación.
- Información de contacto.
- Servicios.
- Condiciones de reserva.

---

### HU07 — Administrar recursos, horarios y disponibilidad

**Como propietario**, quiero administrar los recursos, horarios y disponibilidad, **para evitar reservas sobre recursos no disponibles**.

Dependiendo del establecimiento, los recursos pueden representar:

| Tipo de establecimiento | Recurso |
|---|---|
| Cancha | Cancha de gras |
| Karaoke | Sala |
| Salón | Ambiente / salón |
| Recreo | Ambiente / espacio disponible |

El propietario podrá definir los horarios en los que un recurso puede ser reservado.

---

### HU08 — Gestionar solicitudes de salones y recreos

**Como propietario**, quiero gestionar las solicitudes de reserva de salones y recreos, **para confirmar las condiciones del evento**.

La solicitud podrá requerir revisión de:

- Fecha.
- Disponibilidad.
- Cantidad de personas.
- Servicios solicitados.
- Precio.
- Adelanto.
- Condiciones adicionales.

El propietario podrá aceptar o rechazar la solicitud según las condiciones del establecimiento.

---

## 5. Historias relacionadas con pagos y reservas

### HU09 — Realizar adelanto mediante pago simulado

**Como cliente**, quiero realizar el pago simulado del adelanto requerido, **para confirmar una reserva**.

Durante el MVP no se utilizará inicialmente una pasarela de pago real.

El sistema utilizará un servicio de pago simulado que podrá devolver resultados como:

```text
PAGO APROBADO
PAGO RECHAZADO
```

El resultado deberá actualizar el estado correspondiente de la reserva.

---

### HU10 — Consultar reservas

**Como cliente**, quiero consultar mis reservas y su estado, **para conocer las actividades que tengo programadas**.

La información podrá incluir:

- Establecimiento.
- Recurso.
- Fecha.
- Horario.
- Servicios.
- Monto.
- Adelanto.
- Estado de la reserva.

---

## 6. Historias relacionadas con administración

### HU11 — Gestionar establecimientos

**Como administrador**, quiero gestionar los establecimientos registrados, **para mantener información válida dentro de la plataforma**.

Las acciones podrán incluir:

- Consultar establecimientos.
- Revisar información.
- Gestionar el estado del establecimiento.
- Supervisar información registrada.

---

## 7. Historias relacionadas con servicios externos

### HU12 — Contactar al propietario mediante WhatsApp

**Como cliente**, quiero contactar al propietario mediante WhatsApp, **para realizar consultas adicionales sobre disponibilidad, servicios o condiciones**.

El flujo será:

```text
UrbanPulse
    │
    ▼
Contactar propietario
    │
    ▼
WhatsApp
    │
    ▼
Propietario
```

UrbanPulse únicamente redireccionará al cliente hacia WhatsApp.

#### Fuera de alcance

UrbanPulse no gestionará:

- Conversaciones.
- Historial de mensajes.
- Mensajes enviados.
- Mensajes recibidos.

---

### HU13 — Visualizar ubicación mediante mapa

**Como cliente**, quiero visualizar la ubicación de un establecimiento en un mapa, **para conocer dónde se encuentra antes de desplazarme o reservar**.

El sistema podrá mostrar la ubicación registrada del establecimiento mediante un proveedor externo de mapas.

```text
Establecimiento
      │
      ▼
Ubicación registrada
      │
      ▼
Proveedor de mapas
      │
      ▼
Mapa
```

El proveedor concreto de mapas se decidirá posteriormente.

---

## 8. Agrupación de historias según el tipo de reserva

| Modalidad | Historias principales | Característica |
|---|---|---|
| **Descubrimiento** | HU01, HU02, HU13 | Buscar, consultar información y ubicación. |
| **Cancha** | HU03, HU07, HU10 | Recurso + bloque horario. |
| **Karaoke** | HU04, HU07, HU10 | Sala + intervalo de tiempo. |
| **Salón de eventos** | HU05, HU08, HU09, HU10 | Fecha + servicios + coordinación + adelanto. |
| **Recreo** | HU05, HU08, HU09, HU10 | Fecha + servicios + coordinación + adelanto. |
| **Administración** | HU06, HU07, HU08, HU11 | Gestión de establecimientos y reservas. |
| **Comunicación** | HU12 | Redirección a WhatsApp. |

---

## 9. Flujo conceptual de las historias

![Flujo conceptual de las historias](../diagramas/Flujo%20conceptual%20de%20las%20historias.png)
