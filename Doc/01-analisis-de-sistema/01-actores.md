# Actores del Sistema

En esta sección se identifican los actores que interactúan con el
sistema UrbanPulse y las principales acciones que realizan dentro de
la plataforma.

| Actor | ¿Qué necesita realizar? |
|---|---|
| **Cliente** | Buscar establecimientos, consultar información y disponibilidad, realizar reservas, efectuar adelantos simulados, consultar sus reservas y su resumen autorizado de pagos simulados, visualizar ubicaciones y contactar al propietario. |
| **Propietario del establecimiento** | Registrar y administrar su establecimiento, recursos, horarios, disponibilidad, servicios y solicitudes de reserva; configurar el adelanto por recurso, registrar la recepción simulada del saldo completo y consultar el resumen autorizado. |
| **Administrador** | Gestionar y supervisar los establecimientos registrados en la plataforma, según HU11 y RF15. |
| **Proveedor de mapas** | Proporcionar mapas y permitir visualizar la ubicación de los establecimientos. |
| **WhatsApp** | Permitir la comunicación directa entre el cliente y el propietario mediante una redirección. |
| **Servicio de pago simulado** | Simular la aprobación o rechazo de pagos y adelantos asociados a las reservas. |

## Clasificación de actores

### Actores humanos

- **Cliente**
- **Propietario del establecimiento**
- **Administrador**

### Sistemas externos y abstracción de pago

- **Proveedor de mapas**
- **WhatsApp**
- **Servicio de pago simulado:** representa conceptualmente la interacción con un servicio de pago. Durante el MVP, UrbanPulse implementa el componente de simulación detrás de una abstracción de integración; no se conecta con una pasarela financiera real ni se acredita un sistema financiero externo desplegado.

## Alcance y trazabilidad de los actores

Las responsabilidades se desarrollan en [02-historias-del-usuarios](02-historias-del-usuarios.md) y [03-requisitos-funcionales](03-requisitos-funcionales.md). Los sistemas externos son integraciones, no roles humanos adicionales.

La responsabilidad confirmada del administrador es la gestión de establecimientos (HU11 → RF15). No existe una HU ni un RF que respalde atribuirle administración de usuarios. La autorización por roles de ADR-007 no implica esa funcionalidad.

Según DF-01–DF-06, el propietario define el ambiente o espacio reservable del recreo y registra la cotización y condiciones del evento; el cliente las acepta dentro de UrbanPulse. La confirmación del evento requiere condiciones aceptadas, adelanto simulado aprobado y disponibilidad verificada. Canchas y karaoke utilizan confirmación directa, previa verificación de disponibilidad, con adelanto simulado obligatorio y disponibilidad válida al confirmar. Estas aclaraciones se consolidan en las [decisiones funcionales de alcance](05-restricciones.md#3-decisiones-funcionales-aprobadas-y-alcance-del-mvp); la precisión de DF-02 en HU/RF queda pendiente de formalización.

WhatsApp únicamente redirecciona al cliente hacia el contacto del propietario; UrbanPulse no administra conversaciones. El proveedor de mapas está pendiente de selección y solo se utilizará para visualizar la ubicación. Durante el MVP el pago será simulado, sin pasarela real, conforme a RC07–RC10 de [05-restricciones](05-restricciones.md).
