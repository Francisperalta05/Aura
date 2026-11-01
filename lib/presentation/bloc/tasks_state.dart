import 'package:flutter/foundation.dart';

import '../../domain/task.dart';
import '../../domain/task_filter.dart';

class TasksState {
  const TasksState({required this.tasks, this.filter = TaskFilter.all});

  final List<Task> tasks;
  final TaskFilter filter;

  /// Las tareas que deja pasar el filtro seleccionado.
  List<Task> get visibleTasks => tasks.where(filter.matches).toList();

  TasksState copyWith({List<Task>? tasks, TaskFilter? filter}) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TasksState &&
      listEquals(other.tasks, tasks) &&
      other.filter == filter;

  @override
  int get hashCode => Object.hash(Object.hashAll(tasks), filter);
}
