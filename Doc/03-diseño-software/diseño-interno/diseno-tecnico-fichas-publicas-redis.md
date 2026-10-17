# UrbanPulse — Diseño técnico conceptual de fichas públicas con Redis

**Estado: enfoque D1–D6 aprobado conceptualmente y registro cerrado documentalmente — Establecimientos y Redis. Contratos, mecanismos operativos e implementación pendientes.**

**Fecha de aprobación conceptual:** 16/10/2026.

**Antecedente histórico:** el registro inicial se entregó con el enfoque D1–D6 aprobado conceptualmente y su redacción pendiente de auditoría documental. La auditoría conceptual favorable, sin contradicciones arquitectónicas bloqueantes, comunicada por el responsable en la solicitud de cierre permite cerrar ahora el registro. Este cierre aprueba la redacción y trazabilidad de D1–D6; no aprueba contratos concretos, algoritmos, configuración, implementación ni garantías operativas verificadas.

## 1. Objetivo, alcance y estado de aprobación

Registrar el enfoque conceptual D1–D6 aprobado expresamente por el responsable para la consulta y carga segura de fichas públicas de establecimientos con Redis. Esta especificación técnica complementa ADR-010 y ADR-011; no constituye una ADR-012 ni modifica las decisiones existentes. Prepara el alcance conceptual del segundo C4, sin crearlo ni reabrir C1, C2, C3 o la primera vista C4 de Reservas.

La autorización procede de los acuerdos detallados en la solicitud de registro. No se dispone en el contexto aportado de un informe previo de propuesta D1–D6; no se atribuyen a ese antecedente recomendaciones o aprobaciones adicionales. Las designaciones D1–D6 de este documento identifican exclusivamente los seis acuerdos técnicos de la solicitud; no reinterpretan las referencias históricas «D2» del catálogo RN.

| Nivel | Alcance de este registro |
|---|---|
| Aprobado conceptualmente | Las ocho categorías públicas D1; coordinación de la ficha por Establecimientos D2; dirección de protección D3; dirección de revisiones y repoblación D4; responsabilidades semánticas y capas D5; distinciones y fallback D6; límite del segundo C4. |
| Consecuencia derivada | Las colaboraciones deben preservar autoridad modular, autorización de publicación y significado de resultados, sin convertir copias en datos definitivos. |
| Condicionado | Contribuciones públicas efectivamente necesarias y autorizadas, particularmente origen exacto de precios y horarios. |
| Pendiente | Mecanismos operativos, contratos, composición concreta, implementación y validación de las garantías exigidas. La redacción y trazabilidad de este registro quedan aprobadas por el cierre documental. |

El registro no crea código, configuraciones, clases, DTO, interfaces, firmas, estados o funcionalidades adicionales. No acredita seguridad operativa, consistencia fuerte, rendimiento ni pruebas ejecutadas.

## 2. Fuentes y trazabilidad arquitectónica

Las fuentes se contrastan según sus alcances expresos de aprobación. Los enlaces remiten a documentos existentes; este registro no les añade aprobaciones ni cambia sus cierres.

| Fuente | Respaldo y límite |
|---|---|
| [AGENTS.md](../../../AGENTS.md) | Jerarquía documental, cuatro capas, preservación de fuentes y trabajo preexistente. Su referencia a nueve ADR y ausencia de caché aprobada conserva un desfase frente a los cierres explícitos posteriores. |
| [HU](../../01-analisis-de-sistema/02-historias-del-usuarios.md) y [RF](../../01-analisis-de-sistema/03-requisitos-funcionales.md) | HU02 → RF02 respalda consulta informativa. HU02 enumera las ocho categorías de D1. HU06 → RF08 respalda gestión del establecimiento; HU07 → RF09, recursos y horarios; HU11 → RF15, administración de establecimientos. HU05/RF07 aporta contexto de servicios solicitados, sin convertir oferta pública en cotización. |
| [AC](../../01-analisis-de-sistema/04-atributos-de-calidad.md) y [drivers DA](../../01-analisis-de-sistema/06-driver-arquitectonicos.md) | AC01/DA04: contexto de rendimiento; AC04/DA05: límite de seguridad; AC03/DA02: consistencia de reservas; AC05/AC08 y DA06: contexto de mantenibilidad y desacoplamiento. No prueban cumplimiento. |
| [Restricciones RC y decisiones DF/DP](../../01-analisis-de-sistema/05-restricciones.md) | RC03/RC04: REST web–backend y persistencia relacional; DF-01–DF-06 y DP-01–DP-12 conservan modalidades, aceptación interna y simulación exclusivamente académica. |
| [Catálogo ADR-001–ADR-011](../../01-analisis-de-sistema/07-decisiones-arquitectonicas.md) | ADR-001/002: Monolito Modular y cuatro capas; ADR-005–008: REST, adaptadores, roles y repositorios. ADR-009 mantiene optimización de disponibilidad sin aprobación histórica de caché. |
| [ADR-010 — Redis](../../01-analisis-de-sistema/adr/ADR-010-cache-redis.md#registro-de-cierre-conceptual) | Cierre conceptual de Redis/cache-aside para fichas públicas reconstruibles, fuente relacional definitiva, fallback y retirada segura de publicación; mecanismos pendientes. D1–D6 desarrolla conceptualmente ese ámbito mediante esta autorización complementaria. |
| [ADR-011 — RabbitMQ](../../01-analisis-de-sistema/adr/ADR-011-mensajeria-rabbitmq.md#registro-de-cierre-conceptual) | Invalidación técnica asíncrona, consumidor dentro del backend, idempotencia y ACK posterior al efecto requeridos; publicación/recuperación pendientes y Outbox no adoptado. |
| [C2 — Contenedores](../../04-modelo-c4/02-contenedores-c2.md) | Revisión cerrada con cinco contenedores: Aplicación Web, Backend UrbanPulse, Base de datos relacional, Redis y RabbitMQ. No acredita despliegue. |
| [C3 — Componentes](../../04-modelo-c4/03-componentes-c3.md) | Ocho módulos y seis responsabilidades técnicas de caché/mensajería. Sus cajas no obligan a crear una interfaz o clase por responsabilidad. |
| [Primer C4 — Reservas](../../04-modelo-c4/04-codigo-c4.md) | Vista ilustrativa cerrada para confirmación directa de cancha/karaoke. Permanece fuera del cambio; sus firmas no se reutilizan como contratos de fichas. |
| [Diseño de módulos](diseño-interno-de-modulos.md), [Patrones](patrones-de-diseño.md) y [Principios SOLID](principios-de-diseño.md) | Tres documentos cerrados conceptualmente y reconciliados con ADR-010/011 y C3. Fundamentan separación de consulta, reconstrucción, admisibilidad y adaptación. Contratos concretos siguen pendientes. |
| [RN y PC](../01-reglas-de-negocio.md), [estados](../02-estados-y-transiciones.md) y [flujos](../03-flujos-de-reserva.md) | RN conserva sus niveles individuales; PC-01–PC-12 y RF13 mantienen sus límites. Las representaciones de estados y secuencias no aprueban mecanismos operativos. |
| [Escenarios EQ](../../01-analisis-de-sistema/08-escenarios-atributos-calidad.md) | Antecedente de evaluación con procedimientos y métricas pendientes de revisión; no acredita pruebas ejecutadas. |

| Relación | Tipo de trazabilidad | Aplicación conceptual |
|---|---|---|
| HU02 → RF02 → consulta en Establecimientos | Origen funcional explícito HU/RF; correspondencia con C3. | D1/D2 delimitan información y coordinación; RF02 carece de origen explícito en drivers. No se inventa RF02 → DA04. |
| HU06/RF08, HU07/RF09, HU11/RF15 → cambios de información | Contexto funcional y responsabilidades C3. | D2–D4 requieren identificar campos públicos afectados; RF08/RF15 figuran en DA05 por seguridad, RF09 sigue sin driver de origen explícito. |
| AC01 y RF01/RF03/RF05 → DA04 → ADR-009 | Cadena explícita previa; ADR-010 es complementaria. | D1–D6 apoya consultas de fichas; no amplía caché a búsquedas o disponibilidad ni afirma mejora medida. |
| AC04 → DA05 → ADR-007; ADR-002 también responde a DA05 | Respaldo explícito de seguridad y capas. | D3/D5/D6 preservan publicabilidad y límites; la realización operativa requiere diseño. |
| AC05/AC08 → DA06 → ADR-002/ADR-006 | Respaldo previo de desacoplamiento. | D5 orienta abstracciones/adaptadores; no atribuye a DA06 una exigencia histórica de RabbitMQ. |
| RC04 → DA08 → ADR-008; RC03 → DA07 → ADR-005 | Origen explícito por restricciones. | Fuente definitiva por repositorios y frontera REST web–backend. AC03/AC05 en DA08 y AC05/AC08 en DA07 son relaciones complementarias. |
| AC03 → DA02 → ADR-004; RN-13 obligatoria | Límite explícito de consistencia. | La ficha no confirma ni acredita disponibilidad. PC-05 permanece sin mecanismo aprobado. |

RF02/RF09/RF10 conservan ausencia de origen explícito en drivers. HU03/RF04 y HU04/RF06 mantienen asociaciones contextuales; AC02/AC07 carecen de driver y respuesta arquitectónica explícitos. D1–D6 no completa esos vacíos por analogía. DF-02 conserva su formalización detallada pendiente en HU/RF.

## 3. D1 — Proyección pública mínima

El acuerdo comprende **ocho categorías de información**, condicionado en todos los casos a su publicabilidad efectiva. No es un DTO definitivo ni convierte cada categoría en campo obligatorio. El origen modular indicado es una asignación propuesta para precisar con los contratos; la autoridad corresponde al módulo dueño del dato definitivo y sus reglas, sin transferirse a Redis ni al coordinador de la ficha.

| Categoría | Justificación funcional | Módulo de origen propuesto | Autoridad sobre el dato | Condición de publicación | Cambios que exigirían invalidación | Representación o contrato pendiente |
|---|---|---|---|---|---|---|
| Nombre público | Identificar el establecimiento en HU02/RF02. | Establecimientos. | Establecimientos, dentro de la gestión autorizada HU06/RF08 y HU11/RF15. | Nombre autorizado para exposición y establecimiento publicable. | Cambio del nombre expuesto o retirada de su publicación o de la ficha. | Forma, validación y correspondencia con el dato definitivo. |
| Categoría | Reconocer el tipo de oferta consultada en HU02. | Establecimientos. | Establecimientos sobre la clasificación propia. | Clasificación efectivamente pública del establecimiento publicable. | Cambio de categoría expuesta o de su publicabilidad. | Representación y reglas de clasificación; sin enumeración física nueva. |
| Descripción pública | Explicar la oferta según HU02/RF02. | Establecimientos. | Establecimientos sobre su descripción. | Solo contenido descriptivo autorizado, sin información privada incorporada. | Edición, retirada parcial o completa de la descripción pública. | Delimitación del contenido público y su representación. |
| Servicios y oferta pública | Consultar qué ofrece cada establecimiento, HU02/HU06; RN-07/RN-21. | Servicios; Recursos cuando contribuya información pública de unidades. Establecimientos coordina. | Servicios y Recursos sobre sus respectivos datos; Establecimientos sobre los suyos. | Cada contribución debe ser autorizada por su módulo y compatible con la publicabilidad de la ficha. | Alta, modificación o retirada de oferta incluida, de un servicio o de una contribución pública. | Contribuciones necesarias, selección y composición; sin inclusión automática en cotización. |
| Precios informativos | Orientar la consulta HU02, sin fijar importes de operación. | Fuente pública por precisar entre Establecimientos, Recursos y Servicios según dato. | El módulo dueño de la fuente pública que se determine; no se asigna por anticipado a Pagos. | Solo precios cuya fuente y exposición pública puedan acreditarse. | Cambio del precio público, de su contexto informativo o de la autorización para exponerlo. | Fuente exacta, significado, representación y contrato; sin moneda, precisión ni formato adoptados. |
| Horarios informativos | Informar horarios contemplados en HU02, con contexto de configuración HU07/RF09. | Establecimientos o contribución pública de Recursos; fuente exacta pendiente. | El módulo titular de la fuente pública que se precise. | Horarios autorizados como información, sin incorporar disponibilidad reservable. | Cambio del horario informativo o de su publicabilidad. | Fuente, significado y representación temporal; sin formatos ni cálculo de solapamientos. |
| Condiciones públicas de reserva | Consultar condiciones generales, HU02/RF02 y HU06/RF08. | Establecimientos; contribuciones públicas pertinentes por precisar. | Cada módulo sobre sus condiciones propias; Establecimientos sobre condiciones generales propias. | Condiciones generales publicables; sin cotización ni aceptación particular. | Edición o retirada de condiciones expuestas y de contribuciones autorizadas. | Delimitación respecto de condiciones particulares y contrato de publicación. |
| Ubicación pública | Conocer dónde se encuentra el establecimiento, HU02; contexto HU13/RF16. | Establecimientos. | Establecimientos sobre la ubicación registrada y publicable. | Solo ubicación autorizada para exposición pública. | Cambio de ubicación pública o retirada de su autorización. | Representación pública sin coordenadas, formato ni proveedor de mapas decidido aquí. |

La invalidación indicada corresponde a cambios efectivos de datos incluidos o de su publicabilidad; no convierte modificaciones no confirmadas en información definitiva. Su cobertura, incluida la gestión administrativa pertinente y los cambios de contribuciones, deberá concretarse. Una retirada parcial invalida la proyección compuesta completa conforme a D3.

Horarios informativos **no son disponibilidad reservable**. Precios informativos **no son cotizaciones aceptadas ni importes fijados de una operación iniciada**; DP-03 conserva la obtención de valores autorizados, su presentación previa y fijación al iniciar la simulación. Los servicios públicos no se agregan automáticamente a cotizaciones (RN-07). Las condiciones generales no representan aceptación contractual particular dentro de UrbanPulse (DF-02/DF-03).

No se incluyen fotografías, valoraciones, identidad privada, contacto ni campos adicionales sin aprobación posterior. Aunque HU06 y C3 contemplen contacto en otras funciones, eso no lo incorpora a esta proyección mínima. No se deciden obligatoriedad, formatos, coordenadas, moneda o esquema JSON. Los datos técnicos de revisión de D4 no amplían las ocho categorías ni se convierten por defecto en contenido público.

## 4. D2 — Titularidad y colaboración modular

**Establecimientos coordina la proyección completa de la ficha pública.** Esta coordinación conceptual aprobada comprende reunir las contribuciones necesarias y reconstruir la ficha respetando sus autoridades; no convierte a Establecimientos en dueño de todos los datos de Recursos y Servicios.

Recursos y Servicios conservan la autoridad sobre sus datos y deciden qué contribuciones pueden exponerse públicamente según sus respectivas reglas. Su participación está condicionada a que la categoría requiera realmente su información pública; no se establece una consulta obligatoria a todos los colaboradores en cada acceso.

La reconstrucción utilizará repositorios propios y fronteras públicas internas autorizadas. Compartir backend y base relacional no permite acceder directamente a tablas ni clases privadas ajenas. No se crean módulos funcionales de Caché, Proyecciones o Mensajería; las responsabilidades técnicas permanecen dentro del backend existente. Tampoco se crean llamadas funcionales circulares entre Establecimientos, Recursos y Servicios.

Redis almacena copias reconstruibles y no adquiere propiedad sobre la ficha ni autoridad sobre publicación. La propiedad técnica exacta de cada colaboración, contrato y dato de revisión sigue pendiente. D2 resuelve quién coordina conceptualmente la proyección; no resuelve por extensión todos los pendientes de titular técnico señalados en C3 y Diseño Interno.

## 5. D3 — Protección de visibilidad

**Dirección conceptual aprobada: combinación de evidencia relacional autoritativa y coordinación de admisibilidad y emisión.**

**Obligación:** una vez efectiva una retirada de publicación, el backend no debe iniciar una nueva emisión del contenido retirado basándose en una comprobación anterior. Esta es una exigencia de diseño, sin mecanismo operativo ni garantía ejecutada acreditados.

| Hecho | Significado y límite |
|---|---|
| Lectura de una copia | Obtener contenido desde Redis, incluso si fue público anteriormente. No acredita autorización actual. |
| Comprobación de admisibilidad | Contrastar evidencia autoritativa de publicabilidad y revisiones pertinentes. Una comprobación aislada puede quedar superada por una retirada concurrente. |
| Emisión efectiva | Inicio de entrega del contenido por el backend. Debe coordinarse con la efectividad de las retiradas; comprobar y responder como pasos aislados no demuestra la obligación. |

El diseño deberá cubrir todas las rutas pertinentes de cambios de publicación: gestión autorizada de Establecimientos, incluida administración dentro de HU11/RF15, y cambios de las contribuciones públicas de Recursos/Servicios. No basta proteger únicamente la consulta ordinaria o un único ejecutor del backend.

La retirada completa impide nuevas emisiones de la ficha retirada. La retirada parcial, de un campo o de una contribución como un servicio, exige **invalidar la proyección compuesta completa**, con reconstrucción posterior de los campos que continúen autorizados. No se acepta la copia anterior completa por conservar otros campos públicos; tampoco se presenta una reconstrucción fallida como ficha completa. Retirar legítimamente un campo difiere de perder una contribución necesaria por un error técnico.

Si no puede acreditarse autorización para publicar, se aplica fallo conservador: no divulgar el contenido dudoso, tanto desde caché como desde una reconstrucción. La invalidación asíncrona y un TTL no sustituyen esta coordinación. El alcance protege nuevas emisiones del backend; no recupera ni borra información ya entregada anteriormente a un cliente ni acredita control sobre copias que este conserve.

Quedan pendientes la cobertura de ejecutores, la sincronización y el punto exacto de emisión, así como la delimitación operativa de cuándo se hace efectiva una retirada y cómo coordinarlo con todas sus rutas. No se adoptan bloqueo SQL específico, mutex, transacción distribuida, protocolo de exclusión ni algoritmo concreto.

## 6. D4 — Revisiones y repoblación concurrente

La dirección aprobada comprende revisiones autoritativas persistidas con los datos correspondientes, copias diferenciadas conceptualmente por revisión y selección de revisión admisible desde una fuente autoritativa. Exige coordinación de admisibilidad antes de devolver contenido y al solicitar carga de copias; no permite seleccionar como vigente una copia solo por existir en Redis.

**Garantía exigida conceptualmente:** una reconstrucción antigua no debe seleccionarse ni emitirse como versión vigente después de un cambio que la invalida. **Garantía no adoptada:** impedir absolutamente toda escritura física tardía en Redis. Una copia antigua podría llegar a escribirse físicamente; ello no autoriza seleccionarla o emitirla como vigente. El diseño futuro debe demostrar la primera obligación sin atribuirle la segunda.

| Aspecto | Criterio conceptual aprobado | Concreción pendiente |
|---|---|---|
| Datos y revisiones | Persistir las revisiones autoritativas con los datos correspondientes. | Propiedad, identidad, persistencia concreta y forma de actualización coherente. |
| Copias por revisión | Distinguir conceptualmente copias de revisiones diferentes. | Identificación física, claves y representación de metadatos. |
| Selección | Determinar la revisión admisible desde autoridad y coordinar su uso conforme a D3. | Contrato, comparación y sincronización con cambios y emisión. |
| Reconstrucción compuesta | Considerar contribuciones y revisiones coherentes de Establecimientos, Recursos y Servicios cuando participen. No acreditar vigencia mezclando arbitrariamente observaciones incompatibles. | Criterio de coherencia entre contribuciones, titularidad de revisiones y coordinación entre fronteras. |
| Solicitud de carga | Evaluar admisibilidad y revisión al solicitar carga segura. Esto no demuestra por sí solo ausencia de carreras posteriores. | Comportamiento de la carga frente a cambios concurrentes y escrituras tardías. |
| Recuperación | Tratar conservadoramente copias recuperadas o pérdida de metadatos; recuperar Redis no acredita revisión vigente o publicación autorizada. | Revalidación, reconstrucción y protocolo de recuperación. |

Invalidar no basta para impedir que una reconstrucción anterior vuelva a cargar contenido. Del mismo modo, haber comprobado una revisión antes de devolver no resuelve la carrera entre comprobación y emisión: D3 mantiene su obligación de coordinación. Los cambios públicos efectivos deben reflejarse en el análisis de revisiones incluso si el evento técnico de invalidación se retrasa.

No se deciden formato de claves, identificadores físicos de revisión, algoritmo de comparación, TTL, comandos Redis, escritura condicional, topología de sincronización ni protocolo de recuperación. No se afirma atomicidad entre Redis y la base relacional, ni se declara un mecanismo implementado de consistencia fuerte.

## 7. D5 — Responsabilidades contractuales y capas

Las filas describen necesidades semánticas aprobadas conceptualmente, sin nombres físicos, métodos, firmas, DTO ni archivos de código. No obligan a crear una clase o interfaz por fila. La coordinación pertenece conceptualmente a Aplicación y las adaptaciones técnicas Redis a Infraestructura; las reglas del núcleo no dependen de clientes técnicos.

| Responsabilidad | Obligación semántica | Capa o frontera conceptual y límite |
|---|---|---|
| Obtener datos definitivos del establecimiento | Distinguir datos obtenidos, inexistencia, no publicabilidad y fallo de fuente. | Aplicación solicita acceso por repositorios propios; Infraestructura adapta persistencia y Dominio conserva sus reglas. |
| Consultar contribuciones públicas cuando sean necesarias | Respetar autoridad y publicabilidad del colaborador; distinguir fallo de ausencia legítima de información pública. | Coordinación de Aplicación mediante fronteras públicas internas de Recursos/Servicios, sin acceso privado. |
| Reconstruir la proyección | Componer las ocho categorías según autorización, contribuciones necesarias y revisiones coherentes, sin presentar fallos como ficha completa. | Coordinación en Aplicación; reglas del núcleo independientes de Redis. Distribución concreta pendiente. |
| Evaluar admisibilidad y revisiones | Acreditar publicación y revisión pertinente con fuente autoritativa, preservando la coordinación D3/D4. | Aplicación coordina reglas y evidencia; ubicación exacta de contratos y reglas técnicas pendiente. |
| Leer copias desde caché | Diferenciar copia, miss y fallo técnico; leer no concede autorización. | Abstracción interna consumida por Aplicación e implementada por adaptación Redis en Infraestructura. |
| Solicitar carga segura de copias | Preservar la revisión y la admisibilidad conforme a D4; distinguir fallo de guardar de invalidez de datos definitivos. | Aplicación solicita mediante abstracción; Infraestructura adapta el acceso Redis. Mecanismo pendiente. |
| Solicitar invalidación por la frontera autorizada | Delimitar el ámbito afectado, incluida proyección compuesta ante retirada parcial; no abrir gestión privada al consumidor. | Frontera conceptual de C3; coordinación de Aplicación y adaptación de Infraestructura, con titular y ubicación pendientes. |
| Coordinar retirada y emisión | Satisfacer la obligación D3 para todos los ejecutores y rutas pertinentes. | Coordinación de Aplicación con las entradas/salidas y cambios pertinentes; punto operativo de emisión pendiente. |

Presentación recibe la consulta web y representa el resultado autorizado mediante la API REST existente; no establece admisibilidad por la presencia de una copia. Dominio mantiene reglas sin depender de Infraestructura. Los adaptadores implementan abstracciones internas y la composición se realiza fuera del núcleo. La ubicación exacta y la propiedad de los puertos permanecen pendientes; el ejemplo de Reservas no obliga a ubicarlos todos en Dominio.

**ISP:** cada cliente debe depender solo de las colaboraciones necesarias. Leer/cargar, solicitar invalidación, acceder a datos definitivos y colaborar con otros módulos no exigen una interfaz general que mezcle broker, pagos y administración. **DIP:** Aplicación coordina mediante abstracciones y los detalles técnicos dependen de esos contratos hacia el núcleo. El despacho en ejecución hacia un adaptador no invierte la dependencia del código. Las llamadas internas no imponen REST entre módulos.

## 8. D6 — Semántica de resultados y fallback

Se deben conservar internamente estas distinciones, sin fijar todavía enumeraciones, códigos HTTP, esquema de errores, políticas de reintento o caché negativa.

| Resultado conceptual | Significado | Tratamiento requerido y límite |
|---|---|---|
| Copia admisible | Contenido cuya publicación y revisión pueden acreditarse mediante D3/D4. | Puede utilizarse coordinando su emisión; un hit físico aislado no acredita esta condición. |
| Cache miss | No se obtiene una copia. | Consultar fuente definitiva y reconstruir por fronteras autorizadas; no significa inexistencia del establecimiento. |
| Fallo técnico de Redis | No puede completarse el acceso técnico a caché. | Fallback según disponibilidad de la fuente definitiva; no transformarlo en miss de negocio o inexistencia. |
| Copia obsoleta o no admisible | Existe contenido cuya revisión o publicabilidad no permite utilizarlo. | No seleccionarlo ni emitirlo como vigente; obtener contenido autorizado por la fuente si es posible. No equivale a inexistencia. |
| Establecimiento inexistente | La fuente definitiva acredita que no existe. | Conservar ese resultado internamente, sin deducirlo de caché ausente o fallida. |
| Establecimiento existente pero no publicable | Existe, pero no procede publicar la ficha. | No divulgar contenido ni motivos privados; preservar diferencia interna respecto de inexistencia. |
| Fallo relacional | No puede obtenerse la evidencia autoritativa necesaria. | Si no puede acreditarse publicabilidad, no divulgar una copia por defecto. No inventar inexistencia ni prometer continuidad. |
| Fallo de reconstrucción de una contribución necesaria | No se completa información requerida para la ficha desde una frontera colaboradora. | No presentar el resultado incompleto como ficha completa ni interpretar el fallo como retirada legítima del campo. |
| Fallo al guardar una copia ya reconstruida | Falla la carga Redis tras obtener correctamente datos definitivos. | No elimina su validez si todavía están autorizados y cumplen D3/D4; se mantiene la posibilidad de respuesta bajo esas condiciones, sin atribuir éxito al guardado. |

Inexistencia y no publicabilidad pueden compartir una respuesta pública neutral, manteniendo su diferencia interna; la forma concreta permanece pendiente. Las respuestas no revelarán motivos privados, estados internos, claves Redis o información protegida. La distinción interna no obliga a exponer diagnósticos técnicos al cliente.

El fallback conserva las mismas obligaciones de visibilidad y coherencia que la ruta de caché; reconstruir no exime de coordinar la emisión. Si la fuente definitiva falla o se satura, no se garantiza continuidad absoluta. Una ficha legítimamente reconstruida sin campos retirados difiere de una ficha incompleta por fallo técnico.

## 9. Escenarios de validación futura

Estos son escenarios conceptuales para diseñar pruebas después de concretar mecanismos y contratos. No son pruebas ejecutadas ni resultados observados. No se fijan métricas, herramientas, carga, tiempos o umbrales; EQ y PC-12 mantienen su estado.

| Escenario | Condición inicial | Intercalado o evento | Resultado esperado para validación futura |
|---|---|---|---|
| Hit válido | Copia y datos autoritativos corresponden a una revisión pública admisible. | Consulta sin cambio invalidante concurrente. | Uso de la copia con admisibilidad y emisión coordinadas; no se asume autorización por el hit. |
| Miss | Fuente definitiva disponible y establecimiento publicable; no hay copia. | Consulta obtiene datos/contribuciones necesarios, reconstruye y solicita carga. | Ficha autorizada completa; ausencia de copia no se interpreta como inexistencia. |
| Falla Redis | Fuente definitiva disponible y publicabilidad acreditable. | Falla la lectura Redis o falla guardar la reconstrucción. | Fallback autorizado; el fallo de guardado no invalida datos todavía admisibles ni se presenta como inexistencia. |
| Retirada completa | Consulta ya leyó o comprobó una ficha antes pública. | La retirada se hace efectiva antes de iniciar una nueva emisión. | El backend no inicia esa emisión con la comprobación anterior; invalidación asíncrona pendiente no permite divulgar. |
| Retirada de un campo | La copia compuesta incluye un campo antes autorizado. | El campo deja efectivamente de ser público antes de una nueva emisión. | Invalidez de la proyección compuesta completa; reconstrucción posterior solo con campos autorizados, sin nueva emisión del retirado. |
| Retirada de un servicio | Una contribución pública de Servicios integra la ficha. | Servicios retira la autorización de esa contribución mientras existe una copia. | Se invalida toda la proyección y se respeta la autoridad de Servicios; no se emite el servicio retirado. |
| Cambio concurrente | Reconstrucción o lectura en curso con contribuciones de varios módulos. | Cambia un dato público y su revisión antes de seleccionar o emitir. | No seleccionar/emitir reconstrucción invalidada como vigente ni mezclar contribuciones sin coherencia acreditada. |
| Reconstrucción obsoleta | Una reconstrucción obtuvo datos de una revisión anterior. | Se hace efectivo un cambio invalidante y después aquella solicita carga. | Coordinación de admisibilidad al solicitar carga; la reconstrucción antigua no se selecciona ni emite como vigente. |
| Evento de invalidación retrasado | Copia anterior presente y cambio público ya efectivo en fuente autoritativa. | El evento RabbitMQ aún no completa la invalidación. | El retraso no autoriza contenido retirado ni selección de revisión invalidada; D3/D4 no dependen solo de recibir el evento. |
| Fallo relacional | Redis conserva una copia; se requiere evidencia autoritativa para acreditar publicación. | La fuente relacional falla y no puede acreditarse publicabilidad. | Fallo conservador, sin divulgar la copia por defecto ni inventar inexistencia. |
| Fallo de contribución | La reconstrucción necesita una contribución pública colaboradora. | Falla esa consulta o su reconstrucción. | Resultado diferenciado; no presentar ficha incompleta como completa ni tratar el error como ausencia legítima. |
| Reinicio/recuperación de Redis | Copias o metadatos pueden perderse o recuperarse con antigüedad incierta. | Redis vuelve a servicio o se detecta pérdida de metadatos. | Tratamiento conservador y autoridad externa a Redis para acreditar revisión/publicación; recuperación física no acredita vigencia. |
| Escritura tardía | Una reconstrucción antigua sigue en curso tras un cambio invalidante. | La copia antigua llega a escribirse físicamente después del cambio o la invalidación. | No se selecciona ni emite como vigente. El ensayo no exige impedir absolutamente toda escritura física tardía. |
| Cambio no confirmado o revertido | Datos y revisión autoritativos corresponden a información pública confirmada. | Una modificación no se confirma o se revierte antes de hacerse definitiva. | No anunciarla ni representarla como versión definitiva; cualquier reconstrucción se apoya en evidencia confirmada. |

La validación futura deberá contrastar intercalados entre retirada y emisión, reconstrucción y carga, y cambios de los módulos participantes. Una secuencia dibujada, una revisión textual o una eliminación aislada no demuestra estas garantías. Los resultados obtenidos y sus límites deberán documentarse cuando existan pruebas reales.

## 10. Riesgos, exclusiones y decisiones pendientes

El riesgo principal es divulgar contenido retirado por usar evidencia anterior o seleccionar una reconstrucción obsoleta. También persisten mezcla incoherente de contribuciones, cobertura incompleta de cambios, pérdida de metadatos, retraso/pérdida/desorden de invalidaciones, fallos de colaboradores y mayor carga relacional durante fallback o reconstrucciones simultáneas. No se acredita una mejora de rendimiento ni se fija tolerancia operativa por campo.

### Límite de ADR-011

Se reconoce la invalidación técnica mediante RabbitMQ ya adoptada conceptualmente. Los productores permanecen en los casos de uso autorizados de Establecimientos y, condicionadamente, de Recursos/Servicios cuando cambien datos incluidos en la ficha. El consumidor técnico está dentro del backend y solicita invalidación por la frontera autorizada; no hay worker independiente ni módulo funcional nuevo.

El procesamiento idempotente es requerido y el **ACK debe ser posterior al efecto requerido**. Si falla la invalidación, el efecto no se considera completado. Los publisher confirms corresponden a una etapa distinta y no prueban consumo ni invalidación. Entrega al menos una vez sigue como objetivo condicionado a conservación, publicación y recuperación; no se promete exactamente una vez ni recuperar intenciones nunca conservadas.

Publicación y recuperación permanecen pendientes. La publicación directa posterior al commit tiene riesgos de pérdida o resultado incierto; **Transactional Outbox está evaluado, no adoptado**. No se afirma atomicidad relacional con RabbitMQ ni con Redis. La invalidación asíncrona por sí sola no garantiza confidencialidad; tampoco lo hace un TTL. Este documento no diseña el flujo completo de publicación/consumo, esquemas, colas, exchanges, confirms, reintentos, DLQ o recuperación.

### Pendientes funcionales conservados

| Pendiente | Límite que D1–D6 conserva |
|---|---|
| PC-01 | Contenido, versiones, servicios y evidencia de aceptación de cotización. Condiciones públicas no son aceptación particular. |
| PC-02 | Creación y relaciones Reserva/Solicitud/Pago, cardinalidades y estados persistidos; una revisión de ficha no resuelve ese modelo. |
| PC-03 | Iniciador y eventual automatización de confirmación de eventos; la consulta pública no los define. |
| PC-04 | Alcance temporal, solapamientos, extremos y espacios compartidos; horarios informativos no resuelven disponibilidad. |
| PC-05 | Garantía de concurrencia y disponibilidad durante coordinación. RN-13 sigue obligatoria y sin mecanismo aprobado; caché y broker no la satisfacen. |
| PC-06 | Precisión monetaria, límites y representación del saldo cero. Fórmula y registro manual completo del saldo ya aprobados no se reabren. |
| PC-07 | Adelanto aprobado sin disponibilidad u otras condiciones: no confirmar; resolución posterior pendiente, sin devolución inventada. |
| PC-08 | Fallos, ausencias, reintentos, duplicados y asociación de resultados del simulador. No quedan resueltos por invalidaciones técnicas. |
| PC-09 | No aceptación, cambios y reapertura sin nuevas transiciones o permisos inferidos. |
| PC-10 | RF13 y ciclo posterior pendientes; sin habilitar cancelación, devolución, expiración o cierre de reservas. |
| PC-11 | Matriz de permisos y mecanismos de autenticación/autorización; D3 no adopta esos mecanismos ni amplía al administrador a gestión de usuarios. |
| PC-12 | Cobertura HU/RF/DA y evaluación EQ; sin nuevas relaciones, métricas o cumplimiento inferidos. |

Permanecen abiertos los mecanismos de visibilidad, cobertura de ejecutores y punto de emisión; identidad y coherencia de revisiones; propiedad y ubicación exacta de puertos; contratos y composición; fuentes públicas de precios/horarios; claves, TTL, evicción, capacidad, clientes, seguridad operativa y recuperación. La aprobación de direcciones conceptuales D3/D4 no selecciona bloqueo, mutex, exclusión, comparación, escritura condicional, transacción distribuida ni protocolo operativo. Las propuestas de origen modular de D1 siguen condicionadas; no se añaden alternativas como decisiones adoptadas.

### Exclusiones e invariantes

Redis se limita a las fichas públicas: se excluyen reservas, disponibilidad, adelantos, saldo, aceptación particular, permisos y datos protegidos. La evidencia relacional de admisibilidad no convierte permisos o reglas de autorización en contenido de la copia pública. Las búsquedas públicas siguen fuera del alcance inicial de caché.

DF-03/DF-04 mantienen confirmación con adelanto simulado aprobado y disponibilidad válida, más aceptación interna del cliente en eventos. Consultar o coordinar no retiene recursos (RN-12 derivada). DP-03 mantiene total/adelanto conocidos antes y fijados al iniciar; precios informativos no alteran esos importes.

Toda operación monetaria es exclusivamente simulada (DF-06/DP-01/DP-07). HU14/RF20 y DP-04–DP-09 conservan registro posterior del saldo completo por propietario autorizado de reserva confirmada propia, fórmula total menos adelanto aprobado y aplicado, una recepción activa e historial de correcciones con autor/fecha. Registrar/corregir saldo no cambia Reserva ni resultado del adelanto (DF-05/RN-16). No hay parciales, fondos reales, comprobantes bancarios ni recepción ficticia de saldo cero.

No se añaden módulos, funcionalidades, estados, tecnologías o decisiones operativas; no se habilitan pagos reales, reembolsos, mensajería propia, compra de comidas/entradas/actividades, reserva de habitaciones o gestión administrativa de usuarios.

### Discrepancias documentales y efecto

| Fuentes y contenido en conflicto | Criterio respaldado | Efecto en este registro |
|---|---|---|
| AGENTS.md/restricciones conservan nueve ADR y el marco anterior sin caché aprobada; catálogo y cierres de ADR-010/011 reconocen once. | Alcances expresos de cierre y autorización actual D1–D6; no se infiere aprobación por fecha o Git. | Reconocer Redis/RabbitMQ en su ámbito conceptual, sin modificar fuentes ni adoptar mecanismos. |
| Catálogo y ADR independientes describen C2 con tres contenedores y C3 anterior; las vistas cerradas representan cinco y componentes técnicos. C2 aún anuncia la actualización de C3 como futura. | Cierres explícitos y contenido actual de C2/C3, con sus límites. | Mantener cinco contenedores, ocho módulos y seis responsabilidades técnicas; no reabrir las vistas. |
| Diseño Interno/Patrones aún contienen referencias a Principios pendiente o reconciliación futura; Principios y el primer C4 tienen cierres conceptuales explícitos. | Alcance individual de cada cierre; contratos concretos continúan pendientes. | Usar criterios conceptuales sin aprobar clases/firmas ni declarar sincronizadas todas las referencias históricas. |
| Desfase de tres capas en README/arquitectura inicial frente a cuatro oficiales, registrado en AGENTS.md y las fuentes revisadas; el catálogo afirma armonización textual. | ADR-002: Presentación, Aplicación, Dominio e Infraestructura. | Aplicar cuatro capas sin corregir etapas cerradas ni atribuir una inspección gráfica actual. |
| ADR, C3 y Diseño Interno conservan pendientes proyección, titular y revisiones; la solicitud aprueba direcciones D1–D6 complementarias. | La autorización actual resuelve categorías, coordinación y dirección conceptual, sin sustituir los documentos previos. | Acotar lo registrado y mantener pendientes autoridad técnica exacta, contratos y mecanismos. |

Las discrepancias identificadas no bloquean este registro acotado. Las referencias gráficas históricas desactualizadas y las menciones de ORM no aprueban tecnologías ni mecanismos. No se corrigen fuentes adicionales ni se afirma una auditoría visual nueva de sus imágenes.

## 11. Implicaciones para el segundo C4

El límite aprobado conceptualmente es desarrollar posteriormente **consulta y carga segura de la ficha pública**, con una **frontera conceptual de invalidación**. Este documento prepara esa vista; no la crea y no aprueba de antemano sus clases, firmas, relaciones concretas o composición.

| Base C3 / acuerdo | Responsabilidad que deberá poder explicarse en el segundo C4 | Límite |
|---|---|---|
| Establecimientos; D1/D2 | Coordinación de la proyección y reconstrucción por datos propios y contribuciones públicas necesarias. | Sin consultas a tablas privadas ni ciclos funcionales; origen exacto de precios/horarios condicionado. |
| Puerto de acceso a caché pública y adaptador Redis; D4–D6 | Lectura, distinción de resultados, fallback y solicitud de carga segura con revisiones. | Abstracciones y adaptación Redis; sin firmas, claves, TTL o algoritmo adoptados aquí. |
| D3/D4/D5 | Admisibilidad, revisión y coordinación de retirada/emisión en cuatro capas. | No basta dibujar comprobar y devolver; la cobertura y garantía operativas requieren diseño y pruebas. |
| Frontera autorizada de invalidación | Solicitud conceptual de invalidación del ámbito afectado, incluida la proyección completa ante retirada parcial. | No exige una clase por caja ni desarrolla el flujo completo RabbitMQ. |
| Puerto/adaptador de publicación y consumidor técnico de C3 | Contexto existente de ADR-011 para reconocer el origen de solicitudes técnicas. | Fuera del desarrollo completo de publicación/consumo en el segundo C4; Outbox y recuperación pendientes. |

C1, C2, C3 y el primer C4 permanecen cerrados en sus alcances respectivos y no se modifican. Se conserva Monolito Modular, ocho módulos, cinco contenedores de contexto y dependencias hacia el núcleo. No se añade módulo funcional de caché/proyección, quinta capa, microservicio o worker independiente.

## 12. Registro de aprobación y estado documental

| Clasificación | Elemento | Alcance y límite de aprobación |
|---|---|---|
| Aprobado conceptualmente por el responsable, 16/10/2026 | Enfoque D1–D6 y límite del segundo C4. | Exclusivamente los acuerdos detallados en la solicitud: ocho categorías condicionadas, Establecimientos coordinador, direcciones D3/D4, responsabilidades semánticas, resultados/fallback y consulta/carga segura con frontera conceptual de invalidación. |
| Aprobado previamente | ADR-010 y ADR-011, según sus registros de cierre. | Redis/cache-aside para fichas públicas y RabbitMQ para invalidación técnica con consumidor interno; sus alcances y mecanismos pendientes se preservan. C2/C3 y tres documentos de Diseño Interno conservan sus cierres conceptuales; primer C4 conserva su alcance directo de Reservas. |
| Condicionado | Origen exacto de precios/horarios y contribuciones públicas. | Deben precisarse fuentes, autoridad y publicación efectiva; no hay aportación obligatoria de todos los módulos ni esquema definitivo. |
| Pendiente | Mecanismos, contratos concretos, composición y validación de garantías. | Incluye punto de emisión, sincronización, revisiones coherentes, carga segura, recuperación, cobertura de cambios y pruebas; la documentación no acredita funcionamiento. |
| No adoptado | Prohibición absoluta de escrituras físicas tardías como requisito adicional. | Se exige impedir selección/emisión de reconstrucción invalidada como vigente, sin exigir ausencia física absoluta de escrituras tardías. |
| No adoptado | Transactional Outbox. | Alternativa evaluada; publicación y recuperación permanecen pendientes según ADR-011. |
| Aprobado y cerrado documentalmente | Redacción y trazabilidad de este registro complementario. | Cierre basado en la auditoría conceptual favorable, sin contradicciones arquitectónicas bloqueantes, comunicada en la solicitud del responsable. Preserva D1–D6 y delimita el segundo C4 a consulta, admisibilidad, reconstrucción, carga segura y frontera conceptual de invalidación. No aprueba contratos concretos, algoritmos, configuración, implementación ni garantías operativas verificadas. |

No se modifican ADR-010/011, C1, C2, C3, primer C4 ni los tres documentos cerrados de Diseño Interno. No se introducen clases o firmas, implementación, configuración o dependencias instaladas. No se registran pruebas operativas ni cumplimiento de EQ. PC-01–PC-12, RF13 y los mecanismos indicados conservan sus estados. No se ejecutan operaciones de incorporación al índice, commit o push por este registro.

**URBANPULSE — DISEÑO TÉCNICO D1–D6 APROBADO CONCEPTUALMENTE — REGISTRO CERRADO DOCUMENTALMENTE — ESTABLECIMIENTOS Y REDIS — SIN COMMIT NI PUSH.**
