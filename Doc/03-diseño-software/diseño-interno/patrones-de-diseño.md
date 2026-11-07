# UrbanPulse — Patrones de diseño

**Reconciliación Tarea 2 — 07/11/2026; pendiente de auditoría.** El alcance funcional de pagos reales sustituye la exclusividad simulada histórica conforme a [RC/DF/DP revisados](../../01-analisis-de-sistema/05-restricciones.md) y [ADR-012](../../01-analisis-de-sistema/adr/ADR-012-modelo-pagos-mvp.md). Las decisiones arquitectónicas financieras de ADR-012 siguen propuestas; Mercado Pago Marketplace Split 1:1 es candidato, sin capacidades verificadas ni integración de producción aprobada. Esta revisión no acredita implementación o pruebas. AGENTS.md y la arquitectura general se sincronizan en Tarea 4 con el alcance funcional vigente; la arquitectura financiera de ADR-012 sigue propuesta y los cierres históricos no la aprueban.

**Antecedente conservado:** Repository, Adapter e inyección de dependencias tienen aprobación conceptual histórica en Reservas y extensión ADR-010/ADR-011. Esto no aprueba contratos ni clases de la nueva revisión financiera; el desarrollo siguiente es propuesta explicativa para auditoría. Se sustituyen ejemplos acoplados al simulador, sin añadir patrones.

## Objetivo

Organizar persistencia, integración del proveedor y composición con las cuatro capas de ADR-002 y las API públicas internas de los ocho módulos (ADR-001). La base conceptual se contrasta con [diseño interno](diseño-interno-de-modulos.md), [RN/PC](../01-reglas-de-negocio.md), [estados](../02-estados-y-transiciones.md), [flujos](../03-flujos-de-reserva.md) y [catálogo ADR](../../01-analisis-de-sistema/07-decisiones-arquitectonicas.md). Clean Architecture es arquitectura; Repository es patrón de persistencia, Adapter estructural GoF e inyección una técnica de ensamblado.

## Contexto

Cancha/karaoke confirman directamente con pago total o adelanto configurado verificado y aplicado y disponibilidad válida. Salón/recreo añaden solicitud, cotización y aceptación interna. RN-13 obliga a impedir incompatibles concurrentes; aprobación aislada nunca confirma. Módulo Pagos sustituye nombre histórico Pagos Simulados, sin noveno módulo. Pago, aplicación, confirmación, recepción declarada y liquidación del proveedor son hechos diferentes.

El propietario receptor debe identificarse y tener vinculación válida; UrbanPulse no recauda para redistribuir manualmente. Mercado Pago Marketplace Split 1:1 es candidato, sin aprobación de capacidades/producción. No se seleccionan SDK, lenguaje, framework, ORM, motor, endpoints o contratos.

## Patrones aplicados

### Repository

Aplicación solicita persistencia por abstracciones hacia el núcleo; Infraestructura implementa almacenamiento relacional (ADR-008). Reservas conserva datos propios y evidencia mínima de importe aplicado; Pagos conserva operación, resultados verificados, correlación e incidencias. Acceso por repositorios propios y API públicas, sin tablas privadas ajenas. PC-02 define asociaciones y propietario persistido del registro de saldo.

El repositorio y la coordinación deben preservar confirmaciones compatibles, aplicación única por pago y una recepción activa de saldo con historial. **Declarar Repository no implementa esas garantías.** PC-05/PC-08 deben definir unidad transaccional o recuperación, sin asumir transacción distribuida con el proveedor. Consulta seguida de escritura, callback o sustituto en memoria no demuestran concurrencia. No se adoptan bloqueos, retenciones ni restricciones físicas concretas.

Saldo posterior completo positivo y correcciones se registran mediante un caso separado, conservando autor y fechas, no como nueva confirmación del proveedor. Pendiente = total − pago aplicado; recepción separada evita doble descuento y cobro posterior de lo recibido. Cero no crea recepción.

### Adapter

Dos fronteras distintas: la adaptación interna entre Reservas, Disponibilidad y Pagos usa API públicas del monolito; la integración externa financiera traduce el contrato del proveedor a abstracciones internas. Ambas respetan ADR-002/ADR-006; ninguna impone HTTP interno. Dominio no importa SDK, credenciales o enums del proveedor.

El adaptador financiero permite solicitar inicio/consulta y devolución cuando corresponda, con contrato por definir. Presentación recibe webhook; adaptación técnica valida autenticidad según proveedor y Aplicación coordina contraste servidor a servidor de estado, importe, moneda, receptor y correlación. Webhook no equivale a aplicación ni confirmación, y el navegador no es autoridad financiera.

El contrato debe distinguir pendiente, aprobación/rechazo verificados e incertidumbre. Timeout no se transforma en rechazo/aprobación; orden de llegada no degrada hechos verificados. Eventos diferentes del mismo pago no generan dos aplicaciones; deduplicar ID de evento es insuficiente. Inicio y devolución necesitan identidad de intención/reintento para evitar duplicados; capacidades de idempotencia del candidato por comprobar. Adapter no garantiza estas propiedades por su mera existencia.

El adaptador interno consultado por Reservas recupera evidencia existente de Pagos; no vuelve a cobrar por consultar o confirmar. Sus datos deben corresponder a operación/cliente/receptor/recurso/importes correctos. La API de confirmación no absorbe recepción de saldo o conciliación.

### Inyección de Dependencias

Los casos de uso reciben abstracciones de persistencia, disponibilidad y evidencia financiera; la raíz de composición externa al núcleo suministra implementaciones. No se aprueba firma de constructor, composición concreta ni biblioteca. Un doble de prueba puede representar rechazo o incertidumbre sin integración real; no acredita proveedor operativo ni garantía concurrente.

DIP orienta dependencias hacia abstracciones; inyección suministra colaboradores. Se puede sustituir un detalle que preserve el contrato, sin convertir esa posibilidad en selección libre de proveedor sin validación. La raíz no localiza servicios para el Dominio ni contiene reglas financieras.

### Colaboraciones y comparación

| Solución conceptual conservada | Colaboración propuesta | Qué no resuelve por sí sola |
|---|---|---|
| Repository | Caso de uso → contrato propio; implementación relacional → contrato | Atomicidad, aplicación única, historial o concurrencia sin mecanismo PC-02/PC-05/PC-08. |
| Adapter interno | Reservas consulta API públicas de Pagos/Disponibilidad y evidencia de condiciones para eventos | No acredita autenticidad financiera ni resuelve disponibilidad futura. |
| Adapter externo | Pagos solicita operaciones al proveedor por puerto; Infraestructura traduce resultados; Aplicación verifica y coordina | No valida elegibilidad en Perú, medios, liquidación o devolución del candidato. |
| Inyección | Ensamblado suministra adaptadores a abstracciones del núcleo | No prueba seguridad, persistencia o recuperación. |

## Cómo funciona cada patrón

1. **Repository:** ante una confirmación, solicitar persistencia compatible y asociación auditable de pago aplicado; solo comunicar éxito con efecto definitivo según protocolo por aprobar. Conservar aprobación e incidencia si no se confirma. PC-05/PC-08 sigue abierto.
2. **Adapter:** ante webhook o consulta, validar señal y verificar fuente autoritativa; traducir resultado conservando incertidumbre y correlación. Aplicación decide coordinación, Dominio sus invariantes; el transporte no confirma Reserva.
3. **Inyección:** ensamblar esos contratos desde fuera del núcleo; las pruebas futuras pueden sustituir colaboradores sin alterar la semántica de resultado, titularidad o aplicación. No se construye un módulo ejecutable en esta revisión.

Los Mermaid y fragmentos anteriores dependían de nombres y contratos exclusivos del simulador. Se sustituyen por estas colaboraciones conceptuales para no aparentar un diseño de integración validado. El antecedente permanece en Git y los PNG históricos; la fuente Mermaid de C4-01 ya fue revisada para pagos reales. Las propuestas actuales no fijan nuevas firmas o clases.

## Beneficio

| Beneficio esperado | Aplicación concreta y respaldo | Límite |
|---|---|---|
| Mantenibilidad/interoperabilidad | Aislar proveedor, mapeo y composición; AC05/AC08 → DA06 → ADR-002/ADR-006; propuesta ADR-012 | Cambiar proveedor exige verificar semántica/capacidades, no solo reemplazar SDK. |
| Consistencia | Coordinación de aplicación única y confirmación compatible; RF04/RF06/RF12 → AC03/DA02/ADR-004 | PC-05/PC-08 pendientes; no hay garantía implementada. |
| Autorización/trazabilidad | HU10/HU14 → RF14; HU14 → RF20; AC04/DA05/ADR-007; RC04/DA08/ADR-008 | Autor, historial y receptor requieren contratos y controles PC-11. |
| Extensibilidad | Modalidad directa frente a evento; AC06/DA03/ADR-001/ADR-003 | No exige Strategy/Factory para integrar proveedor. |
| Testabilidad | Sustitutos permiten evaluar rechazo/incertidumbre/desorden; apoyo a AC05 | No añade AC ni demuestra cobros, recuperación o concurrencia. |

RF18 es origen explícito de DA06; RF11/RF19 son contexto de integración y origen de DA08. RF14/RF20 figuran en DA05/DA08. HU03/RF04 y HU04/RF06 son contextuales; RF02/RF09/RF10 sin driver de origen; AC02/AC07 sin driver/respuesta explícitos. DF-02 y RF13 siguen pendientes; EQ-03/EQ-04/EQ-08 proponen evaluación sin pruebas ejecutadas. RC03/DA07/ADR-005 mantiene REST, con AC05/AC08 complementarios; AC03/AC05 son complementarios en DA08. No se atribuye DA01 → ADR-002.

### Redis, RabbitMQ y composición técnica

Repository de negocio conserva fuente relacional definitiva; la caché no lo reemplaza. Ante miss se reconstruye la ficha por repositorios y fronteras autorizadas; ante fallo Redis se usa persistencia sin inventar ausencia. Fallo al cargar copia no vuelve inexistente un resultado autorizado. La base también puede fallar; no se promete continuidad absoluta.

Adaptador Redis traduce acceso/carga/invalidación sin decidir visibilidad. Adaptador RabbitMQ publica únicamente intenciones de invalidación de cambios públicos; Establecimientos coordina y Recursos/Servicios solo son productores si afectan contribuciones de ficha. Recepción técnica y coordinación se separan, con ubicación exacta pendiente. Se conservan seis responsabilidades conceptuales, sin seis clases obligatorias, quinto nivel o módulo extra.

Consumidor dentro del backend; worker independiente: **Preparado arquitectónicamente, no obligatorio inicialmente**. Preparar frontera de consumo, adaptación de transporte y coordinación de invalidación extraíbles a otro proceso sin modificar Dominio. Implementación posterior; no es microservicio ni proceso obligatorio inicial. Inyección no amplía RabbitMQ a pagos, webhooks o conciliación; tal ampliación requiere nueva decisión.

### Seguridad y consistencia de caché e invalidación

Estos límites proceden de los cierres de ADR-010/ADR-011 y del Diseño Interno; explicarlos mediante patrones no acredita funcionamiento ni garantías de seguridad.

- **Visibilidad:** la retirada segura de publicación sigue pendiente de política y mecanismo que impidan divulgar contenido ya no autorizado. TTL e invalidación asíncrona no garantizan por sí solos confidencialidad; el adaptador no decide autorización. Se excluyen datos protegidos, reservas, aceptación contractual, adelantos, saldo y permisos como autoridad de caché.
- **Repoblación:** una lectura antigua puede cargar su copia después de invalidar. La repoblación concurrente, el desorden y las reconstrucciones simultáneas requieren diseño; versiones o generaciones siguen como alternativas. No se afirma consistencia fuerte ni se fijan claves, TTL o algoritmos.
- **Entrega y efecto:** duplicados e idempotencia concreta siguen pendientes de diseño; el procesamiento idempotente es requisito conceptual. Repetir una eliminación no resuelve por sí solo carreras de repoblación. El **ACK debe ocurrir después del efecto requerido**; si falla la invalidación en Redis, el efecto no se considera completado. **Publisher confirms no equivalen a consumo** ni a invalidación. Entrega al menos una vez es objetivo condicionado a conservación, publicación y recuperación; no se garantiza exactamente una vez.
- **Recuperación:** RabbitMQ no hace atómicos el commit relacional y la publicación. Reintentos limitados, agotamiento, eventual DLQ, mensajes inválidos, durabilidad, vuelta a servicio y supervisión permanecen pendientes. TTL no conserva intenciones ni sustituye entrega fiable o recuperación; no se promete recuperar una intención nunca conservada.
- **Aislamiento funcional:** Redis no confirma reservas, acredita disponibilidad ni retiene recursos. RabbitMQ no transporta pagos ni confirmaciones, ni altera Reserva, resultado del adelanto o registro del saldo. **RN-13 aprobada y PC-05 abierto** permanecen independientes de los patrones y del broker; PC-08 de pagos tampoco queda resuelto por reintentar invalidaciones. El alcance financiero real proviene de RC07/DF/DP revisados; sus mecanismos no se resuelven con invalidaciones.

ADR-010 aporta apoyo complementario a AC01/DA04 para fichas públicas y complementa ADR-009; no crea origen RF02 → DA04 ni cachea disponibilidad. ADR-011 se apoya en ADR-002/ADR-006 para desacoplamiento, sin atribuir a DA06 una exigencia histórica de RabbitMQ. AC02/AC07 y los vacíos de trazabilidad conservan sus estados; EQ sigue sin pruebas ni métricas acreditadas.

## Patrones previstos para siguientes iteraciones

| Alternativa conservada | Necesidad que permitiría evaluarla | Estado y dependencia |
|---|---|---|
| Strategy | Variación compleja y repetida de modalidades | Candidato; primero PC-01–PC-03. No adoptado por integrar pagos. |
| Factory | Construcción con variantes cuya complejidad lo justifique | Candidato; ninguna operación de creación implica Factory Method GoF aprobado. PC-02/PC-06/PC-08. |
| State | Comportamiento polimórfico si las máquinas lo justifican | Candidato; tablas conceptuales no exigen clases o enums. RF13 pendiente. |
| Specification | Predicados reutilizables de condiciones/compatibilidad | Candidato; no resuelve atomicidad o concurrencia PC-05. |
| Transactional Outbox | Conservar intención de invalidación con cambio relacional | Evaluado, no adoptado. Si se selecciona, ambos en misma transacción, no registrar intención después del commit. Despacho/propiedad/recuperación pendientes; aún puede haber duplicados y no hay atomicidad con Redis. |

Publicación directa después del commit conserva ventana de pérdida o incertidumbre; confirms no la cierran. La elección sigue abierta en ADR-011. No se adoptan Observer, inbox, scheduler, cola financiera o topología publish-subscribe por usar RabbitMQ. No se incorporan patrones por conveniencia estética.

### Decisiones y pendientes conservados

Aplicar [PC-01–PC-12](../01-reglas-de-negocio.md#restricciones-del-mvp-y-pendientes-contractuales): evidencia/aceptación, asociaciones, iniciador, temporalidad, concurrencia, importes/moneda, aprobado sin confirmar, proveedor/idempotencia/desorden/recuperación, cambios, cancelación frente a devolución, permisos/vinculación y cobertura/evaluación. Devolución financiera cuando corresponda no aprueba RF13. No se fijan comisiones, porcentajes o plazos universales ni fraccionamiento posterior.

La revisión sustituye exclusividad simulada, antiguos nombres de puertos/API y ejemplos de composición sin aprobar reemplazos ejecutables. Mantiene los patrones conceptuales y su alcance Redis/RabbitMQ, con mecanismos pendientes. Las seis fuentes C1–C4 y los textos de arquitectura general ya reflejan el objetivo financiero; Tarea 4 sincroniza AGENTS y cuatro capas. Los desfases gráficos históricos siguen pendientes; ORM no seleccionado. El cierre histórico no aprueba esta revisión ni producción.
