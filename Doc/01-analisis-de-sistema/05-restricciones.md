# Restricciones del Sistema

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
| **RC07** | **Pago simulado** | El MVP debe utilizar un mecanismo de pago simulado y no depender inicialmente de una pasarela de pago real. |
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
| **Cancha** | Recurso + fecha + bloque horario; confirmación directa sin adelanto obligatorio en el MVP. |
| **Karaoke** | Sala + fecha + intervalo de tiempo; confirmación directa sin adelanto obligatorio en el MVP. |
| **Salón de eventos** | Fecha + servicios + coordinación + adelanto |
| **Recreo** | Fecha + servicios + coordinación + adelanto |

La arquitectura no debe asumir que todos los establecimientos utilizan el mismo proceso de reserva.

Esta condición constituye una de las principales restricciones del diseño de UrbanPulse.

DF-01 delimita el recreo a eventos privados sobre un ambiente o espacio definido por el propietario. La información de actividades, comidas, entradas y hospedaje es consultable, sin compra de esos servicios ni reserva de habitaciones desde UrbanPulse. Para eventos, DF-02/DF-03 exigen registro de cotización y condiciones por el propietario, aceptación del cliente dentro de UrbanPulse, adelanto simulado aprobado y disponibilidad verificada antes de confirmar. Véanse las [decisiones funcionales aprobadas](#3-decisiones-funcionales-aprobadas-y-alcance-del-mvp).

---

### RC07 — Pago simulado

Durante el MVP no se integrará inicialmente una pasarela de pago real.

El sistema utilizará un mecanismo de pago simulado para representar el proceso de:

```text id="9y1uf7"
Solicitud de pago
      ↓
Pago simulado
      ↓
APROBADO / RECHAZADO
```

Esta decisión permite desarrollar y probar el flujo de reservas y adelantos sin depender inicialmente de un proveedor financiero real.

El servicio de pago es un sistema externo conceptual representado mediante una abstracción de integración. Durante el MVP, UrbanPulse implementa el componente de simulación que satisface esa abstracción; no implica conexión con una pasarela financiera real ni exige un despliegue externo del simulador. Esta descripción delimita la solución y no acredita que el componente o sus pruebas ya se hayan ejecutado. El adelanto obligatorio corresponde a eventos de salones y recreos; canchas y karaoke mantienen DF-04.

La integración con una pasarela de pago real podrá evaluarse en una etapa posterior.

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
| **Pago simulado** | Simular el resultado de un pago o adelanto. |

El cambio o sustitución de uno de estos servicios no debería requerir modificar innecesariamente las reglas principales relacionadas con reservas, disponibilidad o establecimientos.

La clasificación de pago como integración se refiere al contrato conceptual y al desacoplamiento, no a una conexión financiera real durante el MVP. El componente de simulación de UrbanPulse se mantiene detrás de ese contrato, conforme a RC07 y ADR-006.

## 3. Decisiones funcionales aprobadas y alcance del MVP

Estas decisiones consolidan el alcance aprobado para las cuatro modalidades. No constituyen nuevas HU, RF, RC, drivers ni ADR y no modifican los enunciados de las 13 HU o de los 19 RF.

| Decisión | Alcance aprobado | Respaldo y límite de formalización |
|---|---|---|
| DF-01 | El recreo permite reservar un ambiente o espacio definido por el propietario para un evento privado. | HU05/HU07/HU08, RF07/RF09/RF10 y RC06 aportan contexto. No incluye compra de actividades, comidas o entradas ni reserva de habitaciones. |
| DF-02 | El propietario registra la cotización y condiciones; el cliente las acepta dentro de UrbanPulse. | HU05/HU08 y RF07/RF10/RF12 aportan contexto, pero no expresan literalmente ambas acciones. **Precisión pendiente de formalización** de cobertura y criterios de aceptación, sin reescribir aquí las HU o los RF. WhatsApp solo complementa la coordinación. |
| DF-03 | Confirmar un evento requiere conjuntamente condiciones aceptadas por el cliente, adelanto simulado aprobado y disponibilidad verificada. | HU05/HU08/HU09; RF07/RF10–RF12/RF18/RF19. Ni la aceptación de la solicitud por el propietario, ni la disponibilidad, ni el adelanto aprobado bastan por separado. |
| DF-04 | Canchas y karaoke utilizan confirmación directa sin adelanto obligatorio en el MVP, previa verificación de disponibilidad. | RF04/RF06/RF12 y RC06. HU03/RF04 y HU04/RF06 conservan su asociación contextual pendiente; no se reformulan esas historias. |

La aprobación de estas decisiones no resuelve RF13, que permanece pendiente de validación funcional. La formalización de DF-02 y los detalles de estados, datos y criterios de aceptación deberán revisarse con la documentación funcional; no se inventan en esta corrección. Los escenarios correspondientes se consultan en [08-escenarios-atributos-calidad.md](08-escenarios-atributos-calidad.md).
