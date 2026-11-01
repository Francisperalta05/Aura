import 'task.dart';

/// Contrato para guardar y consultar tareas.
///
/// Es síncrono porque los datos viven en memoria. Si se añadiera
/// persistencia, este sería el único contrato que habría que cambiar.
abstract interface class TaskRepository {
  List<Task> getTasks();

  void addTask(String title);

  /// Cambia la tarea entre completada y pendiente.
  void toggleTask(String id);
}
