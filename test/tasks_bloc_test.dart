import 'package:aura/data/in_memory_task_repository.dart';
import 'package:aura/domain/task.dart';
import 'package:aura/domain/task_filter.dart';
import 'package:aura/presentation/bloc/tasks_bloc.dart';
import 'package:aura/presentation/bloc/tasks_event.dart';
import 'package:flutter_test/flutter_test.dart';

/// Deja que el Bloc procese los eventos pendientes.
Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  late TasksBloc bloc;

  setUp(() {
    bloc = TasksBloc(
      InMemoryTaskRepository(
        initialTasks: const [
          Task(id: 'a', title: 'Pendiente'),
          Task(id: 'b', title: 'Hecha', isCompleted: true),
        ],
      ),
    );
  });

  tearDown(() => bloc.close());

  test('empieza con las tareas del repositorio y el filtro Todas', () {
    expect(bloc.state.tasks.map((task) => task.id), ['a', 'b']);
    expect(bloc.state.filter, TaskFilter.all);
  });

  test('agrega una tarea con el título recortado, al principio', () async {
    bloc.add(const TaskAdded('  Comprar pan  '));
    await settle();

    expect(bloc.state.tasks.first.title, 'Comprar pan');
    expect(bloc.state.tasks.first.isCompleted, isFalse);
    expect(bloc.state.tasks, hasLength(3));
  });

  test('ignora títulos vacíos o con solo espacios', () async {
    bloc
      ..add(const TaskAdded(''))
      ..add(const TaskAdded('   '));
    await settle();

    expect(bloc.state.tasks, hasLength(2));
  });

  test('marca una tarea como completada y luego como pendiente', () async {
    bloc.add(const TaskToggled('a'));
    await settle();
    expect(bloc.state.tasks.first.isCompleted, isTrue);

    bloc.add(const TaskToggled('a'));
    await settle();
    expect(bloc.state.tasks.first.isCompleted, isFalse);
  });

  test('edita el título de una tarea, recortado', () async {
    bloc.add(const TaskTitleEdited('a', '  Renombrada  '));
    await settle();

    expect(bloc.state.tasks.first.title, 'Renombrada');
  });

  test('no cambia el título si el nuevo está en blanco', () async {
    bloc.add(const TaskTitleEdited('a', '   '));
    await settle();

    expect(bloc.state.tasks.first.title, 'Pendiente');
  });

  test('elimina una tarea', () async {
    bloc.add(const TaskDeleted('a'));
    await settle();

    expect(bloc.state.tasks.map((task) => task.id), ['b']);
  });

  test('cada filtro muestra solo sus tareas', () async {
    bloc.add(const TaskFilterChanged(TaskFilter.pending));
    await settle();
    expect(bloc.state.visibleTasks.map((task) => task.id), ['a']);

    bloc.add(const TaskFilterChanged(TaskFilter.completed));
    await settle();
    expect(bloc.state.visibleTasks.map((task) => task.id), ['b']);
  });

  test('al agregar desde Completadas vuelve a Todas', () async {
    bloc
      ..add(const TaskFilterChanged(TaskFilter.completed))
      ..add(const TaskAdded('Nueva'));
    await settle();

    expect(bloc.state.filter, TaskFilter.all);
    expect(bloc.state.visibleTasks.first.title, 'Nueva');
  });
}
