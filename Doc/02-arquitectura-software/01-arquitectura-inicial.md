![Diagrama de la arquitectura inicial de UrbanPulse](<../diagramas/arquitectura-inicial.png>)

**Texto sincronizado en Tarea 4 — 07/11/2026.** El PNG se conserva como antecedente histórico; sus capas, tecnologías y referencias financieras no sustituyen las decisiones vigentes.

La arquitectura conserva **Monolito Modular y Clean Architecture** con cuatro capas oficiales de [ADR-002](../01-analisis-de-sistema/07-decisiones-arquitectonicas.md):

- **Presentación:** interfaces por rol y entradas REST; recibe y traduce operaciones.
- **Aplicación:** coordina casos de uso y colaboraciones públicas internas.
- **Dominio:** expresa reglas independientes de detalles técnicos.
- **Infraestructura:** implementa repositorios y adaptadores hacia contratos del núcleo.

Las dependencias de código se orientan al núcleo; Dominio no depende de Infraestructura. El flujo de ejecución hacia un adaptador no invierte esa regla. REST conecta web y backend; persistencia relacional definitiva sin motor ni ORM seleccionados.

Ocho módulos: Usuarios, Establecimientos, Recursos, Disponibilidad, Reservas, Solicitudes, Servicios y Pagos. Cinco contenedores internos: aplicación web, backend, base relacional, Redis y RabbitMQ. Redis solo fichas públicas reconstruibles; RabbitMQ solo invalidaciones técnicas con consumidor dentro del backend. Worker independiente: **Preparado arquitectónicamente, no obligatorio inicialmente**; extracción posterior sin modificar Dominio.

Mapas y WhatsApp (solo redirección) son externos; el proveedor financiero externo permite como objetivo pago total o adelanto configurado para el propietario receptor, sin redistribución manual de UrbanPulse. Backend verifica resultados y aplicación única; aprobación aislada no confirma. Disponibilidad válida sin incompatibles concurrentes y aceptación interna en eventos son condiciones conjuntas; consultar no retiene recursos. El registro posterior del saldo completo positivo queda separado de la operación electrónica y de la liquidación del proveedor.

El [catálogo ADR-001–ADR-012](../01-analisis-de-sistema/07-decisiones-arquitectonicas.md) conserva nueve adoptadas, ADR-010/ADR-011 cerradas conceptualmente y [ADR-012 propuesta](../01-analisis-de-sistema/adr/ADR-012-modelo-pagos-mvp.md). Mercado Pago Marketplace Split 1:1 es candidato pendiente de validación. Las [seis fuentes C1–C4](../04-modelo-c4/01-contexto-c1.md) existen para revisión; no se seleccionan tecnologías adicionales ni se acredita implementación, integración o producción. RF13 y PC-01–PC-12 siguen pendientes.
