# UrbanPulse

## Plataforma de descubrimiento y reserva de entretenimiento urbano

UrbanPulse es una propuesta de plataforma digital orientada a la búsqueda,
consulta de disponibilidad y reserva de establecimientos de entretenimiento
y recreación en Huamanga.

## Contexto

El sistema busca centralizar información y procesos de reserva de negocios
locales como:

- Canchas de gras
- Karaokes
- Salones de eventos
- Recreos

## Modalidades de reserva

UrbanPulse contempla diferentes modalidades:

- Canchas: reserva por bloques horarios.
- Karaoke: reserva de sala y horario.
- Salones de eventos: solicitud, cotización y condiciones aceptadas dentro de UrbanPulse; pago total o adelanto configurado y disponibilidad válida para confirmar.
- Recreos: solicitud de evento sobre un ambiente o espacio definido, con las mismas condiciones conjuntas de confirmación; sin exclusividad presunta del establecimiento o del día.

## Arquitectura

El proyecto se desarrolla utilizando un enfoque de
**Software Design Description (SDD)**.

UrbanPulse conserva **Monolito Modular y Clean Architecture** con cuatro capas oficiales: **Presentación, Aplicación, Dominio e Infraestructura**. Las dependencias de código se orientan al núcleo; Dominio no depende de Infraestructura.

Ocho módulos: Usuarios, Establecimientos, Recursos, Disponibilidad, Reservas, Solicitudes, Servicios y Pagos. Cinco contenedores internos: aplicación web, backend, base relacional, Redis y RabbitMQ. REST conecta web y backend; la base relacional definitiva no tiene motor seleccionado. Redis solo contiene fichas públicas reconstruibles y RabbitMQ transporta sus invalidaciones técnicas, con consumidor interno. Worker independiente: **Preparado arquitectónicamente, no obligatorio inicialmente**; implementación posterior.

El [catálogo de doce ADR](Doc/01-analisis-de-sistema/07-decisiones-arquitectonicas.md) distingue ADR-001–ADR-009 adoptadas, ADR-010/ADR-011 aprobadas conceptualmente y cerradas documentalmente, y ADR-012 propuesta. Las [seis fuentes C1–C4](Doc/04-modelo-c4/01-contexto-c1.md) están disponibles para revisión; los PNG históricos no acreditan el modelo financiero actualizado.

## Sistemas externos

- Proveedor de mapas
- WhatsApp
- Proveedor de pagos electrónicos reales para el propietario receptor, sin redistribución manual de UrbanPulse. Cliente elige total o adelanto configurado. Backend verifica y aplica una sola vez; aprobación aislada no confirma, y consultar disponibilidad no retiene recursos. Mercado Pago Marketplace Split 1:1 es candidato pendiente de validación según [ADR-012](Doc/01-analisis-de-sistema/adr/ADR-012-modelo-pagos-mvp.md).

El propietario autorizado registra posteriormente el saldo completo positivo de su reserva confirmada. Operación, pago aplicado, confirmación, recepción declarada y liquidación del proveedor permanecen separados. RF13 sigue pendiente; integración y producción no están aprobadas. Véase la auditoría del Sprint 01 (antecedente auxiliar local, fuera del repositorio).

## Estado del proyecto

En desarrollo académico para el curso:

**Arquitectura de Software [IS-488]**

## Trabajo con agentes

Consultar la [guía compartida de Spec-Driven Development](SDD.md) y [AGENTS.md](AGENTS.md) antes de iniciar. Este proceso de desarrollo complementa el uso documental de «Software Design Description» descrito arriba. La configuración de herramientas no acredita implementación ni aprobación de funcionalidades.
