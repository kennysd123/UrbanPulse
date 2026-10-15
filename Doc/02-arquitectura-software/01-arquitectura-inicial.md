![Diagrama de la arquitectura inicial de UrbanPulse](<../diagramas/arquitectura-inicial.png>)

La arquitectura se organiza en tres capas principales:

- **Presentación:** la aplicación web ofrece las interfaces para clientes, propietarios y administradores; la API REST recibe las solicitudes, valida las entradas y devuelve respuestas.
- **Lógica de negocio:** un monolito modular reúne las funciones de usuarios, recursos, disponibilidad, solicitudes y cotizaciones, servicios, establecimientos, reservas y pagos. Los módulos coordinan las reglas y operaciones de la plataforma.
- **Datos:** una base de datos relacional persiste la información compartida por los módulos.

Las integraciones conectan las funciones correspondientes con servicios externos de pago simulado, mapas y WhatsApp.