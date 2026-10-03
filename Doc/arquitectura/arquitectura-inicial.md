# Arquitectura Inicial — UrbanPulse

La arquitectura inicial de **UrbanPulse** presenta una primera propuesta estructural para organizar los principales componentes del sistema, sus responsabilidades y las relaciones entre ellos.

Esta propuesta se basa en los actores, historias de usuario, requisitos funcionales, atributos de calidad, restricciones y drivers arquitectónicos identificados previamente.

---

# 1. Objetivo de la arquitectura inicial

La arquitectura inicial tiene como objetivo establecer una estructura que permita desarrollar UrbanPulse como una plataforma web para la **búsqueda, consulta de disponibilidad y reserva de establecimientos de entretenimiento y recreación**.

La arquitectura debe responder principalmente a los siguientes aspectos:

| Aspecto                                | Propósito                                                                                       |
| -------------------------------------- | ----------------------------------------------------------------------------------------------- |
| **Diferentes modalidades de reserva**  | Permitir que canchas, karaokes, salones y recreos tengan procesos de reserva diferentes.        |
| **Consistencia de disponibilidad**     | Evitar reservas incompatibles o duplicadas sobre un mismo recurso.                              |
| **Extensibilidad**                     | Facilitar la incorporación de nuevos tipos de establecimientos y modalidades.                   |
| **Seguridad**                          | Controlar las operaciones según el tipo de actor: cliente, propietario o administrador.         |
| **Mantenibilidad**                     | Mantener responsabilidades y módulos organizados para facilitar cambios.                        |
| **Integración con servicios externos** | Permitir la interacción con mapas, WhatsApp y pago simulado sin afectar las reglas principales. |
| **API REST**                           | Establecer el mecanismo de comunicación entre la aplicación web y el backend.                   |

---

# 2. Vista general de la arquitectura

UrbanPulse se organiza inicialmente en **tres capas principales**: presentación, lógica de negocio y datos.

| Capa                          | Responsabilidad principal                                | Componentes principales                                                                                                     |
| ----------------------------- | -------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **Capa de Presentación**      | Permitir la interacción de los usuarios con UrbanPulse.  | Aplicación Web, API REST.                                                                                                   |
| **Capa de Lógica de Negocio** | Gestionar las reglas y procesos principales del sistema. | Usuarios, establecimientos, recursos, disponibilidad, reservas, solicitudes/cotizaciones, servicios, pagos e integraciones. |
| **Capa de Datos**             | Almacenar la información persistente del sistema.        | Base de datos relacional.                                                                                                   |

El flujo general de comunicación será:

```text
Usuario
   │
   ▼
Aplicación Web
   │
   ▼
API REST
   │
   ▼
Lógica de Negocio
   │
   ▼
Base de Datos Relacional
```

Los servicios externos se mantienen fuera del núcleo principal de UrbanPulse:

```text
                 URBANPULSE
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
     Mapas        WhatsApp    Pago simulado
```

---

# 3. Diagrama de arquitectura inicial

La arquitectura inicial relaciona a los tres actores principales con la aplicación web y organiza el backend mediante módulos especializados.

| Elemento              | Componentes                                                                                                                 |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **Actores**           | Cliente, Propietario, Administrador.                                                                                        |
| **Presentación**      | Aplicación Web y API REST.                                                                                                  |
| **Lógica de negocio** | Usuarios, Establecimientos, Recursos, Disponibilidad, Reservas, Solicitudes/Cotizaciones, Servicios, Pagos e Integraciones. |
| **Persistencia**      | Base de datos relacional.                                                                                                   |
| **Sistemas externos** | Proveedor de mapas, WhatsApp y servicio de pago simulado.                                                                   |

La relación conceptual puede resumirse de la siguiente manera:

![Arquitectura inicial](../diagramas/arquitectura%20inicial.png)

---

# 4. Capa de Presentación

La **Capa de Presentación** proporciona la interfaz mediante la cual los actores interactúan con UrbanPulse.

Los actores principales son:

| Actor             | Interacción principal                                                             |
| ----------------- | --------------------------------------------------------------------------------- |
| **Cliente**       | Buscar establecimientos, consultar disponibilidad, reservar y consultar reservas. |
| **Propietario**   | Administrar establecimientos, recursos, disponibilidad y solicitudes.             |
| **Administrador** | Gestionar y supervisar los establecimientos de la plataforma.                     |

La aplicación web permitirá realizar principalmente:

| Operación                                 | Descripción                                                      |
| ----------------------------------------- | ---------------------------------------------------------------- |
| **Buscar establecimientos**               | Consultar las opciones disponibles dentro de UrbanPulse.         |
| **Consultar información**                 | Visualizar información y características del establecimiento.    |
| **Consultar disponibilidad**              | Revisar fechas, horarios, recursos o salas disponibles.          |
| **Realizar reservas**                     | Reservar directamente recursos disponibles.                      |
| **Solicitar reservas**                    | Generar solicitudes para modalidades que requieren coordinación. |
| **Consultar reservas**                    | Revisar reservas realizadas y sus estados.                       |
| **Administrar establecimientos**          | Gestionar información del establecimiento.                       |
| **Administrar recursos y disponibilidad** | Configurar recursos, horarios y disponibilidad.                  |

La comunicación entre la aplicación web y la lógica del sistema se realizará mediante una **API REST**.

```text
Usuario
   │
   ▼
Aplicación Web
   │
   ▼
API REST
```

---

# 5. Capa de Lógica de Negocio

La **Capa de Lógica de Negocio** constituye el núcleo funcional de UrbanPulse y concentra las reglas principales del sistema.

Se organiza inicialmente en los siguientes módulos:

| Módulo                         | Responsabilidad                                                                                 |
| ------------------------------ | ----------------------------------------------------------------------------------------------- |
| **Usuarios**                   | Gestionar usuarios, tipos de actor, perfiles y acceso a funcionalidades.                        |
| **Establecimientos**           | Gestionar información de canchas, karaokes, salones y recreos.                                  |
| **Recursos**                   | Representar los recursos reservables de cada establecimiento.                                   |
| **Disponibilidad**             | Determinar si un recurso puede reservarse para una fecha y periodo determinado.                 |
| **Reservas**                   | Crear, consultar, confirmar y cancelar reservas, además de gestionar su estado.                 |
| **Solicitudes / Cotizaciones** | Gestionar reservas que requieren coordinación, especialmente salones y recreos.                 |
| **Servicios**                  | Gestionar servicios asociados a una reserva, como sonido, decoración, catering, mesas y sillas. |
| **Pagos**                      | Gestionar inicialmente adelantos mediante un servicio de pago simulado.                         |
| **Integraciones externas**     | Comunicar UrbanPulse con mapas, WhatsApp y pago simulado sin acoplarlos al dominio principal.   |

## Usuarios

El módulo de usuarios considera tres actores:

| Tipo de usuario   | Responsabilidad general                                         |
| ----------------- | --------------------------------------------------------------- |
| **Cliente**       | Realizar consultas y operaciones relacionadas con sus reservas. |
| **Propietario**   | Gestionar establecimientos, recursos y solicitudes.             |
| **Administrador** | Administrar y supervisar la plataforma.                         |

---

## Establecimientos y recursos

UrbanPulse contempla inicialmente:

| Establecimiento | Recurso reservable |
| --------------- | ------------------ |
| **Cancha**      | Cancha de gras     |
| **Karaoke**     | Sala               |
| **Salón**       | Ambiente / salón   |
| **Recreo**      | Ambiente / espacio |

El módulo de recursos permite separar la información general del establecimiento del elemento específico que puede ser reservado.

---

## Disponibilidad

La disponibilidad se determina de manera diferente según la modalidad:

| Modalidad          | Información necesaria                |
| ------------------ | ------------------------------------ |
| **Cancha**         | Fecha + bloque horario               |
| **Karaoke**        | Fecha + sala + intervalo             |
| **Salón / Recreo** | Fecha + disponibilidad + condiciones |

Este módulo se encuentra directamente relacionado con el módulo de reservas.

---

## Reservas

El módulo de reservas gestiona:

- Creación de reservas.
- Consulta de reservas.
- Confirmación.
- Cancelación.
- Estado de la reserva.
- Relación con recursos.
- Relación con disponibilidad.

Las modalidades principales son:

| Tipo               | Forma de reserva             |
| ------------------ | ---------------------------- |
| **Cancha**         | Bloque horario               |
| **Karaoke**        | Sala + intervalo de tiempo   |
| **Salón / Recreo** | Fecha + servicios + adelanto |

---

## Solicitudes y cotizaciones

Los salones y recreos utilizan un proceso diferente a una reserva directa.

El flujo general será:

```text
Cliente
   ↓
Solicitud
   ↓
Disponibilidad
   ↓
Servicios
   ↓
Coordinación
   ↓
Precio / condiciones
   ↓
Adelanto
   ↓
Confirmación
```

Este módulo permite diferenciar una **solicitud de evento** de una **reserva directa**.

---

## Servicios

Los servicios pueden estar asociados principalmente a las reservas de salones y recreos.

| Servicio           | Ejemplo                       |
| ------------------ | ----------------------------- |
| **Mesas y sillas** | Equipamiento del evento       |
| **Sonido**         | Servicio incluido o adicional |
| **Decoración**     | Servicio opcional             |
| **Catering**       | Servicio opcional             |
| **Otros**          | Según el establecimiento      |

---

## Pagos

Durante el MVP, el módulo de pagos gestionará los adelantos mediante un servicio de **pago simulado**.

```text
Reserva
   ↓
Adelanto requerido
   ↓
Pago simulado
   │
   ├── APROBADO
   │      ↓
   │   Continuar confirmación
   │
   └── RECHAZADO
          ↓
       Mantener pendiente
```

No se contempla inicialmente una pasarela de pago real.

---

# 6. Capa de Datos

La **Capa de Datos** será responsable de almacenar la información persistente de UrbanPulse mediante una **base de datos relacional**.

Las principales entidades serán:

| Entidad             | Información que representa                           |
| ------------------- | ---------------------------------------------------- |
| **Usuario**         | Clientes, propietarios y administradores.            |
| **Establecimiento** | Información de canchas, karaokes, salones y recreos. |
| **Recurso**         | Elementos que pueden reservarse.                     |
| **Disponibilidad**  | Fechas, horarios e intervalos disponibles.           |
| **Reserva**         | Reservas realizadas dentro de la plataforma.         |
| **Solicitud**       | Solicitudes relacionadas con salones y recreos.      |
| **Servicio**        | Servicios asociados con establecimientos o reservas. |
| **Pago**            | Información de pagos o adelantos simulados.          |

Una relación conceptual inicial es:

```text
Usuario
   │
   └──── Reserva
             │
             ├── Establecimiento
             │
             ├── Recurso
             │
             ├── Disponibilidad
             │
             ├── Servicios
             │
             └── Pago
```

El modelo lógico y físico definitivo de la base de datos será desarrollado posteriormente.

---

# 7. Integración con servicios externos

La arquitectura inicial propone mantener las **integraciones externas separadas del dominio principal**, evitando que las reglas de reservas, disponibilidad y establecimientos dependan directamente de proveedores concretos.

| Integración            | Interfaz dentro de UrbanPulse | Función                                                    |
| ---------------------- | ----------------------------- | ---------------------------------------------------------- |
| **Proveedor de mapas** | Interfaz de mapas             | Visualizar la ubicación de los establecimientos.           |
| **WhatsApp**           | Interfaz de comunicación      | Permitir que el cliente contacte al propietario.           |
| **Pago simulado**      | Interfaz de pago              | Representar la aprobación o rechazo de un pago o adelanto. |

La estructura conceptual será:

```text
                    Núcleo de UrbanPulse
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
      Interfaz de      Interfaz de     Interfaz de
         mapas         comunicación       pago
             │              │              │
             ▼              ▼              ▼
      Proveedor de       WhatsApp      Pago simulado
          mapas
```

Esta separación permite que los detalles específicos de cada proveedor permanezcan fuera de las reglas principales del sistema.

Por ejemplo, si posteriormente se cambia el proveedor de mapas, la lógica relacionada con establecimientos, disponibilidad y reservas no debería requerir modificaciones importantes.

## Resumen de las integraciones externas

| Servicio          | Responsabilidad de UrbanPulse                                              | Fuera del núcleo                                |
| ----------------- | -------------------------------------------------------------------------- | ----------------------------------------------- |
| **Mapas**         | Proporcionar la ubicación registrada del establecimiento a la integración. | Implementación concreta del proveedor de mapas. |
| **WhatsApp**      | Redirigir al cliente hacia el contacto del propietario.                    | Conversaciones y gestión de mensajes.           |
| **Pago simulado** | Solicitar el procesamiento y recibir un resultado.                         | Implementación concreta del servicio de pago.   |

Con esta organización, UrbanPulse mantiene una separación clara entre la **presentación**, las **reglas de negocio**, la **persistencia** y los **servicios externos**, facilitando la mantenibilidad y evolución de la arquitectura.
