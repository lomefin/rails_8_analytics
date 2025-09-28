# README


## Requirement

Tarea técnica: Dashboard de Analítica en Tiempo Real

[Video en Loom](https://www.loom.com/share/0ee430bb855a48889c598b8d26bd46a2?sid=cd521c05-a42c-499e-9fcb-1471785349b1)

[Link a aplicativo en vivo](https://maf.avispa.work/)

Screenshot del generador de métricas aleatorias
<img width="1327" height="676" alt="image" src="https://github.com/user-attachments/assets/6cd42a76-d5b7-46c3-b853-eb6f1751fb64" />
<img width="1327" height="676" alt="image" src="https://github.com/user-attachments/assets/105d18cc-5563-42c4-b1ed-6380b877beba" />



## Modelo de datos

Expandí el uso de solo `Metric` que representa una toma de información a `Sensor` que 
es el agrupador y pertenece a un `Company`, para hacer separación entre varios posibles Tenants.
`User` es parte de `Company` y tiene un nombre de usuario y contraseña, como también un `API_KEY` para acceder al endpoint de `API`.

Un ejemplo de prueba de la API es

`curl -s -H "X-API-KEY: 9b48a775-123b-4be8-b338-e0bd24e1dc0b" http://maf.avispa.work/api/metrics`

Los nombres de usuario y contraseña se encuentran en el archivo `seeds.rb`

## Elección de Framework

Elegí probar con Ruby on Rails 8 para apalancarme de las mejoras que ha traído, aunque
conlleva un riesgo de utilizar una herramienta nueva. Desestimé reciclar un proyecto anterior
para armar el proyecto por el inherente riesgo que exista un tema de configuración o librerías
que termine bloqueando el desarrollo.

Esta es la primera vez que uso la Solid trifecta, Solid Queues y Solid Cable, que hace que todo el procesamiento de eventos y tareas esté manejado por Rails y sobre SQLite, que le han
sacado increíble performance, al punto de dejarlo production ready (mientras se considere el respaldo de los datos)

Un tema interesante es el deploy con Kamal, que se hace de manera casi automática, compilando 
el container y luego subiéndolo de inmediato a DigitalOcean.

Hay un tema de configuración de dependencias que presenta problemas, esta vez usé importmap
y hay flujos que se hacen un poco más complejos porque cuesta determinar la localidad de las
librerías.

Para la implementación de los gráficos use ApexCharts, que tiene una configuración mucho más simple de uso, los otros frameworks van requiriendo más configuración explícita que es difícil
de analizar en desarrollo.

Para la implementación del generador aleatorio use un ActiveJob que trabaja con múltiples hebras y va haciendo espera para ir registrando nuevos trabajos. Este código se ejecuta por varios minutos y el scheduler de rails lo vuelve a levantar en una siguiente oportunidad. En el seed también se usa el generador, pero en vez de esperas, simula los próximos eventos y cambia la fecha de creación de los objetos. Tiene dos ritmos de trabajo que tienen distintas distribuciones respecto al próximo evento. El generador suele estar en modo lento, pero hay una chance que pase al modo rápido, en donde dispara múltiples eventos seguidos, también bajo una distribución normal. Eventualmente se hace nuevamente el cambio al modo lento.


Hice algunos tests con RSpec que es más simple de leer y generé comentarios sobre los métodos
para tener rdoc actualizado. Disponible en `/docs` 

Para tener el proyecto de manera local se debe

  - Descargar el repositorio
  - Tener rvm u otro gestor y tener Ruby 3.4 instalado
  - Ejecutar `bundle`
  - Tener node, y yarn para hacer `yarn`
  - Crear la base de datos `rails db:create`, `rails db:migrate` o `rails db:schema:load`
  - Generar el seed `rails db:seed`
  - Para ejecutar el servidor `bin/dev`
  - Para levantar la consola de rails `rails c`

### Objetivo general
Diseña, implementa y deployed un dashboard de analítica con submenú y gráficos en tiempo real, respaldado por una base de datos a la que un cron inyecta información periódicamente. Tienes libertad total de lenguaje, framework y base de datos, pero debes usar una librería de componentes UI para la interfaz y dejar el proyecto corriendo públicamente.

### Requisitos funcionales
  -[X] UI con submenú y secciones: Overview, Real-Time, Historical, Settings.
  -[X] Signin (Se puede usar un proveedor externo de autenticación)
  -[ ] Signup no fue realizado, es un flujo más largo y lo desprioricé para llegar a otras funcionalidades.
  -[X] Al menos 2 gráficos en tiempo real (línea y barras) con actualización push (WebSocket/SSE). 
  -[] El gráfico de barras no está en tiempo real, el proceso de update de los datos consolidados es un poco más intensivo para el desarrollo en este minuto.
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
