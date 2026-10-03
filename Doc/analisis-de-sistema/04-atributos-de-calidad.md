# Atributos de Calidad

Los atributos de calidad permiten definir cómo debe comportarse
UrbanPulse, además de especificar las funcionalidades que debe
realizar.

Debido a las diferentes modalidades de reserva de canchas, karaokes,
salones de eventos y recreos, se consideran especialmente importantes
la consistencia, disponibilidad, rendimiento, seguridad, mantenibilidad
y extensibilidad del sistema.

---

## 1. Atributos de calidad identificados

| ID | Atributo de calidad | Escenario de calidad |
|---|---|---|
| **AC01** | **Rendimiento** | Las búsquedas de establecimientos y las consultas de disponibilidad deben responder adecuadamente cuando existan múltiples usuarios realizando consultas de manera concurrente. |
| **AC02** | **Disponibilidad** | El sistema debe permanecer disponible para que los clientes puedan consultar establecimientos, disponibilidad y reservas durante los periodos de mayor demanda. |
| **AC03** | **Consistencia** | El sistema debe evitar que un mismo recurso sea confirmado para dos reservas incompatibles durante el mismo horario. |
| **AC04** | **Seguridad** | Los datos de clientes, propietarios, establecimientos y reservas deben estar protegidos frente a accesos no autorizados. |
| **AC05** | **Mantenibilidad** | El sistema debe estar organizado de manera que permita realizar cambios y correcciones sin afectar innecesariamente otras funcionalidades. |
| **AC06** | **Extensibilidad** | El sistema debe permitir incorporar nuevos tipos de establecimientos o modalidades de reserva sin modificar significativamente el núcleo de UrbanPulse. |
| **AC07** | **Usabilidad** | El cliente debe poder buscar establecimientos, consultar disponibilidad y realizar una reserva o solicitud mediante un flujo comprensible. |
| **AC08** | **Interoperabilidad** | El sistema debe poder interactuar con servicios externos como proveedores de mapas, WhatsApp y el servicio de pago simulado sin acoplar directamente estas integraciones con las reglas principales del negocio. |

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

---

### AC04 — Seguridad

UrbanPulse debe proteger la información asociada con los usuarios, propietarios, establecimientos y reservas.

El sistema deberá controlar el acceso según el tipo de actor.

Por ejemplo:

| Actor | Acceso principal |
|---|---|
| **Cliente** | Sus reservas y operaciones permitidas. |
| **Propietario** | Su establecimiento, recursos y solicitudes. |
| **Administrador** | Gestión y supervisión de la plataforma. |

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
Fecha + servicios + adelanto

Recreos
   ↓
Fecha + servicios + adelanto
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

Para los salones y recreos, el flujo podrá incorporar pasos adicionales de coordinación y adelanto.

---

### AC08 — Interoperabilidad

UrbanPulse contempla la interacción con servicios externos.

Inicialmente se consideran:

| Servicio externo | Uso |
|---|---|
| **Proveedor de mapas** | Visualización de la ubicación del establecimiento. |
| **WhatsApp** | Comunicación directa entre cliente y propietario. |
| **Pago simulado** | Simulación de aprobación o rechazo de un pago o adelanto. |

Estas integraciones deben mantenerse separadas de la lógica principal del negocio.

El sistema no debe depender directamente de una implementación específica cuando esta pueda ser reemplazada posteriormente.