import '../../domain/task_filter.dart';

sealed class TasksEvent {
  const TasksEvent();
}

final class TaskAdded extends TasksEvent {
  const TaskAdded(this.title);

  final String title;
}

final class TaskToggled extends TasksEvent {
  const TaskToggled(this.id);

  final String id;
}

final class TaskFilterChanged extends TasksEvent {
  const TaskFilterChanged(this.filter);

  final TaskFilter filter;
}
