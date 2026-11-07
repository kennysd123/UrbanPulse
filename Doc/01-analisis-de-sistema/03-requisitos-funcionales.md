# Requisitos Funcionales — UrbanPulse

**Revisión de alcance financiero — 07/11/2026:** las decisiones funcionales de pagos reales sustituyen la exclusividad de simulación del MVP. Pago requerido significa pago total o adelanto configurado, verificado por el backend y aplicado una sola vez a la reserva. El proveedor sigue pendiente de validación; véanse [restricciones](05-restricciones.md) y [ADR-012](adr/ADR-012-modelo-pagos-mvp.md). No se acredita implementación ni aprobación de la integración de producción.

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
| **RF04** | El sistema debe permitir reservar directamente una cancha por recurso, fecha y bloque configurado, solo con pago total o adelanto configurado verificado y aplicado y disponibilidad válida al confirmar, impidiendo confirmaciones incompatibles concurrentes. | Canchas |
| **RF05** | El sistema debe permitir consultar la disponibilidad de una sala de karaoke por fecha y horario. | Karaoke |
| **RF06** | El sistema debe permitir reservar directamente karaoke por sala, fecha e intervalo, solo con pago total o adelanto configurado verificado y aplicado y disponibilidad válida al confirmar, impidiendo confirmaciones incompatibles concurrentes. | Karaoke |
| **RF07** | El sistema debe permitir solicitar la reserva de un salón o recreo indicando fecha, cantidad de personas y servicios requeridos. | Salones / Recreos |
| **RF08** | El sistema debe permitir al propietario gestionar la información de su establecimiento y sus condiciones de pago, identificando al propietario receptor sin presumir una vinculación financiera validada. | Gestión de establecimientos |
| **RF09** | El sistema debe permitir al propietario autorizado gestionar recursos, horarios y disponibilidad y configurar el adelanto por recurso de cancha o karaoke, sin alterar importes fijados de operaciones iniciadas; en eventos rigen las condiciones aceptadas. | Gestión de disponibilidad |
| **RF10** | El sistema debe permitir al propietario gestionar las solicitudes de reserva de salones y recreos. | Gestión de solicitudes |
| **RF11** | El sistema debe permitir elegir, iniciar y registrar un pago electrónico real del total o del adelanto configurado, mostrando y fijando total, adelanto, importe elegido y propietario receptor antes de enviarlo; los reintentos de la misma operación deben ser idempotentes. | Pagos |
| **RF12** | El sistema debe permitir confirmar una reserva solo con pago requerido verificado por backend y aplicado una vez y disponibilidad válida, aun bajo concurrencia; en eventos exige además condiciones aceptadas por el cliente dentro de UrbanPulse. El adelanto configurado es suficiente para la condición de pago. | Reservas |
| **RF13** | El sistema debe permitir cancelar una reserva de acuerdo con las condiciones definidas por el establecimiento. **Pendiente de validación funcional; sin HU de origen.** | Reservas |
| **RF14** | El sistema debe permitir al cliente consultar sus reservas y estados y al cliente y propietario autorizados consultar total, operación de pago, importe verificado y aplicado, pendiente y registro posterior del saldo, distinguiendo aprobación de confirmación y recepción declarada de verificación electrónica. | Reservas |
| **RF15** | El sistema debe permitir al administrador gestionar los establecimientos registrados en la plataforma. | Administración |
| **RF16** | El sistema debe permitir visualizar la ubicación de un establecimiento mediante un proveedor externo de mapas. | Ubicación |
| **RF17** | El sistema debe permitir redirigir al cliente hacia WhatsApp para contactar al propietario. | Comunicación |
| **RF18** | El sistema debe verificar en backend los resultados del proveedor, validando autenticidad y correlación de notificaciones y contrastando estado, operación, importe, moneda y propietario receptor mediante el proveedor. Debe procesar pagos y webhooks idempotentemente; nunca confiar solo en el navegador. | Pagos electrónicos |
| **RF19** | El sistema debe reflejar el resultado verificado del pago en la situación de la reserva, sin confirmar por aprobación aislada ni aplicar dos veces un pago. Debe conservar trazabilidad de pagos aprobados sin confirmación para conciliación y devolución cuando corresponda, sin borrar la aprobación ni fingir devolución completada. | Reservas / Pagos |
| **RF20** | El sistema debe permitir al propietario autorizado registrar la recepción posterior del saldo completo positivo de una reserva confirmada propia, con método, importe, fecha y referencia cuando corresponda, autor y fecha/hora del registro; una recepción activa e historial de correcciones, sin modificar Reserva ni el resultado electrónico. | Pagos |

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
| **HU09 — Pagar total o adelanto** | RF11, RF18, RF19 |
| **HU10 — Consultar reservas** | RF14 (consulta del resumen ampliada por DP-10) |
| **HU14 — Registrar recepción posterior del saldo completo** | RF20; RF14 para consulta del propietario |
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

Las [DF-01–DF-06 y DP-01–DP-12](05-restricciones.md) mantienen sus identificadores y registran la sustitución del alcance simulado. RF04/RF06/RF12 aplican pago requerido verificado y aplicado, disponibilidad válida y prohibición de confirmaciones incompatibles concurrentes; eventos requieren además aceptación interna. El pago total y el adelanto configurado satisfacen la condición de pago; una aprobación aislada no confirma.

**DF-02 continúa pendiente de formalización detallada:** HU05/HU08 y RF07/RF10/RF12 aportan contexto para cotización y aceptación. No se inventa cobertura directa de ambas acciones ni se sustituye la aceptación interna con WhatsApp.

RF11 cubre inicio e idempotencia de operación; RF18 verifica al proveedor y deduplica notificaciones; RF19 distingue resultado, aplicación y confirmación y conserva pendientes de conciliación/devolución. RF14 muestra el resumen autorizado; RF20 registra recepción posterior completa. La identificación y vinculación del propietario receptor son condiciones para habilitar pagos, sin afirmar que RF08 apruebe una implementación OAuth o cubra por sí solo todo el onboarding.

La cadena se consulta en [HU](02-historias-del-usuarios.md) → este documento → [AC](04-atributos-de-calidad.md) / [RC](05-restricciones.md) → [DA](06-driver-arquitectonicos.md) → [ADR](07-decisiones-arquitectonicas.md) → [EQ](08-escenarios-atributos-calidad.md). La matriz de ADR-012 distingue origen y contexto.

Se conservan los orígenes de DA: RF18 en DA06 para integración; RF11/RF19 en DA08 para persistencia y trazabilidad; RF14/RF20 en DA05 y DA08. RF11/RF19 son contexto de DA06, sin añadirles un origen implícito. RF02/RF09/RF10 continúan sin origen explícito en drivers; RF04/RF06 conservan HU contextual y RF13 queda fuera del alcance confirmado. AC02/AC07 siguen sin driver explícito.

## 6. Control de alcance e identificadores

**20 RF catalogados: 19 de alcance establecido y RF13 pendiente.** No se crea RF21 ni se aprueba cancelación por introducir devolución financiera de un pago aprobado sin confirmación. La integración de producción, sus contratos y los mecanismos técnicos permanecen por aprobar y validar; el alcance funcional no acredita implementación.

Se reformulan RF04/RF06/RF08/RF09/RF11/RF12/RF14/RF18/RF19/RF20 bajo sus mismos ID. RF18 deja de simular resultados y pasa a exigir verificación del proveedor e idempotencia. RF19 añade conciliación y devolución cuando corresponda; RF20 conserva recepción completa, autorización, unicidad activa e historial, y añade la fecha de recepción y referencia aplicable. El resto de RF conserva su significado.

Importe pendiente = total acordado − pago verificado y aplicado. La recepción manual posterior se consulta separadamente y no se vuelve a descontar como si fuera el mismo pago electrónico. Pago total aplicado implica pendiente cero, sin recepción ficticia. No se habilitan pagos parciales posteriores del saldo. Contratos monetarios, representación de cero, correcciones, recuperación y política de devolución siguen pendientes en ADR-012 y el informe de esta revisión.

**Historial:** la exclusividad de simulación de RF11/RF18/RF20 y la obligatoriedad de adelanto como única opción de RF04/RF06/RF12 quedan sustituidas para el MVP objetivo por la solicitud del 07/11/2026. Sus antecedentes se conservan en Git y en el registro de sustitución de [restricciones](05-restricciones.md#5-registro-de-sustitución-y-pendientes).
