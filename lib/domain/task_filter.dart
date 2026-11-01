import 'task.dart';

/// Qué tareas se muestran en la lista.
enum TaskFilter {
  all,
  pending,
  completed;

  bool matches(Task task) => switch (this) {
    TaskFilter.all => true,
    TaskFilter.pending => !task.isCompleted,
    TaskFilter.completed => task.isCompleted,
  };
}
