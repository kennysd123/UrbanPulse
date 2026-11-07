# Actores del Sistema

**Revisión de alcance financiero — 07/11/2026:** las decisiones funcionales de pagos reales sustituyen la exclusividad de simulación del MVP. Pago requerido significa pago total o adelanto configurado, verificado por el backend y aplicado una sola vez a la reserva. El proveedor sigue pendiente de validación; véanse [restricciones](05-restricciones.md) y [ADR-012](adr/ADR-012-modelo-pagos-mvp.md). No se acredita implementación ni aprobación de la integración de producción.

En esta sección se identifican los actores que interactúan con el
sistema UrbanPulse y las principales acciones que realizan dentro de
la plataforma.

| Actor | ¿Qué necesita realizar? |
|---|---|
| **Cliente** | Buscar establecimientos, consultar información y disponibilidad, realizar reservas, pagar el total o un adelanto configurado, consultar sus reservas y su resumen autorizado de pagos, visualizar ubicaciones y contactar al propietario. |
| **Propietario del establecimiento** | Registrar y administrar su establecimiento, recursos, horarios, disponibilidad, servicios y solicitudes de reserva; configurar el adelanto por recurso, registrar la recepción posterior del saldo completo con método, importe, fecha y referencia cuando corresponda y consultar el resumen autorizado. |
| **Administrador** | Gestionar y supervisar los establecimientos registrados en la plataforma, según HU11 y RF15. |
| **Proveedor de mapas** | Proporcionar mapas y permitir visualizar la ubicación de los establecimientos. |
| **WhatsApp** | Permitir la comunicación directa entre el cliente y el propietario mediante una redirección. |
| **Proveedor de pagos electrónicos** | Procesar pagos reales asociados a reservas para el propietario receptor; proveedor concreto pendiente de validación. |

## Clasificación de actores

### Actores humanos

- **Cliente**
- **Propietario del establecimiento**
- **Administrador**

### Sistemas externos y abstracción de pago

- **Proveedor de mapas**
- **WhatsApp**
- **Proveedor de pagos electrónicos:** integración externa requerida por el nuevo alcance. Mercado Pago Marketplace Split 1:1 es candidato, sin integración aprobada o validada para UrbanPulse en Perú. El backend verifica resultados; el navegador no constituye autoridad. La vinculación de cuentas receptoras queda por diseñar y verificar.

## Alcance y trazabilidad de los actores

Las responsabilidades se desarrollan en [02-historias-del-usuarios](02-historias-del-usuarios.md) y [03-requisitos-funcionales](03-requisitos-funcionales.md). Los sistemas externos son integraciones, no roles humanos adicionales.

La responsabilidad confirmada del administrador es la gestión de establecimientos (HU11 → RF15). No existe una HU ni un RF que respalde atribuirle administración de usuarios. La autorización por roles de ADR-007 no implica esa funcionalidad.

Según DF-01–DF-06, el propietario define el ambiente o espacio reservable del recreo y registra la cotización y condiciones del evento; el cliente las acepta dentro de UrbanPulse. La confirmación del evento requiere condiciones aceptadas, pago requerido verificado y aplicado y disponibilidad verificada. Canchas y karaoke utilizan confirmación directa, previa verificación de disponibilidad, con pago total o adelanto configurado y disponibilidad válida al confirmar. Estas aclaraciones se consolidan en las [decisiones funcionales de alcance](05-restricciones.md#3-decisiones-funcionales-aprobadas-y-alcance-del-mvp); la precisión de DF-02 en HU/RF queda pendiente de formalización.

WhatsApp únicamente redirecciona al cliente hacia el contacto del propietario; UrbanPulse no administra conversaciones. El proveedor de mapas está pendiente de selección y solo se utilizará para visualizar la ubicación. El MVP objetivo incorpora pagos electrónicos reales sin recaudación y redistribución manual de fondos por UrbanPulse, conforme a RC07–RC10 de [05-restricciones](05-restricciones.md). El registro posterior de saldo es una declaración autorizada de recepción, diferenciada de la verificación del proveedor.
