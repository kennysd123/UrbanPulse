# Atributos de Calidad

**Revisión de alcance financiero — 07/11/2026:** las decisiones funcionales de pagos reales sustituyen la exclusividad de simulación del MVP. Pago requerido significa pago total o adelanto configurado, verificado por el backend y aplicado una sola vez a la reserva. El proveedor sigue pendiente de validación; véanse [restricciones](05-restricciones.md) y [ADR-012](adr/ADR-012-modelo-pagos-mvp.md). No se acredita implementación ni aprobación de la integración de producción.

Los atributos de calidad permiten definir cómo debe comportarse
UrbanPulse, además de especificar las funcionalidades que debe
realizar.

Debido a las diferentes modalidades de reserva de canchas, karaokes,
salones de eventos y recreos, se consideran especialmente importantes
la consistencia, disponibilidad, rendimiento, seguridad, mantenibilidad
y extensibilidad del sistema.

---

## 1. Atributos de calidad identificados

| ID | Atributo de calidad | Descripción cualitativa |
|---|---|---|
| **AC01** | **Rendimiento** | Las búsquedas de establecimientos y las consultas de disponibilidad deben responder adecuadamente cuando existan múltiples usuarios realizando consultas de manera concurrente. |
| **AC02** | **Disponibilidad** | El sistema debe permanecer disponible para que los clientes puedan consultar establecimientos, disponibilidad y reservas durante los periodos de mayor demanda. |
| **AC03** | **Consistencia** | El sistema debe evitar que un mismo recurso sea confirmado para dos reservas incompatibles durante el mismo horario. |
| **AC04** | **Seguridad** | Los datos de clientes, propietarios, establecimientos y reservas deben estar protegidos frente a accesos no autorizados. |
| **AC05** | **Mantenibilidad** | El sistema debe estar organizado de manera que permita realizar cambios y correcciones sin afectar innecesariamente otras funcionalidades. |
| **AC06** | **Extensibilidad** | El sistema debe permitir incorporar nuevos tipos de establecimientos o modalidades de reserva sin modificar significativamente el núcleo de UrbanPulse. |
| **AC07** | **Usabilidad** | El cliente debe poder buscar establecimientos, consultar disponibilidad y realizar una reserva o solicitud mediante un flujo comprensible. |
| **AC08** | **Interoperabilidad** | El sistema debe poder interactuar con servicios externos como proveedores de mapas, WhatsApp y el proveedor de pagos electrónicos sin acoplar directamente estas integraciones con las reglas principales del negocio. |

---

## 2. Descripción de los atributos

### AC01 — Rendimiento

UrbanPulse debe proporcionar tiempos de respuesta adecuados para las
operaciones de consulta que realizarán los usuarios.

Las operaciones más relevantes son:

- Búsqueda de establecimientos.
- Consulta de información.
- Consulta de disponibilidad.
- Consulta de reservas.

El rendimiento debe mantenerse adecuado incluso cuando varios
usuarios consulten establecimientos y disponibilidad simultáneamente.

---

### AC02 — Disponibilidad

UrbanPulse debe mantenerse disponible para permitir que los usuarios
consulten establecimientos y realicen operaciones relacionadas con
sus reservas.

Este atributo resulta especialmente importante durante periodos en
los que exista mayor demanda de establecimientos de entretenimiento y
recreación.

El sistema deberá priorizar la disponibilidad de funciones como:

```text
Buscar establecimientos
        ↓
Consultar información
        ↓
Consultar disponibilidad
        ↓
Realizar / consultar reservas

```

### AC03 — Consistencia

La consistencia es uno de los atributos más importantes de UrbanPulse debido a que un mismo recurso no debe ser asignado simultáneamente a reservas incompatibles.

Por ejemplo:

```text
Cancha 01
10/10/2026
09:00 – 10:00
```

Si este bloque ya fue confirmado para una reserva, el sistema no debe permitir que otro cliente confirme nuevamente el mismo recurso durante el mismo intervalo.

La misma consideración se aplica a:

- Canchas.
- Salas de karaoke.
- Otros recursos que puedan utilizarse mediante intervalos de tiempo.

En el caso de salones y recreos, la disponibilidad de la fecha también debe considerarse antes de confirmar una reserva.

Según DF-01 y DF-03, se verifica la disponibilidad del salón, ambiente o espacio definido por el propietario y la fecha solicitada. La confirmación del evento exige además condiciones aceptadas por el cliente dentro de UrbanPulse y pago requerido verificado y aplicado; la disponibilidad por sí sola no basta.

---

### AC04 — Seguridad

UrbanPulse debe proteger la información asociada con los usuarios, propietarios, establecimientos y reservas.

El sistema deberá controlar el acceso según el tipo de actor.

Por ejemplo:

| Actor | Acceso principal |
|---|---|
| **Cliente** | Sus reservas y operaciones permitidas. |
| **Propietario** | Su establecimiento, recursos y solicitudes. |
| **Administrador** | Gestión y supervisión de establecimientos, según HU11 y RF15. |

La información que no corresponda a las responsabilidades del actor no deberá estar disponible sin autorización.

---

### AC05 — Mantenibilidad

La arquitectura de UrbanPulse debe facilitar la modificación y corrección del sistema.

Los módulos relacionados con:

- establecimientos;
- recursos;
- disponibilidad;
- reservas;
- solicitudes;
- pagos;
- integraciones externas;

deberán mantenerse organizados para reducir el impacto de los cambios.

Por ejemplo, modificar la integración con el proveedor de mapas no debería requerir modificar las reglas principales de las reservas.

---

### AC06 — Extensibilidad

UrbanPulse debe permitir incorporar nuevos tipos de establecimientos o modalidades de reserva en el futuro.

Actualmente se contemplan:

```text
Canchas
   ↓
Bloques horarios

Karaokes
   ↓
Sala + tiempo

Salones
   ↓
Fecha + servicios + coordinación + aceptación + pago total o adelanto

Recreos
   ↓
Ambiente o espacio + fecha + servicios + coordinación + aceptación + pago total o adelanto
```

La arquitectura debe permitir que posteriormente pueda incorporarse otro tipo de establecimiento sin tener que modificar significativamente el núcleo de reservas.

Por ejemplo, una futura modalidad podría utilizar:

```text
Nuevo establecimiento
        ↓
Nueva modalidad de reserva
        ↓
Reglas específicas
```

La forma concreta de implementar esta extensibilidad se definirá en la etapa de diseño arquitectónico.

---

### AC07 — Usabilidad

UrbanPulse debe proporcionar un flujo comprensible para que el cliente pueda encontrar un establecimiento y realizar las operaciones relacionadas con su reserva.

El flujo principal deberá permitir:

```text
Buscar
  ↓
Consultar
  ↓
Ver disponibilidad
  ↓
Seleccionar
  ↓
Reservar / Solicitar
  ↓
Confirmar
```

Para salones y recreos, el flujo incorpora registro de cotización y condiciones por el propietario, aceptación del cliente dentro de UrbanPulse y pago total o adelanto configurado. La confirmación requiere condiciones aceptadas, pago requerido verificado y aplicado y disponibilidad verificada (DF-02/DF-03). Canchas y karaoke utilizan confirmación directa con pago total o adelanto configurado y disponibilidad válida al confirmar, previa verificación de disponibilidad (DF-04). La cobertura explícita de DF-02 en HU/RF permanece pendiente de formalización.

---

### AC08 — Interoperabilidad

UrbanPulse contempla la interacción con servicios externos.

Inicialmente se consideran:

| Servicio externo | Uso |
|---|---|
| **Proveedor de mapas** | Visualización de la ubicación del establecimiento. |
| **WhatsApp** | Redirección al contacto del propietario, sin administración de conversaciones. |
| **Proveedor de pagos electrónicos** | Pago real de total o adelanto para el propietario receptor; backend verifica resultados. Candidato pendiente de validación. |

Estas integraciones deben mantenerse separadas de la lógica principal del negocio.

La integración de pago real se mantiene detrás de puertos y adaptadores. Mercado Pago Marketplace Split 1:1 es candidato pendiente de validación; sustituir el adaptador no deberá alterar reglas de confirmación ni confundir sus estados con los de Reserva. La respuesta del navegador no constituye verificación del proveedor.

El sistema no debe depender directamente de una implementación específica cuando esta pueda ser reemplazada posteriormente.

## 3. Estado de especificación y evaluación

Los ocho atributos AC01–AC08 cuentan con los ocho escenarios EQ-01–EQ-08 documentados en [08-escenarios-atributos-calidad.md](08-escenarios-atributos-calidad.md). Los escenarios incluyen criterios observables y propuestas de verificación; permanecen pendientes de revisión y no acreditan pruebas ejecutadas. Los umbrales, métricas cuantitativas y condiciones de evaluación que aún no estén aprobados mantienen ese estado; no se establecen compromisos cuantitativos nuevos en esta etapa.

| Atributo | Base existente | Definición o validación pendiente de evaluación |
|---|---|---|
| AC01 — Rendimiento | Búsquedas y consultas concurrentes. | Carga de referencia, entorno y tiempos de respuesta aceptables. |
| AC02 — Disponibilidad | Acceso durante periodos de mayor demanda. | Periodos de servicio, condiciones de interrupción y medida de disponibilidad aceptable. |
| AC03 — Consistencia | Prohibición de confirmar reservas incompatibles para un mismo recurso y periodo o fecha. | Condiciones de concurrencia y procedimiento de verificación; la regla ya está definida, su mecanismo todavía no. |
| AC04 — Seguridad | Acceso según rol y responsabilidad sobre la información. | Operaciones y recursos a evaluar, condiciones de acceso y evidencia verificable de autorización o rechazo. |
| AC05 — Mantenibilidad | Separación de responsabilidades y de integraciones. | Cambio de referencia, alcance del impacto y criterio de aceptación del cambio. |
| AC06 — Extensibilidad | Incorporar modalidades sin alterar significativamente las existentes. | Cambio de referencia y criterio para evaluar su impacto, sin incorporar una nueva modalidad al MVP. |
| AC07 — Usabilidad | Flujo comprensible de consulta y reserva o solicitud. | Tareas, contexto de evaluación y criterio observable de éxito. |
| AC08 — Interoperabilidad | Mapas, redirección a WhatsApp y pago electrónico desacoplados. | Condiciones de interacción, resultados y fallos a evaluar, sin aprobar al proveedor candidato ni protocolos concretos. |

Las condiciones, procedimientos y medidas propuestos en los escenarios se validarán antes de utilizarlos como criterios de aceptación aprobados. En rendimiento, disponibilidad y usabilidad se mantiene: **Métrica cuantitativa pendiente de validación.** Las relaciones existentes con drivers se encuentran en [06-driver-arquitectonicos](06-driver-arquitectonicos.md). AC02 y AC07 no tienen actualmente un driver ni una respuesta arquitectónica explícita; esa cobertura queda pendiente de evaluación, sin inventar drivers o ADR.

## 4. Aplicación del modelo de pagos reales

| Elemento existente | Precisión de alcance y evaluación |
|---|---|
| AC03 | Confirmar exige pago requerido verificado y aplicado, disponibilidad válida aun bajo concurrencia y aceptación interna en eventos. Pagos, webhooks, aplicaciones y recepción posterior idempotentes; no aplicar dos veces un mismo pago aun con eventos diferentes. Conservar importes fijados, una recepción activa e historial. Aprobado sin confirmación queda trazable sin forzar la reserva. |
| AC04 | Verificación de notificaciones y consulta al proveedor en backend, correlación con operación/reserva/receptor/importe/moneda; no confiar en navegador. Solo propietario autorizado registra saldo de confirmada propia; consulta según titularidad. Credenciales y datos sensibles protegidos; método concreto pendiente. |
| AC05 | Separar Reserva, operación de pago, aplicación y recepción posterior; aislar adaptador del proveedor. Mantener consumidor técnico RabbitMQ extraíble sin cambiar dominio. |
| AC07 | Mostrar total, opción total/adelanto, importe y receptor antes de pagar; diferenciar aprobado, aplicado y confirmado, saldo cero y saldo recibido declarado. No presentar pago aprobado sin confirmación como éxito de reserva; no mostrar un pendiente como nuevo cobro tras su recepción completa. |
| AC08 | Pago real mediante integración verificable, idempotencia de webhooks y recuperación ante respuestas inciertas. Medios declarados del saldo no equivalen a métodos electrónicos soportados. Conciliación y devolución requieren contratos y validación propios; RabbitMQ no los confirma. |

Se conservan AC01–AC08 y EQ-01–EQ-08. Las reglas financieras son alcance establecido; los mecanismos, procedimientos, métricas y evidencias siguen pendientes. AC02/AC07 no adquieren un driver por esta ampliación. La propuesta de [ADR-012](adr/ADR-012-modelo-pagos-mvp.md) debe revisarse y validarse antes de aprobar producción.
