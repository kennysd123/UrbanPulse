# UrbanPulse — Diseño interno de módulos

**Estado:** diseño interno corregido tras auditoría, pendiente de aprobación. Fecha: 16/10/2026. No acredita código implementado ni aprueba tecnologías.

## 1. Propósito

Precisar responsabilidades, contratos y dependencias dentro del módulo **Reservas**, manteniendo la trazabilidad del análisis hacia las clases y los casos de uso. Reservas es el módulo de referencia porque coordina la confirmación y necesita colaborar con **Disponibilidad** y **Pagos Simulados**. Este último nombre describe la responsabilidad del módulo Pagos de ADR-001 durante el MVP; no crea un módulo financiero adicional.

UrbanPulse utiliza **Monolito Modular**, con una única aplicación desplegable, y **Clean Architecture** con Presentación, Aplicación, Dominio e Infraestructura (ADR-001/ADR-002). La web se comunica con el backend mediante **API REST** (RC03/ADR-005). La persistencia utiliza una **base de datos relacional**, sin motor concreto aprobado (RC04), y repositorios (ADR-008). El documento de estilo menciona ORM como orientación de infraestructura, sin seleccionar un producto.

Cancha y karaoke utilizan **reserva directa**, con recurso, fecha y bloque o intervalo, adelanto simulado obligatorio y disponibilidad válida al confirmar (DF-04). Salón y recreo utilizan **solicitud de evento**, cotización del propietario y aceptación del cliente dentro de UrbanPulse; la confirmación requiere conjuntamente aceptación, adelanto simulado aprobado y disponibilidad válida (DF-02/DF-03). En recreos se reserva el ambiente o espacio definido por el propietario, sin presumir exclusividad de todo el establecimiento o del día (DF-01). La aprobación del simulador nunca confirma por sí sola.

Se revisaron los ocho documentos de [análisis](../../01-analisis-de-sistema/01-actores.md), los tres de arquitectura y los documentos previos de [reglas](../01-reglas-de-negocio.md), [estados](../02-estados-y-transiciones.md) y [flujos](../03-flujos-de-reserva.md). Estos últimos conservan el catálogo normativo; aquí se desarrolla su traducción a diseño, sin reproducir sus máquinas o recorridos completos. El archivo fue creado en la entrega inicial y esta auditoría corrige su contenido conservando las seis secciones y sus subsecciones. El desarrollo y mantenimiento de este documento se rigen por las instrucciones vigentes de [`AGENTS.md`](../../../AGENTS.md), ubicado en la raíz del repositorio UrbanPulse.

| Nivel | Base y aplicación en este documento |
|---|---|
| Aprobado | ADR-001–ADR-009; RC01/RC03/RC04/RC06/RC07/RC10; DF-01–DF-06 y DP-01–DP-12; reglas RN vigentes según su nivel original. No se cambia ninguna de ellas. |
| Derivado | Coordinar condiciones mediante contratos internos; no aceptar importes o resultados de pago declarados por el navegador; no acceder a tablas de otro módulo. No constituyen funciones adicionales. |
| Propuesto | Carpetas, archivos, clases, objetos de valor, firmas, DTO, composición y distribución concreta de contratos. TypeScript es exclusivamente **notación ilustrativa: ejemplo académico no aprobado como lenguaje del proyecto**. |
| Pendiente | PC-01–PC-12 del catálogo de reglas, especialmente concurrencia PC-05, modelo persistido PC-02, contratos del simulador PC-08 y precisión monetaria PC-06. RF13 continúa pendiente de validación. |

**Discrepancias conservadas:** [arquitectura inicial](../../02-arquitectura-software/01-arquitectura-inicial.md) describe tres capas generales, mientras [estilo](../../02-arquitectura-software/02-estilo-arquitectonico.md), [enfoque](../../02-arquitectura-software/03-enfoque-arquitectonico.md) y [ADR-002](../../01-analisis-de-sistema/07-decisiones-arquitectonicas.md) establecen cuatro capas oficiales. Además, la sección 3 de ADR afirma que los textos de arquitectura ya explicitan cuatro, lo que no coincide con el texto inicial actual. Se aplica ADR-002 sin corregir silenciosamente las fuentes. Las observaciones históricas sobre tecnologías y cancelación en imágenes no son decisiones aprobadas ni una nueva inspección visual. La referencia Marketplace/Guía 004 no fue aportada ni localizada en el proyecto; la organización sigue las seis secciones solicitadas, sin afirmar una comparación directa con aquel archivo.

## 2. Estructura de carpetas

Árbol **propuesto**, expresado con extensión `.ts` solo para relacionar la notación académica de la sección 6. No se crean estos archivos en `src/`. Los nombres de tablas, rutas HTTP, frameworks, ORM y motor permanecen sin definir.

```text
src/
└── modules/
    └── reservas/
        ├── dominio/
        │   ├── reserva.ts
        │   ├── recurso-id.ts
        │   ├── periodo-reserva.ts
        │   ├── datos-reserva-directa.ts
        │   ├── adelanto-aplicado.ts
        │   ├── contexto-adelanto.ts
        │   └── puertos/
        │       ├── reserva.repository.ts
        │       ├── disponibilidad.port.ts
        │       └── adelanto-simulado.port.ts
        ├── aplicacion/
        │   ├── confirmar-reserva.command.ts
        │   └── confirmar-reserva.use-case.ts
        ├── infraestructura/
        │   ├── reserva-repository.adapter.ts
        │   ├── disponibilidad-interna.adapter.ts
        │   └── adelanto-simulado-interno.adapter.ts
        ├── presentacion/
        │   └── reserva.controller.ts
        ├── reservas.module.ts
        └── index.ts
```

| Archivo | Capa | Responsabilidad | Depende de |
|---|---|---|---|
| `recurso-id.ts` | Dominio | Identificación inmutable de cancha o sala; no carga datos de Recursos. | Tipos básicos. |
| `periodo-reserva.ts` | Dominio | Fecha y referencia del bloque/intervalo configurado; sin imponer duración uniforme. | Tipos básicos. |
| `contexto-adelanto.ts` | Dominio | Contrato conceptual de operación: titular, modalidad, selección e importes fijados y resultado registrado. | `RecursoId`, `PeriodoReserva`. |
| `datos-reserva-directa.ts` | Dominio | Datos propios de confirmación: titular, modalidad, recurso, periodo, total y adelanto requerido fijados. | `RecursoId`, `PeriodoReserva`. |
| `adelanto-aplicado.ts` | Dominio | Evidencia mínima local: referencia de operación, importe aprobado y aplicado, aprobación y carácter simulado. | Tipos básicos; no depende del contexto de Pagos. |
| `reserva.ts` | Dominio | Expresar condiciones locales y conservar datos propios y evidencia del adelanto aplicado. | `DatosReservaDirecta`, `AdelantoAplicado`, objetos de valor; no depende de `ContextoAdelanto`. |
| `reserva.repository.ts` | Dominio | Puerto de persistencia de confirmación con obligación de no admitir incompatibles. | `Reserva`, `RecursoId`, `PeriodoReserva`. |
| `disponibilidad.port.ts` | Dominio | Consultar validez de selección al confirmar, sin retener recursos. | `RecursoId`, `PeriodoReserva`. |
| `adelanto-simulado.port.ts` | Dominio | Consultar contexto y resultado registrado de la operación simulada propia. | `ContextoAdelanto`. |
| `confirmar-reserva.command.ts` | Aplicación | Transportar referencia de operación y cliente autenticado. | Tipos básicos. |
| `confirmar-reserva.use-case.ts` | Aplicación | Coordinar consulta de adelanto, disponibilidad, dominio y persistencia. | Comando, entidad y tres puertos. |
| `reserva-repository.adapter.ts` | Infraestructura | Punto de implementación de persistencia y garantía PC-05; ejemplo deliberadamente incompleto. | Puerto, entidad y futuros detalles relacionales. |
| `disponibilidad-interna.adapter.ts` | Infraestructura | Traducir el puerto a la API pública interna de Disponibilidad. | Puerto y contrato público de Disponibilidad. |
| `adelanto-simulado-interno.adapter.ts` | Infraestructura | Traducir consulta al módulo Pagos Simulados. | Puerto y contrato público de Pagos. |
| `reserva.controller.ts` | Presentación | Validar forma de entrada, traducir identidad y llamar al caso de uso. | Comando y caso de uso. |
| `reservas.module.ts` | Raíz de composición | Construir adaptadores e inyectarlos en caso de uso y controlador. | Capas y contratos públicos de módulos colaboradores. |
| `index.ts` | Frontera pública | Exponer únicamente la fachada necesaria del módulo. | Tipos públicos de Presentación/Aplicación. |

Las API públicas de Disponibilidad y Pagos pertenecen a sus respectivos módulos; sus firmas locales de ejemplo aparecen en los adaptadores, sin diseñar aquí su estructura de carpetas. El precio y adelanto configurados proceden de Recursos/Disponibilidad según la responsabilidad por concretar; Pagos conserva los importes fijados para la operación. Reservas no recalcula importes desde la configuración actual ni convierte ausencia de importe en cero (DP-03/RN-17).

## 3. Capas del módulo y regla de dependencia

Dominio define reglas, objetos de valor y puertos, conforme al enfoque arquitectónico vigente. Aplicación coordina los casos de uso. Presentación recibe solicitudes autenticadas y no accede directamente a persistencia. Infraestructura implementa los puertos definidos hacia el interior. La raíz de composición conecta interfaces e implementaciones; puede conocer todas las capas para construirlas, sin trasladar reglas de negocio a ese ensamblado.

| Capa | Contiene | Responsabilidad | Puede depender de | No puede depender de |
|---|---|---|---|---|
| Dominio | `Reserva`, objetos de valor, contexto y puertos. | Condiciones de confirmación y contratos necesarios para preservarlas. | Elementos del propio dominio. | Infraestructura, Presentación, Aplicación, frameworks o tablas. |
| Aplicación | Comando y `ConfirmarReservaUseCase`. | Coordinar reglas, identidad y acceso mediante puertos. | Dominio y sus contratos. | Adaptadores concretos, controladores, tablas de módulos. |
| Presentación | `ReservaController`. | Traducir entrada/salida REST y validar estructura. | API de Aplicación. | Repositorios concretos, base de datos o reglas duplicadas. |
| Infraestructura | Tres adaptadores. | Persistir y traducir integraciones internas. | Puertos del Dominio y API públicas de colaboradores; detalles tecnológicos futuros. | Tablas o clases privadas de otros módulos. |
| Raíz de composición | `reservas.module.ts`. | Ensamblar dependencias. | Las cuatro capas y API públicas necesarias. | No debe ser utilizada por Dominio o Aplicación para localizar servicios. |

Los módulos se comunican mediante **contratos internos definidos**, sin acceso directo a tablas ajenas. Compartir despliegue y base de datos relacional no autoriza compartir internamente todos los modelos. Las llamadas entre módulos del ejemplo son internas al monolito; no implican HTTP interno, microservicios ni un protocolo adicional aprobado.

El siguiente Mermaid representa **dependencias del código**: la flecha apunta al elemento conocido. La ejecución puede pasar desde un puerto a su adaptador, aunque el adaptador sea quien depende de la interfaz. No hay flecha de Dominio hacia Infraestructura.

```mermaid
flowchart LR
    P[Presentación] --> A[Aplicación]
    A --> D[Dominio: entidad y puertos]
    I[Infraestructura: adaptadores] --> D
    I --> V[API pública de Disponibilidad]
    I --> G[API pública de Pagos Simulados]
    I --> B[Detalle relacional pendiente]
    C[Raíz de composición] --> P
    C --> A
    C --> D
    C --> I
```

La obligación global RN-13 no puede garantizarse solo dentro de una entidad en memoria. Dominio la expresa en el contrato del repositorio; Aplicación integra la consulta y la construcción de la confirmación en ese límite; la implementación debe demostrar la garantía concurrente. **PC-05 permanece abierto** y ningún adaptador ilustrativo lo resuelve. El callback `preparar` expresa dónde se solicita la evaluación, pero no proporciona atomicidad, exclusividad ni protección frente a cambios concurrentes de disponibilidad. También debe contrastarse que la Reserva candidata identifica el mismo recurso y periodo recibidos por el repositorio. El reparto técnico de esa responsabilidad entre persistencia y Disponibilidad sigue pendiente; no se aprueban bloqueos, transacciones distribuidas ni reservas temporales.

## 4. Diagrama de clases

Las clases e interfaces siguientes constituyen una **propuesta de diseño interno, no código implementado**. El detalle modela la confirmación directa de cancha/karaoke. No sirve para confirmar eventos sin ampliar el contrato con evidencia de cotización y aceptación interna; esa extensión depende de PC-01/PC-02/PC-03. Se propone representar una confirmación candidata mediante `Reserva`, sin enumeración persistida de estados.

`RecursoId` y `PeriodoReserva` son valores inmutables. La composición expresa que cada Reserva contiene su propia representación de esos valores; no significa que sea propietaria del recurso del establecimiento ni que borrarlo elimine Recursos. Las multiplicidades son propuestas del objeto en memoria, no cardinalidades entre tablas de Reserva, Solicitud y Pago, todavía pendientes PC-02.

**Corrección OBS-01:** se descarta conservar todo `ContextoAdelanto` en la entidad. Es un contrato de consulta del puerto, no el modelo persistente de Reserva ni una entidad del módulo Pagos. Aplicación proyecta sus datos a `DatosReservaDirecta`; Reserva conserva una copia inmutable y una evidencia local `AdelantoAplicado`. Esta mantiene referencia de operación, importe aprobado y aplicado y naturaleza simulada, junto con titular, selección e importes fijados de Reserva. La asociación Reserva–operación se registra solo al persistir satisfactoriamente la confirmación. El detalle del intento, su resultado registrado y los antecedentes permanecen en Pagos y deben ser auditables por la referencia; no se eliminan por reducir el objeto de Reserva. Un candidato descartado no constituye un adelanto aplicado persistido. Correlación inequívoca, duplicados y conservación del vínculo siguen pendientes PC-02/PC-08; no se afirma que una referencia aislada los resuelva.

```mermaid
classDiagram
    class Reserva {
        -DatosReservaDirecta datos
        +AdelantoAplicado adelantoAplicado
        +DatosReservaDirecta datosPropios
        +RecursoId recurso
        +PeriodoReserva periodo
        +confirmarDirecta(datos, operacionAdelantoId, resultado, disponible) Reserva$
    }
    class DatosReservaDirecta {
        <<interface>>
        +String clienteId
        +String modalidad
        +RecursoId recurso
        +PeriodoReserva periodo
        +String totalFijado
        +String adelantoRequeridoFijado
    }
    class AdelantoAplicado {
        <<interface>>
        +String operacionId
        +String importeAprobadoAplicado
        +String resultado
        +Boolean simulado
    }
    class RecursoId {
        +String valor
    }
    class PeriodoReserva {
        +String fecha
        +String referenciaSeleccion
    }
    class ContextoAdelanto {
        <<interface>>
        +String operacionId
        +String clienteId
        +String modalidad
        +RecursoId recurso
        +PeriodoReserva periodo
        +String totalFijado
        +String adelantoFijado
        +String resultado
    }
    class ConfirmarReservaCommand {
        <<interface>>
        +String operacionId
        +String clienteId
    }
    class ConfirmarReservaUseCase {
        +execute(command) Promise
    }
    class ReservaRepository {
        <<interface>>
        +confirmarSiCompatible(recurso, periodo, preparar) Promise
    }
    class DisponibilidadPort {
        <<interface>>
        +verificarAlConfirmar(recurso, periodo) Promise
    }
    class AdelantoSimuladoPort {
        <<interface>>
        +consultar(operacionId, clienteId) Promise
    }
    class ReservaController {
        +confirmar(solicitud) Promise
    }
    class ReservaRepositoryAdapter {
        +confirmarSiCompatible(recurso, periodo, preparar) Promise
    }
    class DisponibilidadInternaAdapter {
        +verificarAlConfirmar(recurso, periodo) Promise
    }
    class AdelantoSimuladoInternoAdapter {
        +consultar(operacionId, clienteId) Promise
    }
    class ReservasModule {
        <<raiz de composicion>>
        +componerReservas(disponibilidadApi, pagosApi) Object
    }
    Reserva "1" *-- "1" RecursoId : valor de recurso
    Reserva "1" *-- "1" PeriodoReserva : valor de periodo
    Reserva "1" *-- "1" DatosReservaDirecta : copia propia
    Reserva "1" *-- "1" AdelantoAplicado : evidencia local
    DatosReservaDirecta --> RecursoId : identifica
    DatosReservaDirecta --> PeriodoReserva : identifica
    ContextoAdelanto --> RecursoId : identifica
    ContextoAdelanto --> PeriodoReserva : identifica
    ReservaController --> ConfirmarReservaUseCase : usa
    ConfirmarReservaUseCase ..> ConfirmarReservaCommand : recibe
    ConfirmarReservaUseCase --> ReservaRepository : usa puerto
    ConfirmarReservaUseCase --> DisponibilidadPort : usa puerto
    ConfirmarReservaUseCase --> AdelantoSimuladoPort : usa puerto
    ConfirmarReservaUseCase ..> Reserva : solicita confirmacion
    ConfirmarReservaUseCase ..> ContextoAdelanto : consulta sin conservar en Reserva
    ConfirmarReservaUseCase ..> DatosReservaDirecta : proyecta
    ReservaRepository ..> Reserva : persiste
    AdelantoSimuladoPort ..> ContextoAdelanto : devuelve
    ReservaRepositoryAdapter ..|> ReservaRepository
    DisponibilidadInternaAdapter ..|> DisponibilidadPort
    AdelantoSimuladoInternoAdapter ..|> AdelantoSimuladoPort
    ReservasModule ..> ReservaRepositoryAdapter : construye
    ReservasModule ..> DisponibilidadInternaAdapter : construye
    ReservasModule ..> AdelantoSimuladoInternoAdapter : construye
    ReservasModule ..> ConfirmarReservaUseCase : construye
    ReservasModule ..> ReservaController : construye
```

`confirmarSiCompatible` expresa una obligación de persistencia consistente; la función `preparar` debe ejecutarse dentro del ámbito de consistencia que se decida. Su firma no demuestra que exista dicho ámbito ni prescribe cómo coordinarlo. Una evidencia de disponibilidad aislada puede quedar obsoleta; el contrato exige impedir la doble confirmación y conservar la asociación de adelanto aplicado, pero falta diseñar cómo satisfacerlo. El adaptador de la sección 6.3 falla expresamente antes de ejecutar el callback: no ofrece una alternativa secuencial que aparente cumplir PC-05.

### 4.1 Notación UML utilizada

| Símbolo | Significado | Ejemplo en UrbanPulse |
|---|---|---|
| `-->` | Asociación dirigida: un objeto conoce o utiliza otro mediante una referencia. | Caso de uso → `DisponibilidadPort`; controlador → caso de uso. |
| `..>` | Dependencia: uso de un tipo o construcción, sin expresar propiedad permanente. | Caso de uso recibe `ConfirmarReservaCommand`; raíz construye adaptadores. |
| `..\|>` | Realización de interfaz; triángulo hacia el contrato. | `ReservaRepositoryAdapter` realiza `ReservaRepository`. |
| `*--` | Composición de valores integrantes del objeto, sin identidad de entidad independiente. | Reserva contiene representación de `RecursoId` y `PeriodoReserva`. |
| `+` / `-` | Visibilidad pública / privada, respectivamente. | `+execute`; `-datos` en Reserva. |
| `"1"` en ambos extremos | Cada instancia representada participa con exactamente un valor; multiplicidad propuesta en memoria. | Una Reserva tiene un valor de recurso y uno de periodo. |
| `<<interface>>` | Contrato implementable. | Los tres puertos y los DTO conceptuales. |
| `$` al final de operación | Operación estática en Mermaid UML. | `Reserva.confirmarDirecta`. |

No se representa herencia entre modalidades, agregación compartida ni multiplicidades de pagos/solicitudes: no hacen falta para el ejemplo y no están resueltas como modelo persistido.

## 5. Flujo de ejecución: confirmar reserva

Recorrido principal: **reserva directa de cancha con adelanto simulado obligatorio**. Los pasos 1–5 incluyen la preparación en Disponibilidad/Recursos y Pagos Simulados; el caso de uso de Reservas se invoca con una referencia de operación ya iniciada. Separar inicio del adelanto y confirmación es una propuesta de coordinación, sin fijar endpoints, asincronía o disparadores adicionales. La selección se recupera del contexto interno de esa operación, no se acepta un resultado aprobado enviado por el navegador.

1. El cliente selecciona cancha, fecha y bloque configurado después de consultar disponibilidad; esa consulta no retiene el recurso.
2. La aplicación recibe la operación mediante la presentación autenticada y coordina el inicio del adelanto en Pagos Simulados.
3. Identifica precio total y adelanto configurado por el propietario para ese recurso, y los muestra antes de iniciar. El diseño de cómo reconocer la información mostrada sigue pendiente en los contratos de entrada; no se asume aceptación de una configuración diferente.
4. Pagos fija los importes al iniciar (DP-03), registra/invoca la simulación y conserva su correlación con cliente, recurso y selección temporal. Las firmas y asociación exacta son propuestas sujetas a PC-08.
5. El simulador devuelve aprobación o rechazo; Pagos registra el resultado. Reservas lo consulta mediante `AdelantoSimuladoPort` y refleja la situación para RF19.
6. Si el resultado no está aprobado, la reserva no se confirma. Ausencia de respuesta no se transforma en rechazo de negocio ni en aprobación.
7. Con adelanto aprobado, el caso de uso solicita al repositorio el límite `confirmarSiCompatible`; dentro de ese límite consulta `DisponibilidadPort.verificarAlConfirmar`.
8. Aplicación proyecta el contexto a datos propios de Reserva. `Reserva.confirmarDirecta` exige aprobación y disponibilidad y construye la evidencia mínima del adelanto aplicado candidato; RN-13 exige además impedir confirmaciones incompatibles globalmente. La entidad expresa condiciones locales y el repositorio asume la obligación global pendiente de implementación PC-05.
9. Solo si se cumplen las condiciones y puede satisfacerse esa obligación se persiste la confirmación y se obtiene su identificador. No se afirma que una consulta seguida de escritura proporcione la garantía.
10. Presentación devuelve el resultado: confirmación registrada o explicación de la falta de confirmación. Son resultados del caso de uso, no nuevos estados persistidos.

La secuencia siguiente muestra **ejecución entre componentes internos**, no dependencias del código. El bloque delimitado es una obligación de diseño por satisfacer, no una garantía técnica ya implementada.

```mermaid
sequenceDiagram
    actor C as Cliente
    participant W as Web y presentación de inicio
    participant D as API interna de Disponibilidad
    participant G as API interna de Pagos Simulados
    participant S as Simulador de UrbanPulse
    participant R as ReservaController
    participant U as ConfirmarReservaUseCase
    participant P as AdelantoSimuladoInternoAdapter
    participant Q as ReservaRepositoryAdapter
    participant V as DisponibilidadInternaAdapter
    participant E as Reserva
    C->>W: Seleccionar cancha, fecha y bloque
    W->>D: Consultar selección y configuración
    D-->>W: Disponibilidad consultada, total y adelanto
    W-->>C: Mostrar total y adelanto antes de iniciar
    C->>W: Iniciar operación autenticada
    W->>G: Iniciar adelanto sobre selección e importes informados
    G->>G: Fijar importes de la operación (DP-03)
    G->>S: Invocar simulación y registrar intento
    S-->>G: Aprobado o rechazado
    G->>G: Registrar resultado asociado (RF18/RF19)
    G-->>W: Referencia de operación
    W->>R: Solicitar confirmación con referencia e identidad autenticada
    R->>U: execute(command)
    U->>P: consultar(operacionId, clienteId)
    P->>G: Consultar operación propia registrada
    G-->>P: Contexto fijado y resultado, o sin resultado
    P-->>U: Contexto o ausencia
    alt Adelanto no aprobado o ausente
        U-->>R: Sin confirmación, reflejar situación (RF19)
    else Adelanto aprobado
        U->>Q: confirmarSiCompatible(recurso, periodo, preparar)
        Note over Q,D: PC-05: ámbito de consistencia por diseñar. Sin implementación garantizada.
        rect rgb(245, 245, 245)
            Q->>U: Ejecutar preparar dentro del ámbito pendiente
            U->>V: verificarAlConfirmar(recurso, periodo)
            V->>D: Consultar validez de selección al confirmar
            D-->>V: Disponible o no disponible
            V-->>U: Evidencia para evaluación
            U->>U: Proyectar ContextoAdelanto a DatosReservaDirecta
            U->>E: confirmarDirecta(datos, operacionAdelantoId, resultado, disponible)
            alt Evidencia insuficiente
                E-->>U: No cumple condiciones
                U-->>Q: Interrumpir sin persistir confirmación
            else Cumple condiciones locales
                E-->>U: Reserva candidata con evidencia local del adelanto
                U-->>Q: Reserva candidata
                Q->>Q: Impedir incompatibles y persistir Reserva y vínculo de adelanto: pendiente
            end
        end
        Q-->>U: Identificador si persiste, o fallo sin éxito declarado
        U-->>R: Resultado solo después de persistencia satisfactoria
    end
    R-->>W: Resultado conceptual sin contrato HTTP definitivo
    W-->>C: Mostrar situación de reserva y adelanto simulado
```

| Paso | Origen → destino | Acción | Capa | Trazabilidad |
|---|---|---|---|---|
| 1 | Cliente → Web → Disponibilidad | Seleccionar recurso, fecha, bloque y consultar; sin exclusividad. | Presentación / Aplicación colaboradora. | HU03/RF03; RF04 contextual con HU03; RN-01/RN-02/RN-12. |
| 2 | Web → operación de inicio en Pagos | Recibir intención del cliente autenticado. | Presentación / Aplicación. | RF04/RF11; HU09; ADR-005/ADR-007. |
| 3 | Configuración del recurso → Web | Mostrar total y adelanto configurado. | Aplicación colaboradora / Presentación. | HU07/RF09; RF11; RN-04/RN-17; DF-04/DP-02. |
| 4 | Pagos → Simulador | Fijar importes, registrar e invocar simulación. | Aplicación / Infraestructura de Pagos. | HU09/RF11/RF18; DP-01/DP-03; RN-14/RN-17. |
| 5 | Simulador → Pagos → puerto de Reservas | Registrar y consultar resultado asociado a la operación propia. | Infraestructura / Aplicación. | RF18/RF19; HU09; DP-01; PC-08 para correlación técnica. |
| 6 | Caso de uso → Presentación | Reflejar adelanto no aprobado sin confirmar. | Aplicación / Presentación. | RF12/RF19; RN-04/RN-15/RN-16; DF-04/DP-12. |
| 7 | Caso de uso → repositorio → Disponibilidad | Verificar al confirmar dentro del ámbito pendiente. | Aplicación / puertos de Dominio / Infraestructura. | RF04/RF12; RN-13; DP-12; ADR-004; PC-05. |
| 8 | Caso de uso → Reserva | Aplicar guardas de dominio y obligación global del contrato. | Dominio. | RF12; RN-04/RN-13; DF-04; DP-02/DP-12. |
| 9 | Repositorio → persistencia de Reservas | Registrar solo confirmación compatible; sin mecanismo elegido. | Infraestructura. | RF04/RF12; RN-13; ADR-008; PC-02/PC-05. |
| 10 | Caso de uso → controlador → cliente | Comunicar confirmación o falta de ella y resultado simulado. | Aplicación / Presentación. | RF19; HU10/RF14 como consulta posterior; DP-10 como contexto. |

Para **salón y recreo**, la solicitud, cotización y aceptación interna preceden la evaluación según el recorrido propuesto en F-03/F-04. Se necesitan condiciones aceptadas, adelanto aprobado y disponibilidad válida conjuntamente (RN-09/RN-11; DF-02/DF-03; RF07/RF10/RF12). La aceptación del propietario no sustituye la del cliente. El iniciador de confirmación de eventos sigue pendiente PC-03; el controlador ilustrado no otorga ese permiso. DF-01 delimita el recurso del recreo, sin resolver todos los solapamientos PC-04.

El **registro posterior del saldo completo** pertenece a HU14/RF20, no a `ConfirmarReservaUseCase`. Saldo = total acordado − adelanto simulado aprobado y aplicado (DP-04); no se admiten parciales (DP-05). Propietario autorizado, reserva confirmada propia, un registro activo, método informativo e historial con autor/fecha según DP-06–DP-09. RF14/DP-10 permite consulta autorizada. DP-11 sitúa la liquidación representada el día del servicio en cancha/karaoke y según condiciones en eventos. Registrar el saldo **no cambia Reserva ni el adelanto** (DF-05/RN-16); saldo cero sigue pendiente sin recepción ficticia. Estos contratos no se implementan en los ejemplos de confirmación.

## 6. Código de referencia

Todos los bloques TypeScript son **ejemplos académicos y notación ilustrativa no aprobada**; permanecen en este Markdown. Se omiten importaciones entre archivos para leer los fragmentos como un único ámbito conceptual; las dependencias corresponden a la tabla de la sección 2. No se selecciona framework, motor, proveedor financiero ni contrato HTTP. Los contratos propuestos no son una implementación lista para producción.

**Advertencia OBS-03:** los ejemplos **no constituyen una implementación ejecutable completa**. Faltan autenticación real, traducción de DTO de frontera, persistencia, tratamiento uniforme de errores y la garantía PC-05. Una eventual comprobación de tipos de los fragmentos concatenados solo acredita coherencia estática; no valida esas piezas ausentes ni aprueba TypeScript para UrbanPulse.

### 6.1 Dominio · entidad e interfaces

En `recurso-id.ts` y `periodo-reserva.ts` se propone conservar identidades y selección temporal inmutables. La referencia identifica un bloque de cancha o intervalo de karaoke configurado, no prescribe su duración. El contrato colaborador debe validar existencia y correspondencia de recurso, fecha y selección. Formatos temporales, extremos e incompatibilidades siguen pendientes PC-04; el ejemplo no calcula solapamientos.

```typescript
class RecursoId {
  constructor(public readonly valor: string) {
    if (!valor.trim()) throw new Error("Recurso requerido");
  }
}

class PeriodoReserva {
  constructor(
    public readonly fecha: string,
    public readonly referenciaSeleccion: string
  ) {
    if (!fecha.trim() || !referenciaSeleccion.trim()) {
      throw new Error("Fecha y selección temporal requeridas");
    }
  }
}
```

`contexto-adelanto.ts` representa la información devuelta por Pagos mediante un contrato interno, nunca un DTO confiado al cliente. Los importes se mantienen como cadenas opacas: no se hace aritmética ni se aprueba moneda, escala o límites PC-06. La ausencia de contexto representa falta de resultado consultable, no un estado nuevo. El tipo limita el ejemplo a cancha/karaoke y no admite eventos.

```typescript
interface ContextoAdelanto {
  readonly operacionId: string;
  readonly clienteId: string;
  readonly modalidad: "cancha" | "karaoke";
  readonly recurso: RecursoId;
  readonly periodo: PeriodoReserva;
  readonly totalFijado: string;
  readonly adelantoFijado: string;
  readonly resultado: "aprobado" | "rechazado";
}
```

`datos-reserva-directa.ts` y `adelanto-aplicado.ts` definen contratos **locales de Reservas**, independientes de `ContextoAdelanto`. Se conservan por separado adelanto requerido fijado e importe aprobado y aplicado: en este recorrido se aplica el importe fijado de la operación aprobada, nunca una tarifa actualizada ni un rechazo. Las cadenas no resuelven validación monetaria PC-06. El resultado literal `aprobado` y la marca `simulado` describen la evidencia del adelanto; no agregan estados de Reserva.

```typescript
interface DatosReservaDirecta {
  readonly clienteId: string;
  readonly modalidad: "cancha" | "karaoke";
  readonly recurso: RecursoId;
  readonly periodo: PeriodoReserva;
  readonly totalFijado: string;
  readonly adelantoRequeridoFijado: string;
}

interface AdelantoAplicado {
  readonly operacionId: string;
  readonly importeAprobadoAplicado: string;
  readonly resultado: "aprobado";
  readonly simulado: true;
}
```

En `reserva.ts`, la fábrica expresa condiciones locales RN-04/RN-15. El resultado es candidato a persistencia; **crearlo en memoria no acredita una reserva confirmada ni un adelanto aplicado almacenados**. Se copia la selección y se congela la representación local para no conservar el objeto de consulta de Pagos ni referencias mutables a su respuesta. No se define una máquina persistida ni la creación de Reserva antes del adelanto PC-02. La entidad expone una instantánea de sus datos propios para el futuro mapeo; no contiene operaciones de recepción o corrección del saldo (DF-05).

```typescript
class Reserva {
  private constructor(
    private readonly datos: DatosReservaDirecta,
    public readonly adelantoAplicado: AdelantoAplicado
  ) {}

  get recurso(): RecursoId { return this.datos.recurso; }
  get periodo(): PeriodoReserva { return this.datos.periodo; }
  get datosPropios(): DatosReservaDirecta { return this.datos; }

  static confirmarDirecta(
    datos: DatosReservaDirecta,
    operacionAdelantoId: string,
    resultado: "aprobado" | "rechazado",
    disponible: boolean
  ): Reserva {
    if (datos.modalidad !== "cancha" && datos.modalidad !== "karaoke") {
      throw new Error("El ejemplo solo admite reserva directa");
    }
    if (resultado !== "aprobado" || !disponible) {
      throw new Error("No se cumplen las condiciones de confirmación directa");
    }
    if (!operacionAdelantoId.trim()) {
      throw new Error("Referencia del adelanto requerida para trazabilidad");
    }
    const propios: DatosReservaDirecta = Object.freeze({
      clienteId: datos.clienteId,
      modalidad: datos.modalidad,
      recurso: Object.freeze(new RecursoId(datos.recurso.valor)),
      periodo: Object.freeze(new PeriodoReserva(
        datos.periodo.fecha, datos.periodo.referenciaSeleccion
      )),
      totalFijado: datos.totalFijado,
      adelantoRequeridoFijado: datos.adelantoRequeridoFijado
    });
    const aplicado: AdelantoAplicado = Object.freeze({
      operacionId: operacionAdelantoId,
      importeAprobadoAplicado: datos.adelantoRequeridoFijado,
      resultado: "aprobado",
      simulado: true
    });
    const reserva = new Reserva(propios, aplicado);
    Object.freeze(reserva);
    return reserva;
  }
}
```

En `dominio/puertos/` se definen las tres interfaces. El contrato del repositorio incluye la obligación global RN-13, que una entidad aislada no puede comprobar. `preparar` permite ubicar la consulta de disponibilidad y construcción dentro del ámbito de consistencia por diseñar, sin elegir su técnica. PC-05 debe precisar cómo coordinar Disponibilidad y persistencia de Reservas para impedir también carreras con cambios de disponibilidad.

```typescript
interface ReservaRepository {
  // Obligación propuesta, SIN implementación de garantía concurrente:
  // ejecutar preparar y persistir sin admitir confirmaciones incompatibles.
  // Resolver ámbito, conflictos y coordinación con Disponibilidad: PC-05.
  // La candidata debe corresponder al recurso y periodo de estos argumentos.
  // Conservar datos propios y vínculo de adelanto aprobado y aplicado.
  // Un fallo no registra confirmación; no modifica el resultado en Pagos.
  // Retornar identificador únicamente tras persistencia satisfactoria.
  confirmarSiCompatible(
    recurso: RecursoId,
    periodo: PeriodoReserva,
    preparar: () => Promise<Reserva>
  ): Promise<string>;
}

interface DisponibilidadPort {
  // Consulta de validez actual; por sí sola NO retiene ni garantiza exclusividad.
  verificarAlConfirmar(
    recurso: RecursoId,
    periodo: PeriodoReserva
  ): Promise<boolean>;
}

interface AdelantoSimuladoPort {
  // Consulta autorizada de operación propia y resultado ya registrado.
  // La asociación exacta y los resultados repetidos siguen pendientes PC-08.
  consultar(
    operacionId: string,
    clienteId: string
  ): Promise<ContextoAdelanto | undefined>;
}
```

Las condiciones de eventos no están representadas por un booleano inventado en el comando. Antes de reutilizar la entidad para esa modalidad deberá proponerse un contrato confiable de cotización y aceptación interna, conservando la conjunción de DF-03 y sus pendientes. No se incorpora operación de cancelación ni reembolso.

### 6.2 Aplicación · caso de uso

`confirmar-reserva.command.ts` solo transporta referencia de operación e identidad obtenida del contexto autenticado. La selección, importes y resultado se recuperan por el puerto; el usuario no puede declarar la aprobación. El comando no define la solicitud de inicio del adelanto, que corresponde a Pagos.

```typescript
interface ConfirmarReservaCommand {
  readonly operacionId: string;
  readonly clienteId: string;
}
```

`confirmar-reserva.use-case.ts` coordina puertos, comprueba correspondencia de operación propia y aplica las condiciones locales mediante la entidad. La consulta de disponibilidad se realiza dentro de `preparar`; eso expresa el punto de integración requerido, **no implementa ni prueba PC-05**. Los resultados de salida son DTO ilustrativos, no estados persistidos ni códigos HTTP aprobados.

```typescript
class ConfirmarReservaUseCase {
  constructor(
    private readonly reservas: ReservaRepository,
    private readonly disponibilidad: DisponibilidadPort,
    private readonly adelantos: AdelantoSimuladoPort
  ) {}

  async execute(command: ConfirmarReservaCommand) {
    const contexto = await this.adelantos.consultar(
      command.operacionId, command.clienteId
    );
    if (!contexto) {
      return { confirmada: false as const, motivo: "Sin resultado consultable" };
    }
    if (contexto.operacionId !== command.operacionId ||
        contexto.clienteId !== command.clienteId) {
      throw new Error("Operación no autorizada o contexto inconsistente");
    }
    if (contexto.resultado !== "aprobado") {
      return {
        confirmada: false as const,
        motivo: "Adelanto simulado rechazado",
        resultadoAdelanto: contexto.resultado
      };
    }

    const reservaId = await this.reservas.confirmarSiCompatible(
      contexto.recurso, contexto.periodo,
      async () => {
        const disponible = await this.disponibilidad.verificarAlConfirmar(
          contexto.recurso, contexto.periodo
        );
        const datos: DatosReservaDirecta = {
          clienteId: contexto.clienteId,
          modalidad: contexto.modalidad,
          recurso: contexto.recurso,
          periodo: contexto.periodo,
          totalFijado: contexto.totalFijado,
          adelantoRequeridoFijado: contexto.adelantoFijado
        };
        return Reserva.confirmarDirecta(
          datos, contexto.operacionId, contexto.resultado, disponible
        );
      }
    );
    return {
      confirmada: true as const,
      reservaId,
      resultadoAdelanto: contexto.resultado
    };
  }
}
```

Validar reglas y coordinar infraestructura son responsabilidades distintas: la entidad exige aprobación y disponibilidad; el caso de uso solicita la evidencia mediante contratos y proyecta el contexto a datos locales; el adaptador debe preservar la consistencia global al persistir. La proyección usa una misma operación propia para selección, total, adelanto y referencia: no permite mezclar un resultado aprobado con importes de otra operación. No acredita por sí sola autenticidad del resultado, aplicación única ni atomicidad; esas obligaciones dependen de PC-05/PC-08 y del contrato colaborador. Un conflicto, evidencia insuficiente o fallo de persistencia no retorna éxito. El resultado del adelanto ya registrado sigue siendo independiente de la falta de confirmación (RF19/PC-07). La conversión de excepciones a respuestas y motivos uniformes queda pendiente; no se convierte una excepción técnica en pago rechazado. Reintentos, duplicados y aplicación única de un adelanto requieren PC-08, sin inventar idempotencia.

### 6.3 Infraestructura · adaptador

`reserva-repository.adapter.ts` es un **esqueleto intencionalmente no operativo**. No ejecuta una comprobación seguida de una escritura que aparente resolver carreras. Falta definir mapeo relacional, identificadores, persistencia de datos propios y evidencia mínima y garantía concurrente. El mapeo tendrá que conservar titular, modalidad, recurso/periodo, importes fijados y asociación del adelanto aprobado y aplicado, accesibles mediante `datosPropios` y `adelantoAplicado`; no persistirá por conveniencia todo `ContextoAdelanto`. La ubicación exacta de esos datos, el acceso auditable a los antecedentes de Pagos y la coordinación entre módulos no están decididos (PC-02/PC-08).

```typescript
class ReservaRepositoryAdapter implements ReservaRepository {
  async confirmarSiCompatible(
    _recurso: RecursoId,
    _periodo: PeriodoReserva,
    _preparar: () => Promise<Reserva>
  ): Promise<string> {
    throw new Error(
      "Pendiente PC-02/PC-05: persistencia y garantía de incompatibilidad"
    );
  }
}
```

Los adaptadores `disponibilidad-interna.adapter.ts` y `adelanto-simulado-interno.adapter.ts` muestran delegación a **API públicas internas propuestas**. Los nombres de estas API se usan solo como contratos de ejemplo; no existen implementaciones acreditadas. Reciben y devuelven un vocabulario de frontera acordable, sin acceder a tablas ajenas. En una implementación deberán validar y traducir sus DTO hacia los valores locales, según PC-04/PC-06/PC-08.

```typescript
// Formas locales de los contratos públicos de los módulos colaboradores.
// El ejemplo comparte valores de frontera por brevedad; no comparte entidades.
interface DisponibilidadApi {
  verificarSeleccion(
    recurso: RecursoId, periodo: PeriodoReserva
  ): Promise<boolean>;
}

interface PagosSimuladosApi {
  consultarOperacionPropia(
    operacionId: string, clienteId: string
  ): Promise<ContextoAdelanto | undefined>;
}

class DisponibilidadInternaAdapter implements DisponibilidadPort {
  constructor(private readonly api: DisponibilidadApi) {}

  verificarAlConfirmar(recurso: RecursoId, periodo: PeriodoReserva) {
    return this.api.verificarSeleccion(recurso, periodo);
  }
}

class AdelantoSimuladoInternoAdapter implements AdelantoSimuladoPort {
  constructor(private readonly api: PagosSimuladosApi) {}

  consultar(operacionId: string, clienteId: string) {
    return this.api.consultarOperacionPropia(operacionId, clienteId);
  }
}
```

El adaptador de Pagos **consulta**, no simula nuevamente ni cobra. Inicio, fijación de importes, invocación y registro del resultado de RF11/RF18 pertenecen al módulo Pagos, como muestra la sección 5. No hay pasarela financiera ni movimiento de fondos. PC-08 debe concretar fallos, correlación, duplicados y recuperación; estos fragmentos no los resuelven.

### 6.4 Presentación · controlador

`reserva.controller.ts` recibe una solicitud cuyo contexto de identidad fue autenticado por el mecanismo aún pendiente PC-11. Comprueba el rol Cliente para este recorrido directo y valida la forma del cuerpo. La titularidad se contrasta en Aplicación y en la consulta autorizada de Pagos. No obtiene identidad de un campo del cuerpo, no accede a persistencia ni decide disponibilidad o aprobación.

```typescript
interface SolicitudAutenticada {
  readonly identidad: { readonly id: string; readonly rol: string };
  readonly cuerpo: unknown;
}

class ReservaController {
  constructor(private readonly confirmarReserva: ConfirmarReservaUseCase) {}

  async confirmar(solicitud: SolicitudAutenticada) {
    if (solicitud.identidad.rol !== "Cliente") {
      throw new Error("Acceso no autorizado para este recorrido directo");
    }
    const cuerpo = solicitud.cuerpo;
    if (typeof cuerpo !== "object" || cuerpo === null ||
        !("operacionId" in cuerpo) ||
        typeof cuerpo.operacionId !== "string" ||
        !cuerpo.operacionId.trim()) {
      throw new Error("Referencia de operación requerida");
    }
    const command: ConfirmarReservaCommand = {
      operacionId: cuerpo.operacionId,
      clienteId: solicitud.identidad.id
    };
    return this.confirmarReserva.execute(command);
  }
}
```

Las etiquetas de rol son ilustrativas y no fijan una enumeración del sistema. La autenticación real, la matriz detallada de permisos y la traducción de errores a REST siguen pendientes. No se asignan rutas, verbos o códigos de respuesta como contratos aprobados. El controlador devuelve un resultado conceptual que el adaptador HTTP futuro serializará. Si el repositorio de ejemplo falla por PC-05, debe comunicarse falta de confirmación; nunca una respuesta de éxito.

### 6.5 Raíz de composición

`reservas.module.ts` propone la función de ensamblado, representada en UML como `ReservasModule` para identificar su responsabilidad, sin exigir una clase ni un contenedor de inyección. La aplicación principal del monolito entrega las API públicas de Disponibilidad y Pagos; el módulo construye sus adaptadores e inyecta los tres puertos en el caso de uso y este en el controlador.

```typescript
function componerReservas(
  disponibilidadApi: DisponibilidadApi,
  pagosApi: PagosSimuladosApi
) {
  const reservas: ReservaRepository = new ReservaRepositoryAdapter();
  const disponibilidad: DisponibilidadPort =
    new DisponibilidadInternaAdapter(disponibilidadApi);
  const adelantos: AdelantoSimuladoPort =
    new AdelantoSimuladoInternoAdapter(pagosApi);
  const confirmarReserva = new ConfirmarReservaUseCase(
    reservas, disponibilidad, adelantos
  );
  const controller = new ReservaController(confirmarReserva);
  return { controller };
}

// index.ts: frontera propuesta, sin exportar adaptadores ni entidad interna.
export { componerReservas };
export type { SolicitudAutenticada };
```

Sustituir el adaptador de persistencia por una implementación que satisfaga el mismo contrato solo cambia la composición; no modifica la entidad ni el caso de uso. Lo mismo aplica a la integración con Disponibilidad o Pagos. Esa sustitución no puede debilitar RN-13, reinterpretar importes fijados ni transformar pagos simulados en pagos reales. La composición actual devuelve un controlador cuyo repositorio falla expresamente hasta resolver PC-05; no constituye un módulo ejecutable terminado.

La siguiente matriz permite auditar el enlace entre necesidades y diseño sin crear relaciones de origen inexistentes.

| HU / RF y decisiones | Clases y contratos propuestos | Responsabilidad y límite |
|---|---|---|
| HU03/RF03; RF04 contextual con HU03; HU04/RF05; RF06 contextual con HU04 | `RecursoId`, `PeriodoReserva`, `DisponibilidadPort`, `Reserva`. | Unidad de selección y confirmación directa; falta precisar cobertura de reservar en HU03/HU04. |
| HU07/RF09; HU09/RF11; DF-04/DP-02/DP-03 | `ContextoAdelanto`, `AdelantoSimuladoPort`, `DatosReservaDirecta`, `AdelantoAplicado` y adaptador. | Consultar contexto y proyectar solo datos necesarios; conservar importes fijados y evidencia aprobada/aplicada. Configuración e inicio pertenecen a colaboradores. |
| HU09/RF18/RF19; RF12; RN-04/RN-13/RN-15 | `ConfirmarReservaUseCase`, `Reserva`, `ReservaRepository`, `DisponibilidadPort`. | Aprobación más disponibilidad y ausencia de incompatibles; PC-05 sin implementación. |
| HU05/HU08/RF07/RF10/RF12; DF-01–DF-03 | Futura extensión del caso de uso y contrato de aceptación de eventos. | Diferencia documentada, sin reutilizar el recorrido directo ni decidir iniciador PC-03. DF-02 pendiente de formalización en HU/RF. |
| HU10/HU14/RF14; HU14/RF20; DF-05/DP-04–DP-11 | Datos propios de Reserva, `AdelantoAplicado` y referencia de operación para futuros casos de consulta/registro de saldo. | Conservan total y adelanto aplicado auditables; recepción/corrección fuera de confirmación, sin cambiar Reserva ni adelanto. |
| ADR-002/ADR-005/ADR-006/ADR-007/ADR-008 | Controlador, puertos, adaptadores y composición. | Separación, API REST, integración interna y acceso propio; contratos técnicos pendientes. |

**Pendientes de auditoría:** aprobar o ajustar clases, firmas y frontera pública; resolver PC-01–PC-04 para eventos y modelo temporal/persistido; diseñar y verificar PC-05 antes de implementar confirmación; concretar PC-06/PC-08 para importes y resultados; conservar PC-07 para aprobación sin disponibilidad; mantener PC-09/PC-10 sin nuevos estados u operaciones; completar PC-11/PC-12 para permisos y trazabilidad. No se decide framework, motor, ORM concreto, mecanismo de bloqueo, endpoint ni estado persistido adicional.

**Auditoría correctiva OBS-01–OBS-04:** se conservan las seis secciones y sus subsecciones. Se sustituye la retención de todo el contexto por datos propios y evidencia mínima local; se descartan conservar solo una referencia sin importes auditables, copiar el modelo completo de Pagos y considerar un candidato como aplicación persistida. Se precisa la obligación de `confirmarSiCompatible` sin aprobar un mecanismo concurrente. Se refuerza la advertencia académica y se sincronizan árbol, responsabilidades, UML, secuencia, firmas y ejemplos. No se incorporan funcionalidades ni tecnologías aprobadas; RF13 y DF/DP/RN permanecen sin cambios.

**Verificación documental:** se contrastaron nombres de archivos, clases y puertos entre árbol, tablas, UML, secuencia y fragmentos; se revisaron los límites del recorrido directo y de eventos, el resultado rechazado/ausente y el adelanto aprobado sin disponibilidad. Se comprueban automáticamente los encabezados originales, tres Mermaid sin duplicación, once bloques TypeScript, diecisiete archivos conceptuales y ocho enlaces locales. Los fragmentos concatenados se someten a comprobación estática estricta sin emitir archivos con TypeScript 5.9.3, disponible como dependencia local de una herramienta; su uso para revisión no selecciona el lenguaje ni esa herramienta para UrbanPulse. El resultado de esa comprobación y de `git diff --check` se registra en la entrega. Se verifica también el archivo aún sin seguimiento contra archivo vacío y se comparan huellas de los demás archivos para confirmar el alcance. No se encontraron `mmdc`, `mermaid` ni `@mermaid-js/mermaid-cli` en PATH o las dependencias locales examinadas: se revisan los tres diagramas textualmente, pero no se declara validación mediante parser ni renderizado. Estas verificaciones no prueban comportamiento ejecutable ni concurrencia. La referencia Marketplace sigue sin estar disponible para cotejo directo.


