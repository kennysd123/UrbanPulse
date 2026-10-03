# Requisitos Funcionales — UrbanPulse

Los requisitos funcionales describen las funciones que el sistema
UrbanPulse debe realizar para satisfacer las necesidades identificadas
en las historias de usuario.

Cada requisito se expresa desde la perspectiva de lo que el sistema
debe permitir realizar.

---

## 1. Resumen de requisitos funcionales

| ID | Requisito funcional | Área |
|---|---|---|
| **RF01** | El sistema debe permitir buscar establecimientos mediante criterios como categoría, ubicación y disponibilidad. | Descubrimiento |
| **RF02** | El sistema debe permitir consultar la información de un establecimiento. | Establecimientos |
| **RF03** | El sistema debe permitir consultar la disponibilidad de una cancha por fecha y horario. | Canchas |
| **RF04** | El sistema debe permitir reservar una cancha seleccionando un bloque horario disponible. | Canchas |
| **RF05** | El sistema debe permitir consultar la disponibilidad de una sala de karaoke por fecha y horario. | Karaoke |
| **RF06** | El sistema debe permitir reservar una sala de karaoke seleccionando la sala, fecha y horario disponible. | Karaoke |
| **RF07** | El sistema debe permitir solicitar la reserva de un salón o recreo indicando fecha, cantidad de personas y servicios requeridos. | Salones / Recreos |
| **RF08** | El sistema debe permitir al propietario gestionar la información de su establecimiento. | Gestión de establecimientos |
| **RF09** | El sistema debe permitir al propietario gestionar los recursos, horarios y disponibilidad de su establecimiento. | Gestión de disponibilidad |
| **RF10** | El sistema debe permitir al propietario gestionar las solicitudes de reserva de salones y recreos. | Gestión de solicitudes |
| **RF11** | El sistema debe permitir registrar un adelanto mediante un servicio de pago simulado. | Pagos |
| **RF12** | El sistema debe permitir confirmar una reserva cuando se hayan cumplido las condiciones requeridas. | Reservas |
| **RF13** | El sistema debe permitir cancelar una reserva de acuerdo con las condiciones definidas por el establecimiento. | Reservas |
| **RF14** | El sistema debe permitir al cliente consultar sus reservas y el estado de cada una. | Reservas |
| **RF15** | El sistema debe permitir al administrador gestionar los establecimientos registrados en la plataforma. | Administración |
| **RF16** | El sistema debe permitir visualizar la ubicación de un establecimiento mediante un proveedor externo de mapas. | Ubicación |
| **RF17** | El sistema debe permitir redirigir al cliente hacia WhatsApp para contactar al propietario. | Comunicación |
| **RF18** | El sistema debe permitir simular la aprobación o rechazo de un pago o adelanto. | Pago simulado |
| **RF19** | El sistema debe actualizar el estado de una reserva según el resultado del proceso de pago simulado. | Reservas / Pagos |

---

## 2. Relación entre Historias de Usuario y Requisitos Funcionales

La siguiente relación permite comprobar que las funcionalidades identificadas responden a las historias de usuario previamente definidas.

| Historia de usuario | Requisitos funcionales relacionados |
|---|---|
| **HU01 — Buscar establecimientos** | RF01 |
| **HU02 — Consultar información** | RF02 |
| **HU03 — Consultar disponibilidad de cancha** | RF03 |
| **HU03 — Reservar cancha** | RF04 |
| **HU04 — Consultar disponibilidad de karaoke** | RF05 |
| **HU04 — Reservar karaoke** | RF06 |
| **HU05 — Solicitar reserva de salón o recreo** | RF07 |
| **HU06 — Administrar establecimiento** | RF08 |
| **HU07 — Administrar recursos y disponibilidad** | RF09 |
| **HU08 — Gestionar solicitudes** | RF10, RF12 |
| **HU09 — Realizar adelanto** | RF11, RF18, RF19 |
| **HU10 — Consultar reservas** | RF14 |
| **HU11 — Gestionar establecimientos** | RF15 |
| **HU12 — Contactar mediante WhatsApp** | RF17 |
| **HU13 — Visualizar ubicación** | RF16 |

---

## 3. Matriz de trazabilidad HU → RF

![Matriz de trazabilidad HU → RF](../diagramas/Matriz%20de%20trazabilidad%20HU%20%E2%86%92%20RF.png)

