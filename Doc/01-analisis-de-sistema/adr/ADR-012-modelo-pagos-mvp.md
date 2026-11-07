# ADR-012 — Modelo de pagos del MVP y proveedor candidato

**Fecha:** 07/11/2026. **Estado:** alcance funcional establecido por solicitud; decisiones arquitectónicas propuestas; proveedor candidato y capacidades pendientes de verificación. **No aprobada para integración de producción.** No acredita implementación, despliegue o pruebas.

## 1. Contexto y sustitución histórica

UrbanPulse mantiene Monolito Modular, Clean Architecture de Presentación, Aplicación, Dominio e Infraestructura, ocho módulos (Usuarios, Establecimientos, Recursos, Disponibilidad, Reservas, Solicitudes, Servicios y Pagos), API REST y persistencia relacional definitiva sin motor seleccionado. Pagos evoluciona del nombre histórico Pagos Simulados sin crear un noveno módulo. Redis contiene fichas públicas reconstruibles; RabbitMQ conserva únicamente invalidaciones técnicas.

La solicitud del 07/11/2026 sustituye RC07, DF-06, DP-01 y las precisiones de pago exclusivamente simulado de ADR-006 para el alcance objetivo. DF-03/DF-04 y DP-02 admiten total o adelanto configurado; DF-05 y RF20 evolucionan a registro de recepción posterior real. Se conservan identificadores e historia en el [registro de sustitución](../05-restricciones.md#5-registro-de-sustitución-y-pendientes) y Git. Los cierres de ADR-010/ADR-011 se conservan; sus presupuestos financieros antiguos no amplían ni limitan esta evolución autorizada.

## 2. Decisiones funcionales establecidas

1. Cliente elige pago total o adelanto configurado por el propietario; se muestran y fijan importes, condiciones y receptor antes de iniciar. No se impone porcentaje o tarifa universal.
2. Un adelanto requerido verificado y aplicado satisface la condición financiera y permite confirmar si se cumplen las demás condiciones. Pago aprobado por sí solo no confirma. Cancha/karaoke conservan reserva directa; salón/recreo requieren solicitud, cotización y aceptación interna.
3. Importe pendiente = total acordado − pago verificado y aplicado a la reserva. Pago total aplicado implica cero; pago aprobado sin aplicación no se descuenta. El registro posterior del saldo se consulta separadamente para no volver a cobrarlo ni descontar dos veces el mismo importe.
4. Solo propietario autorizado registra recepción posterior del saldo completo positivo de su reserva confirmada, con método, importe, fecha de recepción y referencia cuando corresponda, autor y fecha/hora de registro. Una recepción activa, correcciones históricas y consulta autorizada. Sin fraccionamientos posteriores ni recepción ficticia por saldo cero.
5. Pagos electrónicos reales en el MVP objetivo. Fondos correspondientes al propietario receptor; UrbanPulse no recauda para redistribuir manualmente. No se aprueba comisión de plataforma ni liquidación propia de fondos.
6. Backend verifica resultados del proveedor, nunca solo navegador. Pagos/webhooks idempotentes y ninguna confirmación incompatible aun con concurrencia. No se declaran mecanismos implementados.
7. Aprobados sin reserva confirmada conservan evidencia para conciliación y devolución cuando corresponda. Esto no aprueba RF13 ni define política de cancelación, expiración, crédito o reapertura.

Respaldo: HU07/HU09/HU10/HU14; RF04/RF06/RF09/RF11/RF12/RF14/RF18/RF19/RF20; DF-03–DF-06 y DP-01–DP-12 revisados. Las limitaciones HU03/RF04, HU04/RF06 y formalización detallada DF-02 permanecen explícitas.

## 3. Decisiones arquitectónicas propuestas

Son propuestas revisables para satisfacer obligaciones establecidas, no tecnologías ni contratos adoptados:

| Responsabilidad | Frontera propuesta | Invariante o límite |
|---|---|---|
| Operación de pago | Módulo Pagos coordina creación y consulta mediante puerto; adaptador del proveedor en Infraestructura. | Conserva operación interna, reserva o intento correlacionado, propietario receptor, total, opción/importe, moneda, referencias y evidencia verificada. Creación exacta de Reserva y cardinalidades pendientes. |
| Webhook | Presentación recibe; adaptador valida autenticidad según contrato del proveedor; Aplicación contrasta la operación por canal servidor a servidor. | El mensaje es señal para verificar, no autoridad suficiente. Contrastar estado, importe, moneda, receptor y correlación. Browser return solo informa navegación. |
| Aplicación del importe | Caso de uso coordina Pagos y Reserva mediante interfaces públicas internas, con evidencia mínima auditable. | Aplicación única por pago; dos eventos diferentes sobre el mismo pago no producen dos aplicaciones. Una operación rechazada o incierta no aporta importe aplicado. |
| Confirmación | Reserva expresa condiciones; Disponibilidad colabora mediante contrato público; persistencia relacional preserva invariantes. | Verificar pago requerido, aceptación cuando corresponda y compatibilidad de forma que ninguna carrera confirme incompatibles. Lectura seguida de escritura sin garantía no basta. |
| Registro posterior | Caso de uso separado de confirmación y del adaptador electrónico. Propiedad modular y contrato persistido por definir. | Recepción declarada por propietario no es aprobación del proveedor; no modifica Reserva ni el resultado electrónico. Unicidad activa e historial preservados. |
| Conciliación y devolución | Coordinación explícita de Pagos con evidencia persistente y acceso autorizado al proveedor; responsables y ejecución por definir. | Aprobación sin confirmación no se pierde, no fuerza reserva, no se borra ni se transforma en rechazo. Devolución requiere evidencia de resultado y evita duplicados. |

Dominio expresa invariantes sin tipos de SDK, credenciales, RabbitMQ ni estados particulares del proveedor. Aplicación coordina; Infraestructura implementa adaptadores y repositorios hacia el núcleo. El navegador no controla estados financieros. Credenciales de cada receptor y evidencia sensible requieren protección y permisos mínimos; mecanismo concreto pendiente.

### Concurrencia, idempotencia y recuperación por diseñar

- Definir identidad de operación/reintento y semántica de una solicitud repetida frente a una nueva intención. Evaluar idempotencia del proveedor al iniciar/reembolsar; timeout no autoriza crear automáticamente otro cobro.
- Diseñar deduplicación persistente de notificaciones y aplicación única de la operación financiera, incluso entre consulta, webhook y reintento concurrentes; contratos de retención y respuesta pendientes. Deduplicar solo ID de evento no basta ante eventos distintos del mismo pago.
- Diseñar unidad transaccional o protocolo de recuperación para aplicación, confirmación y registro definitivo, sin asumir transacción distribuida con el proveedor. La confirmación incompatible y la aplicación duplicada deben ser imposibles bajo el mecanismo validado. No se aprueban aquí bloqueos, nivel de aislamiento, restricciones físicas concretas, retenciones o expiraciones.
- Conservar estados inciertos y evidencia recuperable si falla la consulta, si se cobra antes de persistir o si el proceso cae antes de responder. Reconsultar/conciliar con evidencia autoritativa; no convertir un timeout en rechazo o aprobación. Tratar eventos fuera de orden sin degradar hechos verificados; reglas y estados técnicos pendientes.
- Si la aprobación llega sin disponibilidad o aceptación, conservar correlación, receptor, importe, motivo, intentos y resolución pendiente. Definir cómo detectar aprobaciones no registradas tras una caída y quién resuelve; sin prometer recuperación automática de intenciones nunca conservadas.
- Definir devolución cuando corresponda: elegibilidad, importe, iniciador autorizado, correlación, resultado incierto, reintentos y evidencia final. No prometer devolución instantánea, automática ni liquidación financiera atómica con la reserva.

PC-05/PC-07/PC-08 del Diseño deben evolucionar para este alcance; las obligaciones están establecidas, sus mecanismos y políticas siguen abiertos. No se adoptan Outbox, inbox, scheduler, cola financiera o servicio adicional por esta descripción.

## 4. Proveedor candidato y capacidades pendientes

**Mercado Pago Marketplace Split 1:1 es candidato, NO integración aprobada ni validada.** La existencia de documentación bajo dominio peruano no prueba habilitación comercial, elegibilidad de UrbanPulse o soporte de todos los medios requeridos en Perú.

Consulta documental exploratoria del 07/11/2026, sin credenciales, cuentas vinculadas ni pruebas: la guía de [configuración de Split 1:1](https://www.mercadopago.com.pe/developers/es/docs/split-payments/split-1-1/integration-configuration/create-configuration) describe vinculación de vendedores por OAuth. Es referencia para evaluar, no selección de contrato de UrbanPulse.

La guía de [integración del checkout Split 1:1](https://www.mercadopago.com.pe/developers/es/docs/split-payments/split-1-1/integration-configuration/integrate-marketplace) describe uso de credenciales del vendedor y reparto automático. También documenta límites de fondos en cuenta y reembolso total cuando el vendedor carece de saldo. Sus ejemplos y límites requieren aclaración oficial para el producto/cuentas/país concretos: no justifican afirmar soporte de tarjetas, Yape, Plin, transferencias externas o devolución garantizada. No se copian sus ejemplos monetarios como decisiones locales.

| Verificación pendiente | Evidencia necesaria antes de aprobar |
|---|---|
| Perú y elegibilidad | Confirmación oficial vigente de disponibilidad Split 1:1 para cuentas peruanas y actividad del proyecto; habilitación comercial/técnica, requisitos y restricciones aplicables. |
| Propietario receptor | Alta/autorización, identidad de receptor, permisos, renovación y revocación; demostrar que el pago corresponde al propietario correcto sin redistribución manual de UrbanPulse. No habilitar cobro con vinculación ausente o inválida. |
| Medios y experiencia | Matriz comprobada por producto/país/cuenta de medios electrónicos realmente disponibles, moneda, límites, estados y pruebas. Métodos declarados del saldo no prueban soporte electrónico. Checkout sin selección aprobada. |
| Total y adelanto | Demostrar ambas opciones con importes fijados, referencia inequívoca y aplicación única; precisar comisiones y su relación con importe aplicado sin restar automáticamente tarifas del proveedor al pago reconocido al cliente. |
| Notificaciones y consultas | Contrato de autenticidad, correlación, consulta autoritativa, orden, duplicados, reintentos y resultados inciertos; distinguir entrega técnica de aprobación/aplicación. |
| Devoluciones | Permisos, total/parcial si corresponde a la política futura, requisitos de saldo, comisiones y responsabilidades, resultado incierto e idempotencia; evidencia verificable de devolución o excepción, sin asumir fondos disponibles del vendedor. |
| Liquidación | Destino efectivo, plazos, disponibilidad/retiro, netos y comisiones, reportes y conciliación por receptor. Pago aprobado no equivale a fondos liquidados ni retiro inmediato. |
| Operación y seguridad | Custodia de credenciales, separación de entornos, revocación, acceso mínimo, soporte de incidentes y evidencia auditable sin exposición de secretos; revisión de responsabilidades contractuales. |

Estas verificaciones deben producir una decisión explícita de aprobar, ajustar o descartar el candidato. Documentación pública o sandbox por sí solos no prueban liquidación y reembolso operativos en producción.

## 5. RabbitMQ, Redis y worker

ADR-010/ADR-011 se conservan con sus ámbitos. RabbitMQ sigue como broker de invalidaciones técnicas de fichas Redis; consumidor dentro del backend en el MVP. Worker independiente: **Preparado arquitectónicamente, no obligatorio inicialmente**.

La futura extracción mantendrá puerto de consumo, adaptador RabbitMQ y frontera autorizada de invalidación; reutilizará coordinación técnica sin modificar dominio. Su composición y operación se decidirán después. No es microservicio, módulo funcional adicional ni requisito de proceso separado inicial. No se crean diagramas o desplegables.

No usar RabbitMQ automáticamente para confirmar pagos o conciliar ni ampliar ADR-011 a finanzas. Tal uso exige una decisión arquitectónica independiente. El requisito de idempotencia financiera no se resuelve con ACK/reintentos de invalidaciones. Redis no almacena autoridad financiera, reservas, disponibilidad ni evidencia contractual.

## 6. Alternativas evaluadas

| Alternativa | Evaluación y estado |
|---|---|
| Mantener todo simulado | Útil como doble de prueba, insuficiente para el nuevo objetivo real; sustituida como restricción general. |
| UrbanPulse recauda y redistribuye manualmente | Incompatible con la decisión funcional; descartada para el MVP. |
| Split 1:1 con propietario vinculado | Candidata a satisfacer recepción sin redistribución manual; pendiente de verificación comercial/técnica y de reembolsos/liquidación en Perú. No adoptada. |
| Otro proveedor con cobro para propietario receptor | Alternativa si el candidato falla los criterios; evaluar con los mismos invariantes mediante adaptador, sin seleccionar proveedor adicional ahora. |
| Confirmar por navegador o aprobación aislada | Incompatible con verificación backend y condiciones de negocio; descartada. |
| Retención temporal o confirmación mediante cola financiera | Alternativas de coordinación que requerirían decisiones propias; no adoptadas ni implícitas en ADR-011. |

## 7. Consecuencias y riesgos

Permite total o adelanto sin impedir confirmar por saldo posterior, manteniendo responsabilidades y modalidades. Aumenta las exigencias de evidencia persistida, verificación, seguridad y recuperación. El propietario debe poder vincularse como receptor antes del cobro; el proceso y cobertura de onboarding siguen por formalizar.

Riesgos principales: candidato no habilitado en Perú; medios insuficientes; receptor incorrecto o token revocado; doble cobro o aplicación duplicada; sobreventa concurrente; aprobado sin confirmación; resultado perdido tras caída; eventos fuera de orden; diferencia entre importes bruto/neto; devolución bloqueada por falta de fondos; confusión entre recepción declarada y verificación electrónica. La asociación inicial exacta Reserva/Solicitud/operación y los estados persistidos requieren diseño, sin aprobar nuevas máquinas de estados aquí.

La integración no debe pasar a producción hasta resolver el riesgo de recuperación/conciliación y devolución aplicable, además de concurrencia e idempotencia. No se promete éxito del proveedor ni devolución garantizada por la mera presencia de un webhook.

## 8. Criterios para aprobar integración de producción

1. Resolver la matriz de capacidades con evidencias fechadas y configuración/producto/cuentas de Perú identificados, y confirmar receptor y flujo de fondos sin redistribución manual.
2. Revisar y aprobar contratos de inicio, verificación, notificación, consulta, aplicación y devolución, responsabilidades de vinculación/revocación, seguridad y políticas de conciliación. Formalizar HU/RF del onboarding si su alcance requiere más detalle.
3. Diseñar la garantía de compatibilidad concurrente y aplicación única con persistencia relacional; documentar puntos de fallo y recuperación. No basta consulta seguida de escritura ni validación de interfaz.
4. Ejecutar con evidencia los casos propuestos de EQ-03/EQ-04/EQ-08: duplicados entre canales, eventos diferentes del mismo pago, reintentos, desorden, caídas antes/después de persistir, resultados inciertos, receptor/importe/moneda erróneos, pago aprobado sin condiciones y saldo declarado completo. Ningún par incompatible ni doble aplicación.
5. Verificar con entornos autorizados la recepción/liquidación por propietario y la devolución cuando corresponda, incluidos límites de saldo, comisiones y excepciones. Acordar responsables, tratamiento de pendientes y criterios operativos medibles; sandbox y documentación no sustituyen evidencia que solo pueda obtenerse en operación controlada.
6. Revisar expresamente precisión monetaria, total/adelanto, pendientes, importes bruto/neto y representación de cero; conservar una recepción activa e historial y evitar un cobro posterior de saldo ya recibido.
7. Diseño, arquitectura, AGENTS.md y las seis fuentes C1–C4 están sincronizados documentalmente mediante tareas 2–4; completar validación visual y actualización gráfica, y registrar una resolución explícita de aprobación de producción con evidencia y límites. El presente archivo no constituye esa resolución.

## 9. Trazabilidad y siguientes fases

La matriz detallada de [catálogo ADR](../07-decisiones-arquitectonicas.md#7-trazabilidad-y-estado-de-adr-012) registra HU → RF → AC/RC → DA → ADR → EQ. DA02/DA06/DA08 sustentan la propuesta; DA05/ADR-007 apoya autorización sin inventar nuevo origen RF18 → DA05. AC02/AC07 y RF02/RF09/RF10 conservan sus huecos; HU03/RF04 y HU04/RF06 son contextuales. No se aprueba RF13 ni se da por formalizada DF-02.

El informe (antecedente auxiliar local, fuera del repositorio) enumera contradicciones, archivos inspeccionados, sustituciones y pendientes de Diseño y C1–C4. No se modifica código ni se generan diagramas. La creación de esta ADR no acredita arquitectura financiera aprobada, capacidades validadas o implementación.
