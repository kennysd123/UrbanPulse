# Actores del Sistema

En esta sección se identifican los actores que interactúan con el
sistema UrbanPulse y las principales acciones que realizan dentro de
la plataforma.

| Actor | ¿Qué necesita realizar? |
|---|---|
| **Cliente** | Buscar establecimientos, consultar información y disponibilidad, realizar reservas, efectuar adelantos, consultar sus reservas, visualizar ubicaciones y contactar al propietario. |
| **Propietario del establecimiento** | Registrar y administrar su establecimiento, recursos, horarios, disponibilidad, servicios y solicitudes de reserva. |
| **Administrador** | Gestionar y supervisar los establecimientos registrados en la plataforma, según HU11 y RF15. |
| **Proveedor de mapas** | Proporcionar mapas y permitir visualizar la ubicación de los establecimientos. |
| **WhatsApp** | Permitir la comunicación directa entre el cliente y el propietario mediante una redirección. |
| **Servicio de pago simulado** | Simular la aprobación o rechazo de pagos y adelantos asociados a las reservas. |

## Clasificación de actores

### Actores humanos

- **Cliente**
- **Propietario del establecimiento**
- **Administrador**

### Sistemas externos

- **Proveedor de mapas**
- **WhatsApp**
- **Servicio de pago simulado**

## Alcance y trazabilidad de los actores

Las responsabilidades se desarrollan en [[02-historias-del-usuarios]] y [[03-requisitos-funcionales]]. Los sistemas externos son integraciones, no roles humanos adicionales.

La responsabilidad confirmada del administrador es la gestión de establecimientos (HU11 → RF15). No existe una HU ni un RF que respalde atribuirle administración de usuarios. La autorización por roles de ADR-007 no implica esa funcionalidad.

WhatsApp únicamente redirecciona al cliente hacia el contacto del propietario; UrbanPulse no administra conversaciones. El proveedor de mapas está pendiente de selección y solo se utilizará para visualizar la ubicación. Durante el MVP el pago será simulado, sin pasarela real, conforme a RC07–RC10 de [[05-restricciones]].
