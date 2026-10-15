# Requisitos Funcionales — UrbanPulse

Los requisitos funcionales describen las funciones que el sistema
UrbanPulse debe realizar para satisfacer las necesidades identificadas
en las historias de usuario.

Cada requisito se expresa desde la perspectiva de lo que el sistema
debe permitir realizar.

**Estado de RF13:** se conserva su identificador y formulación para mantener el historial documental, pero la cancelación está **pendiente de validación funcional** y no se considera parte del alcance confirmado del MVP. Véase la sección 4.

---

## 1. Resumen de requisitos funcionales

| ID | Requisito funcional | Área |
|---|---|---|
| **RF01** | El sistema debe permitir buscar establecimientos mediante criterios como categoría, ubicación y disponibilidad. | Descubrimiento |
| **RF02** | El sistema debe permitir consultar la información de un establecimiento. | Establecimientos |
| **RF03** | El sistema debe permitir consultar la disponibilidad de una cancha por fecha y horario. | Canchas |
| **RF04** | El sistema debe permitir reservar directamente una cancha por recurso, fecha y bloque configurado, solo con adelanto simulado aprobado y disponibilidad válida al confirmar. | Canchas |
| **RF05** | El sistema debe permitir consultar la disponibilidad de una sala de karaoke por fecha y horario. | Karaoke |
| **RF06** | El sistema debe permitir reservar directamente karaoke por sala, fecha e intervalo, solo con adelanto simulado aprobado y disponibilidad válida al confirmar. | Karaoke |
| **RF07** | El sistema debe permitir solicitar la reserva de un salón o recreo indicando fecha, cantidad de personas y servicios requeridos. | Salones / Recreos |
| **RF08** | El sistema debe permitir al propietario gestionar la información de su establecimiento y sus condiciones, identificando el carácter simulado de todos los pagos del MVP. | Gestión de establecimientos |
| **RF09** | El sistema debe permitir al propietario autorizado gestionar recursos, horarios y disponibilidad y configurar el importe del adelanto por recurso de cancha o karaoke, sin alterar importes fijados de operaciones ya iniciadas. | Gestión de disponibilidad |
| **RF10** | El sistema debe permitir al propietario gestionar las solicitudes de reserva de salones y recreos. | Gestión de solicitudes |
| **RF11** | El sistema debe permitir iniciar y registrar el adelanto simulado, obligatorio en cancha y karaoke y según condiciones aceptadas en eventos, mostrando previamente total y adelanto y fijando ambos al iniciar la operación. | Pagos |
| **RF12** | El sistema debe permitir confirmar una reserva solo con disponibilidad válida y adelanto simulado aprobado; en eventos exige además condiciones aceptadas por el cliente dentro de UrbanPulse. | Reservas |
| **RF13** | El sistema debe permitir cancelar una reserva de acuerdo con las condiciones definidas por el establecimiento. **Pendiente de validación funcional; sin HU de origen.** | Reservas |
| **RF14** | El sistema debe permitir al cliente consultar sus reservas y estados y al cliente y propietario autorizados consultar el resumen simulado de total acordado, adelanto aprobado y aplicado, saldo y estado de registro. | Reservas |
| **RF15** | El sistema debe permitir al administrador gestionar los establecimientos registrados en la plataforma. | Administración |
| **RF16** | El sistema debe permitir visualizar la ubicación de un establecimiento mediante un proveedor externo de mapas. | Ubicación |
| **RF17** | El sistema debe permitir redirigir al cliente hacia WhatsApp para contactar al propietario. | Comunicación |
| **RF18** | El sistema debe permitir simular aprobación o rechazo del adelanto, sin cobros, transferencias ni integraciones financieras reales. | Pago simulado |
| **RF19** | El sistema debe reflejar el resultado del adelanto simulado en la situación de la reserva, sin confirmar por aprobación aislada ni cambiar el estado de Reserva por registrar el saldo. | Reservas / Pagos |
| **RF20** | El sistema debe permitir al propietario autorizado registrar manualmente la recepción simulada del saldo completo de una reserva confirmada, indicando el importe y el método de pago seleccionado, y conservando la trazabilidad de las operaciones y correcciones, sin ejecutar transacciones financieras reales. | Pagos simulados |

---

## 2. Relación entre Historias de Usuario y Requisitos Funcionales

La siguiente relación registra la cobertura identificada en [02-historias-del-usuarios](02-historias-del-usuarios.md). RF04 y RF06 tienen asociación contextual con HU03 y HU04; RF13 no tiene una HU de origen respaldada. Estas limitaciones se detallan en la sección 4.

| Historia de usuario | Requisitos funcionales relacionados |
|---|---|
| **HU01 — Buscar establecimientos** | RF01 |
| **HU02 — Consultar información** | RF02 |
| **HU03 — Consultar disponibilidad de cancha** | RF03; RF04 como asociación contextual con la reserva por bloques |
| **HU04 — Consultar disponibilidad de karaoke** | RF05; RF06 como asociación contextual con la reserva de sala + tiempo |
| **HU05 — Solicitar reserva de salón o recreo** | RF07 |
| **HU06 — Administrar establecimiento** | RF08 |
| **HU07 — Administrar recursos y disponibilidad** | RF09 |
| **HU08 — Gestionar solicitudes** | RF10, RF12 |
| **HU09 — Realizar adelanto** | RF11, RF18, RF19 |
| **HU10 — Consultar reservas** | RF14 (consulta del resumen ampliada por DP-10) |
| **HU14 — Registrar recepción simulada del saldo** | RF20; RF14 para consulta del propietario |
| **HU11 — Gestionar establecimientos** | RF15 |
| **HU12 — Contactar mediante WhatsApp** | RF17 |
| **HU13 — Visualizar ubicación** | RF16 |

---

## 3. Matriz de trazabilidad HU → RF

![Matriz de trazabilidad HU a RF](<../diagramas/matriz-HU-→-RF.png>)

La imagen no distingue las asociaciones contextuales de RF04 y RF06. Debe leerse junto con la tabla y las limitaciones siguientes; su actualización gráfica queda pendiente.

## 4. Cobertura y pendientes de validación

| Elemento | Evidencia existente | Estado |
|---|---|---|
| RF04 | HU03 consulta disponibilidad para reservar un bloque; la modalidad de reserva de cancha está confirmada. | Se mantiene el RF y la denominación real de HU03. Pendiente precisar la cobertura de la acción de reservar en la historia existente. |
| RF06 | HU04 consulta disponibilidad para seleccionar una sala; la modalidad de reserva de sala + tiempo está confirmada. | Se mantiene el RF y la denominación real de HU04. Pendiente precisar la cobertura de la acción de reservar en la historia existente. |
| RF13 | HU10 solo consulta reservas; HU08 gestiona solicitudes de salones y recreos, no cancelaciones de reservas. No hay otra HU que cubra esta acción explícita o implícitamente. | Pendiente validar la necesidad de cancelación, quién podría realizarla y sus condiciones. No se inventa una HU ni se da por aprobada la funcionalidad. |

La aparición de cancelación en la arquitectura inicial o en los PNG no resuelve la falta de origen funcional de RF13. Se conserva como antecedente pendiente, no como evidencia de aprobación.

## 5. Continuidad de la trazabilidad

Las [decisiones funcionales DF-01–DF-06](05-restricciones.md#3-decisiones-funcionales-aprobadas-y-alcance-del-mvp) precisan el alcance con las ampliaciones explícitas de los RF existentes y la incorporación de RF20. DF-01 delimita RF07 al ambiente o espacio definido por el propietario para un evento privado en recreos. DF-03 precisa RF12: un evento solo se confirma con condiciones aceptadas por el cliente, adelanto simulado aprobado y disponibilidad verificada; RF19 no convierte un resultado aprobado de pago en confirmación automática. DF-04 precisa RF04/RF06 como confirmación directa con adelanto simulado obligatorio y disponibilidad válida al confirmar, manteniendo sus asociaciones HU contextuales pendientes.

**Precisión pendiente de formalización — DF-02:** RF07, RF10 y RF12 aportan contexto para solicitudes, gestión y confirmación, pero no detallan el registro de cotización y sus criterios de aceptación. RF12 ya explicita la aceptación interna como condición, sin resolver todos sus detalles. La decisión funcional está aprobada; su cobertura explícita y criterios de aceptación en HU/RF deben formalizarse posteriormente, sin crear requisitos adicionales para esa formalización pendiente. WhatsApp no sustituye la aceptación interna.

RF11/RF18/RF19 utilizan la abstracción de pago simulado implementada por UrbanPulse durante el MVP; no requieren conectarse con una pasarela financiera real ni acreditan implementación o pruebas realizadas.

La cadena documental se consulta en [02-historias-del-usuarios](02-historias-del-usuarios.md) → este documento → [04-atributos-de-calidad](04-atributos-de-calidad.md) / [05-restricciones](05-restricciones.md) → [06-driver-arquitectonicos](06-driver-arquitectonicos.md) → [07-decisiones-arquitectonicas](07-decisiones-arquitectonicas.md). Las relaciones explícitas se registran en las tablas de drivers y ADR; no se presume cobertura completa por la sola existencia de un requisito.

Las relaciones directas RF → driver actualmente documentadas cubren RF01, RF03–RF08, RF11, RF12 y RF14–RF20. RF02, RF09 y RF10 no tienen todavía una relación de origen explícita en las tablas de drivers; esto no invalida sus HU de origen. La ampliación explícita de DA05/DA08 añade RF11/RF14/RF19/RF20; la influencia de RF02/RF09/RF10 sigue pendiente. RF13 permanece fuera de la cadena confirmada.

## 6. Control de alcance y cantidades

Se conservan RF01–RF19 y se incorpora RF20: **20 RF catalogados, 19 aprobados y RF13 pendiente**. La petición de “20 RF aprobados” no es compatible con conservar RF13 sin aprobar y no agregar RF21; se registra esta inconsistencia sin cambiar su estado.

Las formulaciones ampliadas de RF04/RF06/RF08/RF09/RF11/RF12/RF14/RF18/RF19 explicitan DF-04–DF-06 y DP-01–DP-12. RF14 cubre DP-10 para ambos actores autorizados; no se crea RF21. HU07 respalda configuración, HU09 adelantos, HU10 consulta del cliente y HU14 registro, correcciones y consulta del propietario. HU03/HU04 conservan su alcance literal de consulta.

RF20 registra reserva asociada, importe completo del saldo, método (efectivo, Yape, Plin o transferencia), propietario autor, fecha y hora. Exige reserva confirmada propia, un solo registro activo y correcciones con historial, autor y fecha; no admite fraccionamiento ni cambia Reserva o adelanto. El caso de saldo cero queda pendiente de representación sin recepción inventada. Métodos y resultados son simulados, sin comprobantes bancarios ni evidencia de fondos reales (DF-06).

RF20 tiene influencia revisada sobre DA05 (autorización) y DA08 (trazabilidad persistente), desarrollada como ampliación en el documento de drivers. No se le atribuye una integración financiera ni se completan relaciones antiguas por analogía.
