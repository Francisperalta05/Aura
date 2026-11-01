# Gestor de tareas (Flutter)

Aplicación sencilla para gestionar tareas personales, hecha como prueba práctica de Flutter.

> Estado: **en desarrollo**. Este README se actualiza a medida que avanza el trabajo.

## Funcionalidades

| Requisito | Estado |
|---|---|
| Lista de tareas con ejemplos definidos en el código | Pendiente |
| Agregar una tarea con título (sin títulos vacíos ni solo espacios) | Pendiente |
| Marcar tareas como completadas o pendientes | Pendiente |
| Filtrar: Todas, Pendientes y Completadas | Pendiente |
| Mensaje cuando no hay tareas en el filtro seleccionado | Pendiente |
| Prueba automatizada (opcional) | Pendiente |

## Cómo ejecutarlo

Requisitos: Flutter estable (probado con 3.35) y un emulador, simulador o dispositivo.

```bash
flutter pub get
flutter run
```

Pruebas:

```bash
flutter test
```

## Decisiones de implementación

- **Manejo de estado con Bloc** (`flutter_bloc`). Es el único paquete de la app: no se usan generadores de código ni inyección de dependencias.
- **Arquitectura limpia, en su versión mínima**, con tres capas:
  - `domain/`: la entidad `Task`, el enum `TaskFilter` y el contrato `TaskRepository`. Es Dart puro, sin Flutter.
  - `data/`: `InMemoryTaskRepository`, que guarda las tareas en memoria y trae los ejemplos iniciales.
  - `presentation/`: el `TasksBloc` (eventos y estado) y la pantalla con sus widgets.
- **Sin casos de uso separados.** Cada operación es una sola llamada al repositorio, así que el Bloc lo usa directamente. Una clase por operación añadiría archivos sin aportar claridad.
- **Datos en memoria.** Al reiniciar la app se vuelven a cargar los ejemplos, como pide el enunciado.
- **Validación del título** en dos lugares: el formulario muestra el error al usuario y el Bloc ignora cualquier título vacío o con solo espacios.

Estructura prevista:

```
lib/
  main.dart
  domain/
    task.dart
    task_filter.dart
    task_repository.dart
  data/
    in_memory_task_repository.dart
  presentation/
    bloc/
      tasks_bloc.dart
      tasks_event.dart
      tasks_state.dart
    tasks_page.dart
    widgets/
test/
```

## Tiempo dedicado

Inicio: 1 de noviembre de 2026. Límite: 2 horas, incluida la entrega.

_Se completará al terminar._

## Pendiente y limitaciones conocidas

_Se completará al terminar._

## Uso de herramientas de IA

Usé Claude Code (Anthropic) como asistente para redactar este README, generar la estructura inicial y escribir parte del código y las pruebas. Revisé cada cambio y puedo explicar todo el código entregado.
