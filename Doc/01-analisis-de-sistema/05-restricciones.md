# Restricciones del Sistema

**Revisión de alcance financiero — 07/11/2026:** las decisiones funcionales de pagos reales sustituyen la exclusividad de simulación del MVP. Pago requerido significa pago total o adelanto configurado, verificado por el backend y aplicado una sola vez a la reserva. El proveedor sigue pendiente de validación; véanse [restricciones](05-restricciones.md) y [ADR-012](adr/ADR-012-modelo-pagos-mvp.md). No se acredita implementación ni aprobación de la integración de producción.

Las restricciones representan condiciones que deben considerarse durante
el diseño y la implementación de la arquitectura del sistema UrbanPulse.

Estas condiciones delimitan el alcance inicial del proyecto y permiten
establecer criterios que deberán mantenerse durante las siguientes
etapas del diseño.

---

## 1. Restricciones identificadas

| ID | Restricción | Descripción |
|---|---|---|
| **RC01** | **Aplicación web** | El sistema debe desarrollarse como una aplicación accesible mediante un navegador web. |
| **RC02** | **Control de versiones** | El proyecto debe gestionarse utilizando Git y mantenerse en un repositorio compartido en GitHub. |
| **RC03** | **API REST** | La comunicación entre la aplicación web y el backend debe realizarse mediante una API REST. |
| **RC04** | **Base de datos relacional** | La información persistente del sistema debe almacenarse en una base de datos relacional. |
| **RC05** | **Contexto local** | La primera versión del sistema estará orientada a establecimientos de entretenimiento y recreación de Huamanga. |
| **RC06** | **Diferentes modalidades de reserva** | El sistema debe contemplar diferentes formas de reserva según el tipo de establecimiento y recurso. |
| **RC07** | **Pagos reales y propietario receptor** | El MVP objetivo incorpora pagos electrónicos reales de total o adelanto; fondos correspondientes al propietario receptor, sin recaudación y redistribución manual por UrbanPulse. Proveedor e integración de producción pendientes de validación. |
| **RC08** | **Comunicación mediante WhatsApp** | El contacto entre cliente y propietario mediante WhatsApp debe realizarse mediante redirección, sin implementar un sistema de mensajería propio. |
| **RC09** | **Proveedor externo de mapas** | La visualización de la ubicación de los establecimientos debe realizarse mediante un servicio externo de mapas. |
| **RC10** | **Integraciones desacopladas** | Los servicios externos utilizados por UrbanPulse no deben determinar directamente las reglas principales del negocio. |

---

## 2. Descripción de las restricciones

### RC01 — Aplicación web

UrbanPulse debe desarrollarse inicialmente como una aplicación web.

Los usuarios podrán acceder al sistema mediante un navegador web para
realizar las operaciones correspondientes a su rol.

El alcance inicial no contempla el desarrollo de una aplicación móvil
nativa independiente.

---

### RC02 — Control de versiones

El proyecto debe utilizar Git para el control de versiones y mantenerse
en un repositorio compartido en GitHub.

La documentación y los artefactos del proyecto deberán mantenerse
versionados para permitir identificar la evolución de UrbanPulse.

La estructura documental actual del repositorio contempla:

```text
UrbanPulse
│
├── README.md
├── .gitignore
│
└── Doc
    ├── 01-analisis-de-sistema
    ├── 02-arquitectura-software
    └── diagramas
```

### RC03 — API REST

La comunicación entre la aplicación web y el backend debe realizarse mediante una API REST.

La API deberá permitir exponer las operaciones necesarias para:

- Establecimientos.
- Recursos.
- Disponibilidad.
- Reservas.
- Solicitudes.
- Servicios.
- Pagos.
- Usuarios.

Los detalles de los endpoints y contratos de la API se definirán posteriormente durante el diseño detallado.

---

### RC04 — Base de datos relacional

La información persistente de UrbanPulse debe almacenarse en una base de datos relacional.

Entre la información que deberá persistirse se encuentra:

- Usuarios.
- Establecimientos.
- Recursos.
- Disponibilidad.
- Reservas.
- Solicitudes.
- Servicios.
- Pagos o adelantos.

La tecnología específica de base de datos podrá definirse durante la etapa de diseño arquitectónico.

---

### RC05 — Contexto local

La primera versión de UrbanPulse estará orientada a establecimientos de entretenimiento y recreación de Huamanga.

El sistema se plantea inicialmente para negocios locales como:

- Canchas de gras.
- Karaokes.
- Salones de eventos.
- Recreos.

La ampliación hacia otras ciudades o mercados no forma parte del alcance inicial.

---

### RC06 — Diferentes modalidades de reserva

UrbanPulse debe contemplar diferentes modalidades de reserva debido a las características de cada tipo de establecimiento.

Actualmente se consideran:

| Tipo de establecimiento | Modalidad |
|---|---|
| **Cancha** | Recurso + fecha + bloque horario; confirmación directa con pago total o adelanto configurado y disponibilidad válida al confirmar. |
| **Karaoke** | Sala + fecha + intervalo de tiempo; confirmación directa con pago total o adelanto configurado y disponibilidad válida al confirmar. |
| **Salón de eventos** | Fecha + servicios + cotización + aceptación + pago total o adelanto |
| **Recreo** | Fecha + servicios + cotización + aceptación + pago total o adelanto |

La arquitectura no debe asumir que todos los establecimientos utilizan el mismo proceso de reserva.

Esta condición constituye una de las principales restricciones del diseño de UrbanPulse.

DF-01 delimita el recreo a eventos privados sobre un ambiente o espacio definido por el propietario. La información de actividades, comidas, entradas y hospedaje es consultable, sin compra de esos servicios ni reserva de habitaciones desde UrbanPulse. Para eventos, DF-02/DF-03 exigen registro de cotización y condiciones por el propietario, aceptación del cliente dentro de UrbanPulse, pago requerido verificado y aplicado y disponibilidad verificada antes de confirmar. Véanse las [decisiones funcionales aprobadas](#3-decisiones-funcionales-aprobadas-y-alcance-del-mvp).

---

### RC07 — Pagos reales y propietario receptor

El alcance objetivo del MVP incluye pagos electrónicos reales. El cliente elige precio completo o adelanto configurado por el propietario; un adelanto suficiente permite confirmar cuando se cumplan todas las condiciones. UrbanPulse no recauda fondos para redistribuirlos manualmente. Cada operación debe identificar y verificar al propietario receptor y mantener esa asociación al procesar resultados.

Mercado Pago Marketplace Split 1:1 es **candidato**, sin integración aprobada ni validación de capacidades para UrbanPulse en Perú. Deben comprobarse elegibilidad, vinculación de propietarios, métodos, reembolsos, liquidación y costes. La necesidad funcional no aprueba producto, contrato, comisión de plataforma ni operación de producción; véase [ADR-012](adr/ADR-012-modelo-pagos-mvp.md).

El backend verifica los resultados del proveedor; el navegador no es autoridad financiera. Pagos y webhooks se procesan idempotentemente. La aprobación no equivale a confirmación, que además exige disponibilidad válida sin incompatibilidades concurrentes y aceptación interna en eventos. Pago aprobado sin reserva confirmada se conserva para conciliación y devolución cuando corresponda; su procedimiento y garantías requieren diseño y aprobación.

La recepción posterior de saldo completo por propietario autorizado se registra separadamente con método, importe, fecha y referencia cuando corresponda. Es declaración trazable de recepción y no reemplaza la verificación de una operación electrónica. Los simuladores podrán servir para pruebas, sin restringir todo el MVP a simulación ni acreditar integración real.

**Antecedente sustituido:** RC07 prohibía toda operación financiera real y difería la pasarela a una etapa posterior. La solicitud del 07/11/2026 sustituye esa restricción para el alcance objetivo; se conserva el ID.

---

### RC08 — Comunicación mediante WhatsApp

UrbanPulse no implementará inicialmente un sistema interno de mensajería entre clientes y propietarios.

Cuando el cliente necesite contactar al propietario, el sistema podrá redirigirlo hacia WhatsApp utilizando los datos de contacto registrados.

El flujo será:

```text id="f4k2nz"
Cliente
   ↓
UrbanPulse
   ↓
Contactar propietario
   ↓
WhatsApp
   ↓
Propietario
```

UrbanPulse no será responsable de:

- Gestionar conversaciones.
- Almacenar mensajes.
- Administrar el historial de mensajes.
- Gestionar estados de entrega de mensajes.

---

### RC09 — Proveedor externo de mapas

La ubicación de los establecimientos se visualizará mediante un proveedor externo de mapas.

El proveedor específico todavía no constituye una decisión definitiva.

La mención previa de Google Maps corresponde únicamente a un ejemplo de proveedor posible; no es una selección tecnológica. El proveedor concreto permanece pendiente.

La funcionalidad principal requerida para el MVP es:

```text id="me2k8a"
Establecimiento
      ↓
Ubicación registrada
      ↓
Proveedor de mapas
      ↓
Visualización en mapa
```

La arquitectura deberá evitar que las reglas principales de establecimientos y reservas dependan directamente de un proveedor específico.

---

### RC10 — Integraciones desacopladas

Las integraciones con servicios externos deberán mantenerse separadas de las reglas principales del negocio.

UrbanPulse contempla inicialmente:

| Servicio externo | Función |
|---|---|
| **Proveedor de mapas** | Visualizar la ubicación de establecimientos. |
| **WhatsApp** | Redirigir al cliente hacia el contacto del propietario, sin administrar conversaciones. |
| **Proveedor de pagos electrónicos** | Procesar total o adelanto para el propietario receptor; backend verifica resultados. Proveedor candidato sin validación. |

El cambio o sustitución de uno de estos servicios no debería requerir modificar innecesariamente las reglas principales relacionadas con reservas, disponibilidad o establecimientos.

La integración financiera se mantiene detrás de interfaces y adaptadores según ADR-006. La propuesta de ADR-012 concreta responsabilidades sin acoplar el dominio a SDK, credenciales o estados particulares del candidato.

## 3. Decisiones funcionales aprobadas y alcance del MVP

Las decisiones funcionales siguientes expresan el alcance establecido por la solicitud del 07/11/2026. Se conservan DF-01–DF-06, diez RC, ocho AC y ocho DA; el catálogo pasa a doce ADR con ADR-012 propuesta, sin nueva aprobación de producción. Los procedimientos y métricas de los ocho EQ siguen pendientes.

| Decisión | Alcance vigente | Respaldo y límite |
|---|---|---|
| DF-01 | Recreo: ambiente o espacio del propietario para evento privado. | HU05/HU07/HU08 y RF07/RF09/RF10 como contexto; sin compra de actividades, comidas o entradas ni reserva de habitaciones. Sin cambio. |
| DF-02 | Propietario registra cotización y condiciones; cliente acepta dentro de UrbanPulse. | HU05/HU08 y RF07/RF10/RF12 como contexto; formalización detallada pendiente. WhatsApp no sustituye aceptación. Sin cambio. |
| DF-03 | Evento confirma solo con condiciones aceptadas, pago requerido verificado y aplicado y disponibilidad válida al confirmar, incluso bajo concurrencia. | HU09 y RF11/RF18/RF19 para pago; RF12 para confirmación. Ninguna condición basta por separado. Pago total o adelanto configurado suficiente. |
| DF-04 | Cancha/karaoke mantienen reserva directa; cliente elige total o adelanto configurado por recurso, conocido antes de operar. Confirmación exige pago requerido verificado y aplicado y disponibilidad válida sin incompatibles concurrentes. | HU07/HU09; RF04/RF06/RF09/RF11/RF12/RF18/RF19. Sin solicitud de evento ni cotización obligatoria; sin tarifa o porcentaje universal. |
| DF-05 | Propietario autorizado registra recepción posterior del saldo completo positivo de reserva confirmada propia: método, importe, fecha y referencia cuando corresponda, autor y fecha/hora de registro. Resumen autorizado e historial. | HU14/RF20 y RF14. Una recepción activa; no cambia Reserva ni resultado electrónico; no ejecuta por sí misma un cobro. |
| DF-06 | Pagos electrónicos reales en el MVP objetivo; fondos del propietario receptor, sin recaudación y redistribución manual de UrbanPulse. Backend verifica resultados e idempotencia; aprobados sin confirmación trazables para conciliación y devolución cuando corresponda. | HU09/RF11/RF18/RF19, RC07. Mercado Pago Marketplace Split 1:1 candidato, no integración aprobada o validada. |

RF13 permanece pendiente: devolución financiera cuando corresponda no aprueba cancelación de una reserva. Los PC del Diseño ya reflejan esta evolución y conservan pendientes sus mecanismos, contratos y políticas.

## 4. Políticas de pago aprobadas

| Código | Política vigente |
|---|---|
| DP-01 | El objetivo del MVP incluye pagos electrónicos reales; dobles de prueba permitidos para validación, sin sustituir el objetivo. |
| DP-02 | Cliente puede pagar total o adelanto configurado; ambas opciones satisfacen la condición financiera si son verificadas y aplicadas. Adelanto por recurso de cancha/karaoke; eventos según condiciones aceptadas. |
| DP-03 | Mostrar y fijar total, adelanto, opción elegida, importe, moneda y propietario receptor al iniciar; cambios posteriores no alteran la operación. La precisión y límites monetarios siguen pendientes. |
| DP-04 | Importe pendiente = total acordado − pago verificado y aplicado a la reserva. El pago aplicado puede ser total o adelanto; un resultado rechazado, incierto o aprobado sin aplicación no se descuenta. La recepción posterior del saldo se registra separadamente y se muestra para evitar cobro duplicado; no se vuelve a restar como el mismo pago electrónico. |
| DP-05 | La recepción posterior del saldo exige el importe completo positivo; no se incorporan fraccionamientos posteriores. |
| DP-06 | Una recepción activa de saldo por reserva, más historial; reintentos no crean duplicados. |
| DP-07 | Efectivo, Yape, Plin y transferencia son métodos declarados del registro posterior; no acreditan soporte electrónico del proveedor candidato. Referencia cuando corresponda. |
| DP-08 | Estados informativos del registro de saldo positivo: Pendiente de registro y Registrado como recibido. La etiqueta de presentación de saldo cero queda pendiente; no inventar recepción. No son estados de Reserva ni del proveedor. |
| DP-09 | Corrección conserva historial, autor y fecha; sin sustitución silenciosa. Procedimiento técnico pendiente. |
| DP-10 | Cliente y propietario autorizados consultan total, operación, pago aplicado, pendiente y recepción posterior, distinguiendo aprobación, aplicación, confirmación, declaración y liquidación del proveedor. |
| DP-11 | Recepción posterior según condiciones: en cancha/karaoke el día del servicio; en salón/recreo según lo aceptado. No se presume liquidación del proveedor en esa fecha. |
| DP-12 | Rechazo, falta de verificación/aplicación o disponibilidad inválida impiden confirmar; aprobación aislada no confirma. No pueden existir confirmaciones incompatibles concurrentes ni aplicaciones duplicadas de pago. |

## 5. Registro de sustitución y pendientes

| Identificadores conservados | Antecedente sustituido | Cambio autorizado el 07/11/2026 |
|---|---|---|
| RC07; DF-06; DP-01 | Todos los pagos eran exclusivamente simulación académica; pasarela real fuera del MVP. | Pagos electrónicos reales como objetivo y propietario receptor; integración de producción condicionada. |
| DF-03/DF-04; DP-02/DP-12 | Adelanto simulado obligatorio como única condición financiera. | Opción total o adelanto configurado verificado y aplicado; demás condiciones y concurrencia conservadas. |
| DP-03/DP-04/DP-10 | Fijación y cálculo limitados al adelanto simulado. | Importe elegido fijado y pago aplicado; pendiente = total − aplicado; saldo posterior separado. |
| DF-05; DP-06–DP-08/DP-11 | Recepción y métodos solo académicos; estado Registrado como recibido en simulación. | Declaración de recepción real posterior, fecha/referencia aplicable y distinción respecto del proveedor. |
| DP-05/DP-09 | Saldo completo, sin fraccionamiento, historial obligatorio. | Se conservan esos límites y se exige aplicación idempotente; no se aprueba procedimiento técnico. |

La sustitución alcanza las menciones financieras de ADR-006 y los antecedentes de ADR-010/ADR-011; conserva sus decisiones de desacoplamiento, Redis y RabbitMQ. Las tareas 2–4 sincronizan Diseño, las seis fuentes C1–C4, AGENTS.md y arquitectura general con este alcance; los PNG y los informes históricos conservan antecedentes de simulación. Véase la auditoría del Sprint 01 (antecedente auxiliar local, fuera del repositorio). Esta sincronización documental no aprueba ADR-012, contratos, proveedor o producción.

Pendientes: viabilidad del candidato en Perú; vinculación/revocación de propietarios; métodos reales; liquidación y comisiones; políticas de conciliación y devolución; precisión monetaria; contratos de pago, aplicación y webhooks; carreras, recuperación, correcciones y presentación de saldo cero. Los mecanismos de concurrencia e idempotencia no se declaran implementados. No se seleccionan frameworks, ORM, motor relacional o servicios adicionales.
