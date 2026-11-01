# Aura

Aura es una aplicación móvil en Flutter para gestionar tareas personales: anotar lo que hay que hacer, marcarlo al terminarlo y ver solo lo que interesa en cada momento.

## Funcionalidades

- **Lista de tareas:** al abrir la app aparecen unas tareas de ejemplo.
- **Agregar tareas:** se hace desde un diálogo.
  - Si el título está vacío o tiene solo espacios, muestra un error y no guarda la tarea.
  - El título se guarda sin los espacios sobrantes.
- **Completar tareas:** cada tarea se marca o desmarca con su casilla, y las completadas se ven tachadas.
- **Filtros:** Todas, Pendientes y Completadas, cada uno con su propio mensaje cuando no tiene tareas.
- **Tema:** claro u oscuro, según la configuración del sistema.

Las tareas se guardan en memoria, así que al cerrar la app se vuelve a los ejemplos iniciales.

## Instalación

### Requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) estable, versión 3.35 o superior. Incluye Dart 3.9.
- Para Android: Android Studio con el Android SDK y un emulador o un teléfono con la depuración USB activada.
- Para iOS: un Mac con Xcode y un simulador o un iPhone.

Para comprobar que todo está listo:

```bash
flutter doctor
```

### Pasos

1. Clona el repositorio y entra en la carpeta:

   ```bash
   git clone https://github.com/Francisperalta05/Aura.git
   ```

   ```bash
   cd Aura
   ```

2. Instala las dependencias:

   ```bash
   flutter pub get
   ```

3. Abre un emulador o conecta un dispositivo y ejecuta la app:

   ```bash
   flutter run
   ```

   Si hay varios dispositivos conectados, Flutter pregunta en cuál abrirla. También se puede indicar uno con `flutter run -d <dispositivo>`, usando un nombre de los que lista `flutter devices`.

### Generar un instalable para Android

```bash
flutter build apk --release
```

El archivo queda en `build/app/outputs/flutter-apk/app-release.apk`.

## Pruebas

```bash
flutter test
```

```bash
flutter analyze
```

- `test/tasks_bloc_test.dart` cubre la lógica:
  - El estado inicial.
  - Agregar una tarea con el título recortado.
  - Rechazar títulos vacíos o con solo espacios.
  - Marcar y desmarcar tareas.
  - Los filtros.
- `test/tasks_page_test.dart` cubre la interfaz:
  - Las tareas de ejemplo al abrir.
  - Agregar una tarea desde el diálogo.
  - El error del título.
  - Los filtros y sus mensajes de vacío.

## Arquitectura

El estado se maneja con **Bloc** (`flutter_bloc`), que es la única dependencia de la app. El código se organiza en tres capas, siguiendo una arquitectura limpia sencilla:

| Capa | Contenido |
|---|---|
| `domain/` | La entidad `Task`, el enum `TaskFilter` y el contrato `TaskRepository`. Es Dart puro, sin Flutter. |
| `data/` | `InMemoryTaskRepository`, que guarda las tareas en memoria e incluye los ejemplos iniciales. |
| `presentation/` | `TasksBloc` (eventos y estado), la pantalla principal y sus widgets. |

```
Widget ──evento──▶ TasksBloc ──llama──▶ TaskRepository (en memoria)
   ▲                   │
   └──── nuevo TasksState (BlocBuilder redibuja)
```

### Decisiones

- **El Bloc llama al repositorio directamente.** Cada operación es una sola llamada al repositorio, así que una clase de caso de uso por operación solo añadiría archivos.
- **Un único estado.** `TasksState` contiene las tareas y el filtro activo. La lista visible se calcula con un getter (`visibleTasks`), así que nunca se desincroniza del filtro.
- **Repositorio síncrono.** Con datos en memoria, `Future` y `await` solo añadirían ruido. Si se añadiera persistencia, el contrato `TaskRepository` es el único punto que cambiaría.
- **La validación del título vive en un solo lugar.** Está en `Task.isValidTitle` y se aplica dos veces: el formulario muestra el error y el Bloc descarta cualquier título no válido.
- **Las tareas nuevas aparecen al principio de la lista.** Si se agrega una con el filtro «Completadas» activo, la app cambia a «Todas» para que la tarea nueva se vea.

### Estructura

```
lib/
  main.dart                          crea el repositorio y arranca la app
  app.dart                           MaterialApp, tema y BlocProvider
  domain/
    task.dart                        entidad Task y validación del título
    task_filter.dart                 enum TaskFilter
    task_repository.dart             contrato del repositorio
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
      task_tile.dart                 una tarea con su casilla
      empty_tasks_message.dart       mensaje cuando el filtro no tiene tareas
      add_task_dialog.dart           formulario para agregar una tarea
test/
  tasks_bloc_test.dart
  tasks_page_test.dart
```

## Limitaciones

- Las tareas no se guardan entre sesiones.
- No se pueden editar ni borrar tareas.
- La interfaz está solo en español.
- Solo hay configuración para Android e iOS.
