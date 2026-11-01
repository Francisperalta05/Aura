import '../domain/task.dart';
import '../domain/task_repository.dart';

/// Guarda las tareas en memoria: se pierden al cerrar la app.
class InMemoryTaskRepository implements TaskRepository {
  InMemoryTaskRepository({List<Task> initialTasks = sampleTasks})
    : _tasks = List.of(initialTasks);

  /// Tareas de ejemplo con las que arranca la app.
  static const sampleTasks = [
    Task(id: 'sample-1', title: 'Preparar la presentación del lunes'),
    Task(id: 'sample-2', title: 'Comprar pan y leche'),
    Task(id: 'sample-3', title: 'Salir a caminar 30 minutos'),
    Task(
      id: 'sample-4',
      title: 'Pagar la factura de la luz',
      isCompleted: true,
    ),
  ];

  final List<Task> _tasks;

  // Prefijo distinto al de los ejemplos para que los ids nunca choquen.
  int _nextId = 1;

  @override
  List<Task> getTasks() => List.unmodifiable(_tasks);

  @override
  void addTask(String title) {
    // Las nuevas van primero para que se vean sin desplazarse.
    _tasks.insert(0, Task(id: 'task-${_nextId++}', title: title));
  }

  @override
  void toggleTask(String id) {
    _update(id, (task) => task.copyWith(isCompleted: !task.isCompleted));
  }

  @override
  void updateTaskTitle(String id, String title) {
    _update(id, (task) => task.copyWith(title: title));
  }

  @override
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  /// Reemplaza la tarea con ese id; si no existe, no hace nada.
  void _update(String id, Task Function(Task task) change) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;

    _tasks[index] = change(_tasks[index]);
  }
}
