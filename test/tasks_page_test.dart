import 'package:aura/app.dart';
import 'package:aura/data/in_memory_task_repository.dart';
import 'package:aura/domain/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildApp({List<Task> tasks = const []}) {
  return AuraApp(taskRepository: InMemoryTaskRepository(initialTasks: tasks));
}

void main() {
  testWidgets('muestra las tareas de ejemplo al abrir', (tester) async {
    await tester.pumpWidget(AuraApp(taskRepository: InMemoryTaskRepository()));

    for (final task in InMemoryTaskRepository.sampleTasks) {
      expect(find.text(task.title), findsOneWidget);
    }
  });

  testWidgets('agrega una tarea desde el diálogo', (tester) async {
    await tester.pumpWidget(buildApp());
    expect(find.text('No tienes tareas'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Llamar al dentista');
    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();

    expect(find.text('Llamar al dentista'), findsOneWidget);
    expect(find.text('No tienes tareas'), findsNothing);
  });

  testWidgets('no acepta un título con solo espacios', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '   ');
    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();

    expect(find.text('Escribe un título para la tarea.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('edita una tarea desde su menú', (tester) async {
    await tester.pumpWidget(
      buildApp(
        tasks: const [Task(id: '1', title: 'Leer')],
      ),
    );

    await tester.tap(find.byTooltip('Opciones de la tarea'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();

    expect(find.text('Editar tarea'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Leer un capítulo');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Leer un capítulo'), findsOneWidget);
    expect(find.text('Leer'), findsNothing);
  });

  testWidgets('elimina una tarea desde su menú', (tester) async {
    await tester.pumpWidget(
      buildApp(
        tasks: const [Task(id: '1', title: 'Leer')],
      ),
    );

    await tester.tap(find.byTooltip('Opciones de la tarea'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();

    expect(find.text('Se eliminó «Leer».'), findsOneWidget);
    expect(find.text('No tienes tareas'), findsOneWidget);
  });

  testWidgets('marca una tarea y la muestra en Completadas', (tester) async {
    await tester.pumpWidget(
      buildApp(
        tasks: const [Task(id: '1', title: 'Hacer ejercicio')],
      ),
    );

    await tester.tap(find.text('Completadas'));
    await tester.pumpAndSettle();
    expect(find.text('Aún no has completado ninguna tarea'), findsOneWidget);

    await tester.tap(find.text('Todas'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Completadas'));
    await tester.pumpAndSettle();
    expect(find.text('Hacer ejercicio'), findsOneWidget);

    await tester.tap(find.text('Pendientes'));
    await tester.pumpAndSettle();
    expect(find.text('No tienes tareas pendientes'), findsOneWidget);
  });
}
