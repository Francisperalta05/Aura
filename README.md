# Aura

Gestor de tareas en Flutter: aplicación sencilla para gestionar tareas personales, hecha como prueba práctica de Flutter.

> Estado: **funcionalidades completas**. Falta grabar el video de demostración y cerrar el tiempo dedicado.

## Funcionalidades

| Requisito | Estado |
|---|---|
| Lista de tareas con ejemplos definidos en el código | Hecho |
| Agregar una tarea con título (sin títulos vacíos ni solo espacios) | Hecho |
| Marcar tareas como completadas o pendientes | Hecho |
| Filtrar: Todas, Pendientes y Completadas | Hecho |
| Mensaje cuando no hay tareas en el filtro seleccionado | Hecho |
| Prueba automatizada (opcional) | Hecho: 10 pruebas |

## Cómo ejecutarlo

Requisitos: Flutter estable (probado con 3.35) y un emulador, simulador o dispositivo Android o iOS.

```bash
flutter pub get
flutter run
```

Pruebas y análisis estático:

```bash
flutter test
flutter analyze
```

## Decisiones de implementación

- **Manejo de estado con Bloc** (`flutter_bloc`). Es el único paquete de la app: no hay generadores de código ni inyección de dependencias, y las pruebas usan solo `flutter_test`.
- **Arquitectura limpia, en su versión mínima**, con tres capas:
  - `domain/`: la entidad `Task`, el enum `TaskFilter` y el contrato `TaskRepository`. Es Dart puro, sin Flutter.
  - `data/`: `InMemoryTaskRepository`, que guarda las tareas en memoria y trae los ejemplos iniciales.
  - `presentation/`: el `TasksBloc` (eventos y estado), la pantalla y sus widgets.
- **Sin casos de uso separados.** Cada operación es una sola llamada al repositorio, así que el Bloc lo usa directamente. Una clase por operación añadiría archivos sin aportar claridad.
- **Un solo estado** (`TasksState`, con las tareas y el filtro). No hay estados de carga ni de error porque no hay nada asíncrono que pueda fallar. La lista visible es un getter (`visibleTasks`), así que nunca se desincroniza del filtro.
- **Sin evento de carga inicial.** El Bloc toma las tareas del repositorio en su constructor; al ser datos en memoria no hace falta un evento para eso.
- **Repositorio síncrono.** Con datos en memoria, `Future` y `await` solo añadirían ruido. Si hubiera persistencia, el contrato es el único punto que cambiaría.
- **Validación del título en un solo lugar** (`Task.isValidTitle`) y aplicada dos veces: el formulario muestra el error al usuario y el Bloc ignora cualquier título vacío o con solo espacios. El título se guarda recortado.
- **Detalles de usabilidad:**
  - Las tareas nuevas aparecen al principio de la lista.
  - Si se agrega una tarea con el filtro «Completadas», se cambia a «Todas» para que la nueva tarea se vea.
  - Cada filtro tiene su propio mensaje de vacío.
  - Las tareas completadas se ven tachadas.
  - Hay tema claro y oscuro según el sistema.

## Estructura

```
lib/
  main.dart                          crea el repositorio y arranca la app
  app.dart                           MaterialApp, tema y BlocProvider
  domain/
    task.dart                        entidad Task y validación del título
    task_filter.dart                 enum TaskFilter
    task_repository.dart             contrato abstracto
  data/
    in_memory_task_repository.dart   implementación en memoria con los ejemplos
  presentation/
    bloc/
      tasks_bloc.dart
      tasks_event.dart
      tasks_state.dart
    tasks_page.dart                  pantalla principal
    widgets/
      task_filter_bar.dart           filtros Todas / Pendientes / Completadas
      task_tile.dart                 una tarea con su checkbox
      empty_tasks_message.dart       mensaje cuando el filtro no tiene tareas
      add_task_dialog.dart           formulario con validación del título
test/
  tasks_bloc_test.dart               lógica del Bloc
  tasks_page_test.dart               pantalla, diálogo y filtros
```

## Pruebas

- `tasks_bloc_test.dart` comprueba:
  - El estado inicial.
  - Que agrega una tarea con el título recortado.
  - Que rechaza títulos vacíos o con solo espacios.
  - Que marca y desmarca tareas.
  - Que cada filtro muestra solo sus tareas.
  - El cambio a «Todas» al agregar desde «Completadas».
- `tasks_page_test.dart` comprueba:
  - Que se ven los ejemplos al abrir.
  - Que se puede agregar una tarea desde el diálogo.
  - Que aparece el error al escribir solo espacios.
  - Que una tarea marcada pasa a «Completadas».
  - Los mensajes de vacío de los filtros.

## Tiempo dedicado

Inicio: 1 de noviembre de 2026. Límite: 2 horas, incluida la entrega.

_Se completará al terminar._

## Pendiente y limitaciones conocidas

- Los datos se pierden al cerrar la app, como permite el enunciado.
- No se pueden editar ni borrar tareas, porque el enunciado no lo pide.
- Los textos están solo en español y sin internacionalización.
- Solo se configuraron las plataformas Android e iOS.

## Uso de herramientas de IA

Usé Claude Code (Anthropic) como asistente para redactar este README, generar la estructura inicial y escribir parte del código y las pruebas. Revisé cada cambio y puedo explicar todo el código entregado.
