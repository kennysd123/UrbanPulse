# UrbanPulse — Principios de diseño SOLID

**Reconciliación Tarea 2 — 07/11/2026; pendiente de auditoría.** El alcance funcional de pagos reales sustituye la exclusividad simulada histórica conforme a [RC/DF/DP revisados](../../01-analisis-de-sistema/05-restricciones.md) y [ADR-012](../../01-analisis-de-sistema/adr/ADR-012-modelo-pagos-mvp.md). Las decisiones arquitectónicas financieras de ADR-012 siguen propuestas; Mercado Pago Marketplace Split 1:1 es candidato, sin capacidades verificadas ni integración de producción aprobada. Esta revisión no acredita implementación o pruebas. AGENTS.md y la arquitectura general se sincronizan en Tarea 4 con el alcance funcional vigente; la arquitectura financiera de ADR-012 sigue propuesta y los cierres históricos no la aprueban.

**Antecedente conservado:** análisis SOLID de Reservas y responsabilidades Redis/RabbitMQ aprobado conceptualmente y cerrado documentalmente el 16/10/2026. Esa aprobación no se extiende a contratos, clases o mecanismos financieros de esta revisión, pendiente de auditoría. Se sustituyen ejemplos del simulador por criterios del pago real sin introducir tecnologías.

## Objetivo

Revisar responsabilidades y contratos con SRP, OCP, LSP, ISP y DIP sobre [diseño interno](diseño-interno-de-modulos.md), [patrones](patrones-de-diseño.md), [RN/PC](../01-reglas-de-negocio.md), [estados](../02-estados-y-transiciones.md) y [flujos](../03-flujos-de-reserva.md). SOLID ayuda a evaluar cohesión, acoplamiento, mantenibilidad y sustitución; no garantiza concurrencia, seguridad, idempotencia o recuperación sin diseño y pruebas.

## Contexto

Ocho módulos: Usuarios, Establecimientos, Recursos, Disponibilidad, Reservas, Solicitudes, Servicios y Pagos. Pagos evoluciona del nombre histórico Pagos Simulados, sin otro módulo. Monolito Modular y cuatro capas oficiales (ADR-001/ADR-002), REST web–backend y persistencia relacional por repositorios (RC03/RC04; ADR-005/ADR-008), sin motor/ORM/lenguaje seleccionado.

Cancha/karaoke mantienen reserva directa con pago total o adelanto configurado verificado y aplicado y disponibilidad válida; salón/recreo añaden solicitud, cotización y aceptación interna. Solicitud aceptada no confirma; WhatsApp no sustituye aceptación. Recreo reserva espacio definido sin presumir exclusividad de establecimiento/día. RN-13 impide confirmaciones incompatibles concurrentes, mecanismo PC-05 pendiente. Consulta no retiene.

Pagos reales para propietario receptor identificado/vinculado válido; UrbanPulse no recauda para redistribuir manualmente. Operación, verificación, aplicación, confirmación, recepción declarada y liquidación del proveedor se distinguen. Pendiente = total − pago aplicado; recepción posterior completa positiva se muestra aparte sin doble descuento o cobro de lo recibido. Cero no crea recepción. Mercado Pago Marketplace Split 1:1 es candidato no validado; ADR-012 propone respuesta financiera sin aprobar integración de producción.

## SOLID en el módulo Reservas y Pagos

### S — Principio de Responsabilidad Única (SRP)

| Responsabilidad conceptual propuesta | Razón principal de cambio | Límite |
|---|---|---|
| Reglas de Reserva | Cambian condiciones de modalidad aprobadas | No conoce SDK, webhook ni custodia de credenciales. |
| Coordinación de confirmación | Cambia colaboración con Disponibilidad/Pagos y aceptación en eventos | No absorbe inicio de cobro o recepción de saldo. |
| Operación y verificación de Pagos | Cambia evidencia y coordinación financiera | Separar resultado, aplicación e incidencia; no confirmar por aprobación aislada. |
| Adaptación del proveedor | Cambia protocolo, autenticidad o formato externo | No decide condiciones de Reserva ni transforma timeout en rechazo. |
| Recepción posterior/corrección | Cambia registro declarado e historial | No cambia Reserva, resultado electrónico o importe aplicado. |
| Conciliación/devolución | Cambia política y resolución autorizada de incidencias | Registrar evidencia y resultado financiero separado de cancelación RF13. |
| Composición | Cambia implementación suministrada | No contiene reglas ni es quinta capa. |

Un webhook entra por frontera técnica y promueve verificación backend; recibir, verificar, aplicar y confirmar tienen razones de cambio distintas. Separarlas no impone una clase por fila. Pagos conserva antecedentes y Reservas datos propios/evidencia mínima, sin copiar todo el contrato del proveedor. Creación en memoria no acredita aplicación persistida.

En fichas públicas, conservar separación de consulta, publicabilidad, reconstrucción, acceso Redis, publicación, recepción técnica y coordinación de invalidación. Son razones de cambio, no un nuevo conteo de componentes C3. Establecimientos coordina; Recursos/Servicios conservan autoridad y solo contribuyen si corresponde a la proyección aprobada. No acceder a tablas privadas ajenas ni crear ciclos funcionales.

### O — Principio Abierto/Cerrado (OCP)

Adaptadores permiten revisar un detalle del proveedor conservando reglas y contratos internos, si se demuestra equivalencia semántica. No hace intercambiables proveedores con capacidades distintas ni elimina aprobación de candidato. Cambiar SDK no debe obligar al Dominio a aprender OAuth, formatos de webhook o enums externos; vinculación, renovación/revocación y seguridad se diseñan por frontera adecuada.

Modalidad directa y evento mantienen condiciones distintas; extender eventos exige evidencia fiable de cotización/aceptación y resolver PC-01–PC-03. No basta booleano del navegador ni añadir modalidad a un contrato directo. Strategy/Factory siguen candidatos si una complejidad concreta lo justifica, sin jerarquías nuevas adoptadas.

La futura extracción del consumidor RabbitMQ debe conservar coordinación e invalidación detrás de fronteras sin modificar Dominio. Worker independiente: **Preparado arquitectónicamente, no obligatorio inicialmente**. Consumidor interno en MVP, implementación posterior; no añade microservicio, noveno módulo ni proceso separado obligatorio. Tampoco extiende broker a finanzas.

### L — Principio de Sustitución de Liskov (LSP)

Un sustituto conserva precondiciones, efectos y resultados del contrato; igual firma no basta. Los contratos concretos siguen pendientes.

| Colaboración | Obligación observable propuesta | Sustitución inválida |
|---|---|---|
| Proveedor / verificación | Preservar correlación, importe, moneda, receptor y significado verificado de estado | Aprobar por retorno del navegador o timeout; ocultar resultado incierto. |
| Aplicación de pago | Mismo pago produce como máximo una aplicación, aun con canales/eventos distintos | Contar dos eventos como dos importes o dos reservas. |
| Confirmación/persistencia | No devolver éxito sin registro definitivo consistente ni admitir incompatibles concurrentes | Leer disponibilidad y escribir sin garantía y declarar RN-13 cumplida. |
| Recepción/corrección de saldo | Confirmada propia, importe completo positivo, una activa e historial/autor/fecha | Crear parciales, doble recepción o reemplazar silenciosamente historial. |
| Conciliación/devolución | Mantener evidencia e incertidumbre hasta verificación del resultado | Borrar aprobación porque no hubo reserva o afirmar devolución por haberla solicitado. |

Un doble de pruebas no prueba proveedor operativo o compatibilidad concurrente; Adapter/Repository no proporcionan esos mecanismos. Eventos antiguos se contrastan sin degradar hechos verificados por orden de llegada. Dos cobros diferentes no desaparecen por deduplicar la notificación de uno.

**Equivalencia semántica de caché y mensajería.** Son criterios de evaluación de futuras implementaciones, no interfaces nuevas ni garantías ya demostradas:

| Distinción | Obligación semántica y límite |
|---|---|
| Cache miss / fallo técnico | Falta de copia no prueba ausencia definitiva del establecimiento. Un fallo de Redis no se convierte en dato inexistente: se recurre a persistencia por fronteras autorizadas; si la base falla tampoco se inventa ausencia (ADR-008/ADR-010). |
| Copia existente / copia actualmente publicable | La presencia en Redis no acredita vigencia o visibilidad autorizada. Un sustituto debe respetar la política pública que se defina; TTL no prueba confidencialidad (ADR-007/ADR-010). |
| Publicación solicitada / publicación confirmada | Pedir publicar expresa una intención, sin acreditar aceptación del broker ni atomicidad con el commit. Error o resultado incierto deben conservar su significado según el contrato futuro (ADR-011). |
| Publisher confirm / mensaje procesado | La confirmación del broker reconoce otra etapa; no demuestra consumo ni invalidación de Redis (ADR-011). |
| Mensaje entregado / invalidación completada | Recibir o validar no completa el efecto. Si falla Redis, la invalidación requerida no se considera completada (ADR-010/ADR-011). |
| ACK / efecto requerido | El ACK debe ocurrir después de completar la invalidación requerida. Un sustituto no puede anticiparlo como éxito; un fallo tras el efecto y antes del ACK puede producir duplicados según las garantías concretas de entrega (ADR-011). |

Idempotencia es requisito conceptual con mecanismo pendiente; repetir una eliminación no resuelve por sí solo repoblaciones concurrentes. Entrega al menos una vez es objetivo condicionado a conservación, publicación y recuperación, sin garantía acreditada de exactamente una vez. LSP exige no debilitar las obligaciones acordadas, pero no proporciona por sí mismo fiabilidad ni recuperación de intenciones nunca conservadas.

### I — Principio de Segregación de Interfaces (ISP)

| Cliente conceptual | Necesidad acotada | Operaciones que no debe absorber |
|---|---|---|
| Confirmación en Reservas | Evidencia de pago aplicado y correspondencia, disponibilidad y aceptación en eventos | Iniciar cobros, webhooks, reembolsos o corrección del saldo. |
| Inicio en Pagos | Identidad, condiciones fijadas y receptor válido; solicitar operación | Modificar Reserva o decidir disponibilidad futura. |
| Verificación | Autenticidad/correlación y consulta autoritativa | Confirmar por recepción de notificación o administrar oferta. |
| Recepción de saldo | Registro/corrección completa autorizada e historial | Aprobar operación electrónica o cancelar reserva. |
| Conciliación/devolución | Evidencia, permisos, operaciones y resultados necesarios | API general de administración o potestad sobre usuarios. |
| Caché/publicación/consumo/invalidación | Contratos técnicos acotados de ficha pública | Pagos, disponibilidad, aceptación contractual y datos protegidos. |

Es una separación propuesta de clientes y responsabilidades, no una interfaz por método ni seis clases obligatorias. El número, propiedad y ubicación de contratos se decide con PC-02/PC-08/PC-11; ninguna firma antigua del simulador se vuelve contrato del proveedor real.

### D — Principio de Inversión de Dependencias (DIP)

Presentación depende de Aplicación; Aplicación de reglas y abstracciones hacia el núcleo; Infraestructura implementa adaptadores/repositorios de esas abstracciones. Dominio no depende de Infraestructura, SDK, Redis/RabbitMQ, credenciales ni estados específicos del proveedor. La raíz suministra implementaciones desde fuera del núcleo, sin biblioteca DI seleccionada. Inyección es técnica de suministro, DIP es orientación del código.

Reservas, Disponibilidad y Pagos colaboran por API públicas internas; compartir backend/base no autoriza acceso privado ajeno. No se impone HTTP interno. Ejecución por puerto hacia un adaptador no significa dependencia de Dominio hacia Infraestructura. Las flechas y firmas ilustrativas anteriores del simulador se sustituyen por estas responsabilidades; sus antecedentes permanecen en Git y PNG históricos; la fuente C4-01 actual ya distingue pagos reales.

La recepción RabbitMQ corresponde a adaptación técnica y la coordinación respeta Aplicación/frontera autorizada; el núcleo no conoce clientes del broker. Webhook financiero es otra entrada y requiere contrato propio; no se enruta automáticamente por RabbitMQ. Una ampliación financiera exige nueva decisión arquitectónica.

### Tabla resumen SOLID

| Principio | Aplicación financiera | Verificación futura / límite |
|---|---|---|
| SRP | Separar operación, verificación, aplicación, confirmación, recepción y conciliación | Revisar razones de cambio y propiedad, sin una clase obligatoria por concepto. |
| OCP | Adaptar proveedor sin acoplar núcleo; preservar modalidades | Validar capacidades y contratos antes de sustituir. |
| LSP | Conservar incertidumbre, aplicación única y confirmación compatible | Ensayos de duplicados, desorden, fallos y concurrencia; PC-05/PC-08. |
| ISP | API acotadas por caso/cliente | No concentrar finanzas, reservas y administración en interfaz general. |
| DIP | Contratos hacia núcleo, detalles suministrados externamente | Revisar dependencias; no SDK/credenciales en Dominio. |

## Qué pasaría sin SOLID en UrbanPulse

| Antipatrón ilustrativo | Consecuencia | Criterio propuesto |
|---|---|---|
| Controlador inicia, verifica, aplica y escribe Reserva directamente | Mezcla entrada, protocolo, reglas y persistencia; oculta carreras | Separar coordinación y adaptación, mantener RN-13. |
| Adaptador aprueba por timeout o retorno del navegador | Confirma sin evidencia autoritativa | Conservar incertidumbre y verificar backend. |
| Webhook decide Reserva o aplicación por cada evento | Duplicación o confirmación sin condiciones | Aplicación única por pago y coordinación recuperable, mecanismo pendiente. |
| Caso de confirmación incluye saldo y devolución | Mezcla declaración manual, proveedor y ciclo de Reserva | Casos separados, sin habilitar RF13. |
| Cambiar proveedor modifica el Dominio con tipos de SDK | Reglas dependen de tecnología | Puerto interno, adaptador externo y traducción. |

### Riesgos técnicos como antipatrones ilustrativos

Estos escenarios amplían el análisis conceptual; no se afirma que existan en código ejecutado. Cada alternativa expresa un criterio de diseño, sin aprobar su mecanismo:

| Riesgo o antipatrón | Principios y decisiones | Consecuencia y criterio de revisión |
|---|---|---|
| Caché como fuente definitiva | SRP, LSP; ADR-008/ADR-010. | La pérdida de una copia aparentaría pérdida de negocio. Mantener base relacional definitiva y copias reconstruibles por fronteras autorizadas. |
| Dominio accede directamente a clientes Redis/RabbitMQ | DIP, OCP; ADR-002/ADR-006/ADR-010/ADR-011. | Reglas dependen de detalles técnicos. Consumir abstracciones internas e inyectar implementaciones desde la composición. |
| Redis decide por sí solo visibilidad pública | SRP, LSP; ADR-007/ADR-010. | Una copia antigua podría divulgar contenido retirado. Separar admisibilidad y acceso técnico; protección concreta pendiente, sin atribuir garantía a TTL. |
| Invalidaciones ejecutan operaciones críticas de negocio | SRP, ISP, LSP; ADR-003/ADR-004/ADR-010/ADR-011. | Un reenvío técnico podría alterar aceptación, pago o saldo. Mantenerlos fuera de los mensajes de caché y preservar evidencia definitiva. |
| Consumidor convertido en módulo funcional | SRP, ISP; ADR-001/ADR-011. | La adaptación técnica absorbería responsabilidades de negocio. Conservar ocho módulos y consumidor dentro del backend, sin módulo ni despliegue adicional. |
| RabbitMQ confirma reservas | SRP, LSP; ADR-004/ADR-011. | Entrega o consumo se confundirían con condiciones de confirmación. Reservas coordina sus condiciones independientemente del broker; RN-13 obligatoria y PC-05 abierto. |
| Acceso a tablas privadas de otros módulos | SRP, DIP; ADR-001/ADR-002/ADR-008. | Se eluden contratos y responsabilidades ajenas. Reconstruir fichas por repositorios propios y fronteras públicas internas. |
| Error técnico interpretado como ausencia | LSP; ADR-008/ADR-010/ADR-011. | Redis caído aparentaría establecimiento inexistente o un envío incierto aparentaría resultado definitivo. Preservar las distinciones semánticas y diseñar errores/recuperación. |
| Publicación considerada atómica con el commit | LSP, SRP; ADR-008/ADR-011. | Tras el commit puede perderse la intención antes de publicar. Publicación directa u Outbox siguen por decidir; RabbitMQ no aporta atomicidad relacional. |
| ACK anticipado | LSP, SRP; ADR-011. | Se reconoce trabajo antes de completar el efecto y podría perderse la invalidación. Exigir ACK posterior al efecto; tratamiento de fallos y duplicados pendiente. |
| Dependencias circulares Establecimientos–Recursos–Servicios | SRP, ISP, DIP; ADR-001/ADR-002/ADR-010/ADR-011. | Componer una ficha podría inducir llamadas recíprocas o acceso privado. Propiedad de proyección y contratos pendientes; Recursos/Servicios solo son productores candidatos si cambian campos incluidos, sin deducir ciclos. |

## Relación con Clean Architecture y los patrones

ADR-001 organiza módulos, ADR-002 capas/dependencias; SOLID orienta responsabilidades/contratos; Repository, Adapter e inyección organizan colaboraciones. Sus aprobaciones conceptuales históricas no aprueban el diseño financiero actual ni mecanismos concretos. No son todos patrones GoF. [Patrones](patrones-de-diseño.md) conserva Strategy/Factory/State/Specification como candidatos; Outbox evaluado, no adoptado para invalidación ni por analogía para pagos.

### Relación documentada con calidad y decisiones

| Cadena respaldada | Contribución conceptual y límite |
|---|---|
| HU09 → RF11/RF18/RF19; AC08/RC07/RC10 → DA06 → ADR-006 y propuesta ADR-012 | Adapter/DIP/LSP orientan verificación e integración. RF18 es origen DA06; RF11/RF19 contexto allí y origen DA08 para persistencia. |
| RF04/RF06/RF12 → AC03/DA02/ADR-004 | SRP/LSP permiten revisar confirmación compatible; no resuelven PC-05. |
| HU10/HU14 → RF14; HU14 → RF20; AC04/DA05/ADR-007; RC04/DA08/ADR-008 | Autorización, resumen y registro con historial; SOLID no implementa seguridad. |
| AC05 → DA01/ADR-001 y DA06/ADR-002/ADR-006 | Cohesión y cambios localizados; no atribuir DA01 → ADR-002. |
| AC06 → DA03/ADR-001/ADR-002/ADR-003 | Extensión por modalidad sin patrones adicionales obligatorios. |
| RC03 → DA07/ADR-005; RC04 → DA08/ADR-008 | REST y persistencia; AC05/AC08 complementarios en DA07, AC03/AC05 complementarios en DA08. |
| AC01 → DA04/ADR-009; ADR-010 complementaria | Fichas públicas reconstruibles, no disponibilidad ni nueva relación RF02 → DA04. |

HU03/RF04 y HU04/RF06 siguen contextuales; RF02/RF09/RF10 sin origen explícito en drivers; AC02/AC07 sin driver/respuesta explícitos. DF-02 mantiene formalización detallada pendiente y RF13 cancelación pendiente. EQ-03/EQ-04/EQ-08 siguen procedimientos/métricas por revisar, sin ensayos. Testabilidad apoya AC05 sin inventar nuevos AC/DA.

### Pendientes conservados y alcance de las propuestas

[PC-01–PC-12](../01-reglas-de-negocio.md#restricciones-del-mvp-y-pendientes-contractuales) conserva identidades: cotización/aceptación, asociaciones, iniciador, periodos, garantía concurrente, precisión/moneda, aprobado sin confirmar, proveedor/reintentos/idempotencia/desorden/recuperación, cambios, cancelación y devolución diferenciadas, permisos/vinculación y cobertura/responsabilidades/evaluación. Fórmula revisada y recepción completa positiva no se reabren; mecanismo de corrección y cero pendientes. No se adoptan retenciones/expiraciones, contratos REST o tablas. No se presumen comisiones, porcentajes, depósitos o capacidades del candidato.

ADR-010/ADR-011 conservan fichas públicas y consumidor interno; idempotencia, publicación/recuperación, confirms/ACK, reintentos limitados, DLQ, configuración y seguridad pendientes. D1–D6 exige impedir selección/emisión vigente de reconstrucción invalidada, sin prohibir absolutamente toda escritura física tardía. Sincronización D3/D4, revisión/repoblación, visibilidad, TTL/claves y versiones siguen por diseñar. Outbox requeriría misma transacción de cambio/intención si se adoptara; no elimina duplicados ni hace atómica invalidación Redis. TTL no sustituye evidencia, conservación de intención o confidencialidad.

Tarea 4 sincroniza README, arquitectura inicial y AGENTS.md con cuatro capas y objetivo financiero; las seis fuentes C1–C4 ya se revisaron. Los PNG e informes históricos conservan el alcance anterior, sin autoridad sobre el modelo vigente. No se afirma que los cierres anteriores aprueben esta reconciliación o producción. No hay implementación ni pruebas ejecutadas.
