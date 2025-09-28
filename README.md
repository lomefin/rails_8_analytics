# README


## Requirement

Tarea técnica: Dashboard de Analítica en Tiempo Real

[Video en Loom](https://www.loom.com/share/0ee430bb855a48889c598b8d26bd46a2?sid=cd521c05-a42c-499e-9fcb-1471785349b1)

[Link a aplicativo en vivo](https://maf.avispa.work/)

## Modelo de datos

Se expandió el uso de solo `Metric` que representa una toma de información a `Sensor` que 
es el agrupador y pertenece a un `Company`, para hacer separación entre varios posibles Tenants.
`User` es parte de `Company` y tiene un nombre de usuario y contraseña, como también un `API_KEY` para acceder al endpoint de `API`.

Un ejemplo de prueba de la API es

`curl -s -H "X-API-KEY: 9b48a775-123b-4be8-b338-e0bd24e1dc0b" http://maf.avispa.work/api/metrics`

Los nombres de usuario y contraseña se encuentran en el archivo `seeds.rb`



### Objetivo general
Diseña, implementa y deployed un dashboard de analítica con submenú y gráficos en tiempo real, respaldado por una base de datos a la que un cron inyecta información periódicamente. Tienes libertad total de lenguaje, framework y base de datos, pero debes usar una librería de componentes UI para la interfaz y dejar el proyecto corriendo públicamente.

### Requisitos funcionales
  -[X] UI con submenú y secciones: Overview, Real-Time, Historical, Settings.
  -[X] Signin y Signup (Se puede usar un proveedor externo de autenticación)
  -[] Al menos 2 gráficos en tiempo real (línea y barras) con actualización push (WebSocket/SSE).
  -[X] Modelo de datos con tabla 'metrics' (id, source, metric, value, ts UTC).
  -[X] Proceso cron que inserta datos sintéticos cada 5–15s con posibilidad de picos.
  -[X] Endpoints REST para histórico 
  -[X] Endpoint  stream en tiempo real (SSE/WS).
  -[X] Filtros métricas y fuentes.
  -[] Filtros por rango de fechas,
  -[X] Deploy en entorno público con cron activo.
  -[X] Calidad de código: linter, manejo de errores, pruebas mínimas.

### Entregables

Repositorio público con código fuente y README detallado. URL pública del dashboard y del stream.
Capturas o GIF mostrando el dashboard en acción. Justificación técnica breve en README.

### Criterios de evaluación

• Funcionalidad en tiempo real
• Diseño y UX
• Modelo y APIs
• Ingesta/cron en producción
• Calidad de código
• Pruebas mínimas
• Documentación y deploy

### Reglas y lineamientos
Timestamps en UTC, conversión en UI.
Seguridad: variables de entorno, sin credenciales expuestas. Performance: manejar picos de datos con batching/back-pressure. Datos sintéticos deben mostrar variaciones (ruido, picos).

### Plazo sugerido

Tiempo estimado: 1–3 días de trabajo efectivo.
