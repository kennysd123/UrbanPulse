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

La estructura inicial del repositorio contempla:

```text
UrbanPulse
│
├── README.md
├── .gitignore
│
└── Doc
    ├── analisis-de-sistema
    └── arquitectura
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
| **Cancha** | Recurso + bloque horario |
| **Karaoke** | Sala + intervalo de tiempo |
| **Salón de eventos** | Fecha + servicios + coordinación + adelanto |
| **Recreo** | Fecha + servicios + coordinación + adelanto |

La arquitectura no debe asumir que todos los establecimientos utilizan el mismo proceso de reserva.

Esta condición constituye una de las principales restricciones del diseño de UrbanPulse.

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

Podrá utilizarse Google Maps u otro servicio compatible.

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
| **WhatsApp** | Facilitar la comunicación entre cliente y propietario. |
| **Pago simulado** | Simular el resultado de un pago o adelanto. |

El cambio o sustitución de uno de estos servicios no debería requerir modificar innecesariamente las reglas principales relacionadas con reservas, disponibilidad o establecimientos.