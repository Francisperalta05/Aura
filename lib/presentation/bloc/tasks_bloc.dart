import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/task.dart';
import '../../domain/task_filter.dart';
import '../../domain/task_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc(TaskRepository repository)
    : _repository = repository,
      super(TasksState(tasks: repository.getTasks())) {
    on<TaskAdded>(_onTaskAdded);
    on<TaskToggled>(_onTaskToggled);
    on<TaskFilterChanged>(_onFilterChanged);
  }

  final TaskRepository _repository;

  void _onTaskAdded(TaskAdded event, Emitter<TasksState> emit) {
    // El formulario ya valida, pero el Bloc no confía en quien lo llama.
    if (!Task.isValidTitle(event.title)) return;

    _repository.addTask(event.title.trim());
    emit(
      state.copyWith(
        tasks: _repository.getTasks(),
        // Una tarea nueva está pendiente: en "Completadas" no se vería.
        filter: state.filter == TaskFilter.completed
            ? TaskFilter.all
            : state.filter,
      ),
    );
  }

  void _onTaskToggled(TaskToggled event, Emitter<TasksState> emit) {
    _repository.toggleTask(event.id);
    emit(state.copyWith(tasks: _repository.getTasks()));
  }

  void _onFilterChanged(TaskFilterChanged event, Emitter<TasksState> emit) {
    emit(state.copyWith(filter: event.filter));
  }
}
