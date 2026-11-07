# Historias de Usuario — UrbanPulse

**Revisión de alcance financiero — 07/11/2026:** las decisiones funcionales de pagos reales sustituyen la exclusividad de simulación del MVP. Pago requerido significa pago total o adelanto configurado, verificado por el backend y aplicado una sola vez a la reserva. El proveedor sigue pendiente de validación; véanse [restricciones](05-restricciones.md) y [ADR-012](adr/ADR-012-modelo-pagos-mvp.md). No se acredita implementación ni aprobación de la integración de producción.

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
| **HU09** | Cliente | Como cliente, quiero pagar el precio completo o un adelanto configurado por el propietario, para obtener la confirmación cuando se cumplan las condiciones de la reserva. | Pago |
| **HU10** | Cliente | Como cliente, quiero consultar mis reservas y su estado, para conocer las actividades que tengo programadas. | Reservas |
| **HU11** | Administrador | Como administrador, quiero gestionar los establecimientos registrados, para mantener información válida dentro de la plataforma. | Administración |
| **HU12** | Cliente | Como cliente, quiero contactar al propietario mediante WhatsApp, para realizar consultas adicionales sobre disponibilidad, servicios o condiciones. | Comunicación |
| **HU13** | Cliente | Como cliente, quiero visualizar la ubicación de un establecimiento en un mapa, para conocer dónde se encuentra antes de desplazarme o reservar. | Ubicación |
| **HU14** | Propietario | Como propietario de un establecimiento, quiero registrar la recepción posterior del saldo completo de una reserva confirmada, indicando método, importe, fecha y referencia cuando corresponda, para mantener un control trazable de los pagos recibidos. | Pagos |

---

## 2. Historias de usuario por modalidad

UrbanPulse contempla diferentes formas de reserva debido a las
características de los establecimientos.

![Mapa jerárquico de historias de usuario](<../diagramas/Mapa-jerárquico-de-historia- de-usuario.png>)

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

### HU03 — Consultar disponibilidad de cancha

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

DF-01 precisa que la reserva de un recreo corresponde a un ambiente o espacio definido por el propietario para un evento privado. La información de actividades, comidas, entradas y hospedaje es consultable, sin compra de esos servicios ni reserva de habitaciones desde UrbanPulse.

Puede requerir:

1. Seleccionar la fecha.
2. Verificar disponibilidad.
3. Indicar cantidad de personas.
4. Seleccionar o solicitar servicios.
5. Coordinar las condiciones con el establecimiento.
6. Conocer el precio o cotización.
7. Elegir y realizar el pago total o el adelanto configurado.
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

El propietario podrá definir los horarios en los que un recurso puede ser reservado. **Ampliación aprobada por DF-04/DP-02/DP-03:** configura el importe del adelanto por recurso de cancha o karaoke; el cliente conoce precio total y adelanto antes de iniciar la operación. Las modificaciones posteriores no alteran los importes fijados para una operación iniciada.

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

DF-02 precisa que el propietario registra la cotización y las condiciones del evento y el cliente las acepta dentro de UrbanPulse. El contacto mediante WhatsApp es complementario y no sustituye esa aceptación. La aceptación del propietario de una solicitud y la aceptación del cliente de las condiciones son acciones distintas; ninguna confirma por sí sola la reserva. El registro y la aceptación interna requieren **precisión pendiente de formalización** en la cobertura de HU05/HU08 y RF07/RF10/RF12, sin modificar aquí sus enunciados ni crear identificadores.

---

## 5. Historias relacionadas con pagos y reservas

### HU09 — Pagar el total o un adelanto configurado

**Como cliente**, quiero pagar el precio completo o un adelanto configurado por el propietario, **para obtener la confirmación cuando se cumplan las condiciones de la reserva**.

**Criterios de aceptación del alcance solicitado:**

1. Antes de iniciar, se muestran total, adelanto configurado, modalidad elegida, importe a pagar y propietario receptor. Los importes y condiciones aplicables quedan fijados al iniciar; cambios posteriores no alteran la operación (DP-03).
2. El cliente puede elegir pagar el total o el adelanto configurado. Ningún importe o porcentaje universal se presume.
3. El backend verifica la aprobación con el proveedor y su asociación a la operación, reserva, propietario receptor, moneda e importe esperados. Una redirección o respuesta del navegador no confirma el pago.
4. El pago verificado se aplica como máximo una vez. Reintentos y webhooks repetidos no duplican cobro solicitado, aplicación ni confirmación; tampoco se cuenta dos veces el mismo pago notificado por canales distintos.
5. La reserva directa de cancha/karaoke exige pago requerido verificado y aplicado y disponibilidad válida al confirmar; no requiere solicitud ni cotización de evento. Salón/recreo exige además cotización y condiciones aceptadas dentro de UrbanPulse. Un adelanto suficiente permite confirmar sin esperar al saldo.
6. Se impiden confirmaciones incompatibles incluso bajo concurrencia. Aprobación de pago y confirmación de Reserva son hechos distintos.
7. Un pago aprobado sin reserva confirmada conserva correlación, importe, receptor, motivo y situación pendiente para conciliación y devolución cuando corresponda. No se inventa una cancelación de Reserva ni se da por ejecutado el reembolso.
8. Los fondos corresponden al propietario receptor; UrbanPulse no los recauda para redistribuirlos manualmente en el MVP.

Los pagos electrónicos son reales en el alcance objetivo. Mercado Pago Marketplace Split 1:1 es **proveedor candidato**; elegibilidad en Perú, vinculación de propietarios, métodos, reembolsos y liquidación requieren verificación antes de aprobar producción. Los dobles de prueba no sustituyen ese objetivo ni acreditan integración operativa.

Trazabilidad: RF11/RF18/RF19, condiciones RF04/RF06/RF12; DF-03/DF-04/DF-06 y DP-01–DP-04/DP-12. La solución de concurrencia, idempotencia y recuperación queda por diseñar y validar en [ADR-012](adr/ADR-012-modelo-pagos-mvp.md).

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
- **Consulta por DF-05/DP-10:** total acordado, modalidad e importe del pago verificado y aplicado, pendiente calculado y registro posterior del saldo. Se distinguen estado de Reserva, operación de pago, aplicación y recepción posterior. El propietario autorizado consulta el mismo resumen mediante HU14/RF14; una aprobación sin confirmación se presenta sin simular éxito de la reserva.

---

### HU14 — Registrar recepción posterior del saldo completo

**Como propietario de un establecimiento**, quiero registrar la recepción posterior del saldo completo de una reserva confirmada, indicando método, importe, fecha y referencia cuando corresponda, **para mantener un control trazable de los pagos recibidos**.

**Criterios de aceptación conservados y actualizados:**

1. Solo el propietario autorizado del establecimiento registra sobre una reserva confirmada propia.
2. Importe pendiente = total acordado − pago verificado y aplicado; puede ser resultado de un adelanto o ser cero tras pago total. El registro posterior exige pendiente positivo y el importe completo, sin fraccionamiento.
3. Se conservan reserva, método, importe, fecha de recepción, referencia cuando corresponda, propietario autor y fecha/hora del registro. La referencia no convierte la declaración en confirmación electrónica del proveedor.
4. Efectivo, Yape, Plin o transferencia son métodos declarados del saldo; no se presupone que el candidato los admita como medios electrónicos integrados.
5. Una sola recepción activa; reintentos no la duplican. Correcciones conservan antecedentes, autor y fecha, sin sustitución silenciosa.
6. Registrar o corregir saldo no cambia el estado de Reserva ni el resultado de la operación electrónica. Cliente y propietario autorizados consultan el resumen y distinguen recepción declarada de pago verificado.
7. Con pago total aplicado, el pendiente es cero y no se registra recepción ficticia. La etiqueta visual para ese caso y el procedimiento técnico de corrección quedan pendientes de diseño.

La recepción posterior del saldo y el pago electrónico inicial son responsabilidades separadas. Su representación conjunta debe evitar descontar el mismo importe dos veces (DP-04/DP-10). Trazabilidad: RF20/RF14, DF-05 y DP-04–DP-11.

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
| **Cancha** | HU03, HU07, HU09, HU10, HU14 | Recurso + bloque horario. |
| **Karaoke** | HU04, HU07, HU09, HU10, HU14 | Sala + intervalo de tiempo. |
| **Salón de eventos** | HU05, HU08, HU09, HU10, HU14 | Fecha + servicios + coordinación + adelanto. |
| **Recreo** | HU05, HU08, HU09, HU10, HU14 | Fecha + servicios + coordinación + adelanto. |
| **Administración** | HU06, HU07, HU08, HU11 | Gestión de establecimientos y reservas. |
| **Comunicación** | HU12 | Redirección a WhatsApp. |

---

## 9. Flujo conceptual de las historias

![Flujo conceptual de las historias](<../diagramas/flujo-conceptual-de-las-histoias.png>)

## 10. Aclaraciones de alcance y trazabilidad

- **HU03 — Consultar disponibilidad de cancha** y **HU04 — Consultar disponibilidad de karaoke** conservan su acción de consulta. RF04 y RF06 describen la reserva de esas modalidades ya contempladas; su asociación con estas HU es contextual y no convierte sus enunciados en historias explícitas de ejecución de la reserva. La precisión de esa cobertura queda pendiente, sin crear nuevas HU.
- **HU10 — Consultar reservas** permite consultar información y estados; no expresa ni implica permiso para cancelar. Ninguna de las HU existentes respalda claramente RF13, que queda pendiente de validación en [03-requisitos-funcionales](03-requisitos-funcionales.md).
- **HU11 — Gestionar establecimientos** respalda RF15. No atribuye administración de usuarios al administrador.

Las denominaciones anteriores son las que deben utilizarse en la trazabilidad. Las imágenes existentes se conservan; no sustituyen las aclaraciones textuales ni acreditan funcionalidades pendientes.

Las decisiones DF-01–DF-06 se encuentran en las [aclaraciones de alcance de las restricciones](05-restricciones.md#3-decisiones-funcionales-aprobadas-y-alcance-del-mvp). Su aprobación funcional no resuelve la cobertura contextual HU03/RF04 y HU04/RF06 ni formaliza silenciosamente DF-02 en los requisitos existentes.

## 11. Trazabilidad de la evolución a pagos reales

| Historia | RF | DF / DP | Alcance |
|---|---|---|---|
| HU07 | RF09 | DF-04; DP-02/DP-03 | Configurar adelanto por recurso; conservar importes de operaciones iniciadas. |
| HU09 | RF11/RF18/RF19; RF04/RF06/RF12 para confirmación | DF-03/DF-04/DF-06; DP-01/DP-02/DP-03/DP-12 | Pago total o adelanto en las cuatro modalidades; verificación y aplicación única, disponibilidad y demás condiciones conjuntas; fondos del propietario receptor. |
| HU10 y HU14 | RF14 ampliado | DF-05/DF-06; DP-10 | Consulta autorizada del total, pago aplicado, pendiente y estado de registro. |
| HU14 | RF20 | DF-05/DF-06; DP-04–DP-11 | Saldo completo, registro único activo, método, importe, fecha y referencia cuando corresponda; corrección con historial. |

Catálogo: 14 HU. HU03/HU04 mantienen sus enunciados de consulta; su vínculo con RF04/RF06 sigue siendo contextual y pendiente de precisión.
