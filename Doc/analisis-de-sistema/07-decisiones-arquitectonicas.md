# Decisiones Arquitectónicas

Las decisiones arquitectónicas definen las principales soluciones
adoptadas para responder a los drivers arquitectónicos identificados
en UrbanPulse.

| ID | Decisión arquitectónica | Driver relacionado | Justificación | Resultado |
|---|---|---|---|---|
| **ADR-001** | **Monolito modular** | **DA01 - Modalidades de reserva; DA03 - Extensibilidad** | Organizar las funcionalidades de UrbanPulse en módulos independientes dentro de una misma aplicación desplegable, evitando inicialmente la complejidad de múltiples servicios. | Módulos de Usuarios, Establecimientos, Recursos, Disponibilidad, Reservas, Solicitudes, Servicios y Pagos. |
| **ADR-002** | **Clean Architecture** | **DA03 - Extensibilidad; DA05 - Seguridad; DA06 - Integraciones externas** | Separar las reglas del negocio de los detalles tecnológicos y de los servicios externos. | Capas de Dominio, Aplicación, Infraestructura y Presentación. |
| **ADR-003** | **Separación de modalidades de reserva** | **DA01 - Modalidades de reserva; DA03 - Extensibilidad** | Las canchas, karaokes, salones y recreos poseen diferentes reglas para gestionar sus reservas, por lo que no deben depender de un único flujo rígido. | Reglas diferenciadas para cancha, karaoke, salón y recreo. |
| **ADR-004** | **Gestión centralizada de disponibilidad y reservas** | **DA02 - Consistencia** | Centralizar la verificación de disponibilidad antes de confirmar una reserva para evitar reservas incompatibles sobre un mismo recurso o fecha. | Control de disponibilidad integrado al proceso de confirmación de reservas. |
| **ADR-005** | **API REST** | **DA07 - Comunicación mediante API REST** | Separar la aplicación web de la lógica de negocio mediante una interfaz de comunicación definida. | API REST para usuarios, establecimientos, disponibilidad, reservas, solicitudes y pagos. |
| **ADR-006** | **Integración mediante interfaces y adaptadores** | **DA06 - Integraciones externas** | Desacoplar las reglas de UrbanPulse de proveedores externos como mapas, WhatsApp y el servicio de pago simulado. | Interfaces y adaptadores para servicios externos. |
| **ADR-007** | **Autenticación y autorización por roles** | **DA05 - Seguridad** | Diferenciar las operaciones permitidas para clientes, propietarios y administradores. | Control de acceso según rol del usuario. |
| **ADR-008** | **Persistencia mediante repositorios** | **DA08 - Persistencia** | Separar las reglas del negocio de la implementación concreta de la base de datos. | Interfaces de repositorio e implementaciones de persistencia. |
| **ADR-009** | **Optimización de consultas de disponibilidad** | **DA04 - Rendimiento** | Reducir consultas innecesarias y organizar el acceso a la información utilizada para determinar la disponibilidad. | Consultas optimizadas sobre establecimientos, recursos, fechas y horarios. |

---

## 1. Resumen de las decisiones

Las decisiones arquitectónicas más importantes para UrbanPulse son:

### ADR-001 — Monolito modular

UrbanPulse se desarrollará inicialmente como una única aplicación
desplegable, organizada internamente mediante módulos con
responsabilidades claramente definidas.

Esta decisión permite mantener una solución sencilla de desarrollar y
desplegar, evitando introducir inicialmente la complejidad de una
arquitectura distribuida.

---

### ADR-002 — Clean Architecture

Se utilizará Clean Architecture para separar las reglas principales
del negocio de los detalles tecnológicos.

La estructura inicial será:

```text
┌──────────────────────────────┐
│        PRESENTACIÓN          │
├──────────────────────────────┤
│         APLICACIÓN           │
├──────────────────────────────┤
│           DOMINIO            │
├──────────────────────────────┤
│       INFRAESTRUCTURA        │
└──────────────────────────────┘
```
--- 

### ADR-003 — Separación de modalidades de reserva

Las modalidades de reserva se manejarán según las características de\
cada establecimiento:

| Tipo de establecimiento | Modalidad                                   |
| ----------------------- | ------------------------------------------- |
| **Cancha de gras**      | Bloque horario                              |
| **Karaoke**             | Sala + tiempo                               |
| **Salón de eventos**    | Fecha + servicios + coordinación + adelanto |
| **Recreo**              | Fecha + servicios + coordinación + adelanto |

Esta decisión permite que las reglas particulares de cada modalidad no\
se mezclen innecesariamente.

---

### ADR-004 — Gestión centralizada de disponibilidad y reservas

La disponibilidad será verificada antes de confirmar una reserva.
```
Solicitud
    ↓
Consultar disponibilidad
    ↓
¿Disponible?
   ├── Sí → Confirmar
   └── No → Rechazar
```

Esta decisión responde directamente al problema de evitar reservas\
incompatibles.

---

### ADR-005 — API REST

La aplicación web se comunicará con el backend mediante una API REST.
```
Aplicación Web
      │
      ▼
   API REST
      │
      ▼
Lógica de negocio
      │
      ▼
Persistencia
```

---

### ADR-006 — Interfaces y adaptadores

Las integraciones externas se mantendrán separadas del núcleo de\
UrbanPulse.
```
              URBANPULSE
                   │
       ┌───────────┼───────────┐
       ▼           ▼           ▼
     Mapas      WhatsApp    Pago simulado
```

El proveedor de mapas todavía queda pendiente de decisión.

WhatsApp únicamente se utilizará para redirigir al cliente hacia el\
propietario.

El pago será simulado durante el MVP.

---

### ADR-007 — Autenticación y autorización por roles

Se diferenciarán los permisos de:

- Cliente.
- Propietario.
- Administrador.
```
Cliente
   ↓
Sus operaciones

Propietario
   ↓
Su establecimiento

Administrador
   ↓
Administración de la plataforma
```

---

### ADR-008 — Persistencia mediante repositorios

El acceso a los datos se realizará mediante abstracciones de\
repositorio.

Esto permitirá mantener las reglas del negocio independientes de la\
implementación específica de la base de datos.

---

### ADR-009 — Optimización de consultas de disponibilidad

Las consultas de disponibilidad serán diseñadas para acceder de forma\
eficiente a la información necesaria.

Se considerarán principalmente:

- Establecimiento.
- Recurso.
- Fecha.
- Horario.
- Estado de disponibilidad.

No se establece todavía una tecnología específica de caché.



