import 'package:aura/app.dart';
import 'package:aura/data/in_memory_task_repository.dart';
import 'package:aura/domain/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Abre la app con el dispositivo en [locale] (español, salvo que se indique).
Future<void> pumpApp(
  WidgetTester tester, {
  List<Task> tasks = const [],
  Locale locale = const Locale('es'),
}) async {
  tester.platformDispatcher.localesTestValue = [locale];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);

  await tester.pumpWidget(
    AuraApp(taskRepository: InMemoryTaskRepository(initialTasks: tasks)),
  );
}

void main() {
  testWidgets('arranca sin tareas y muestra el mensaje de vacío', (
    tester,
  ) async {
    await tester.pumpWidget(AuraApp(taskRepository: InMemoryTaskRepository()));

    expect(find.byType(Checkbox), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('usa inglés si el dispositivo está en inglés', (tester) async {
    await pumpApp(tester, locale: const Locale('en'));

    expect(find.text('All'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('New task'), findsOneWidget);
    expect(find.text('You have no tasks'), findsOneWidget);
  });

  testWidgets('usa inglés si el idioma no está soportado', (tester) async {
    await pumpApp(tester, locale: const Locale('fr'));

    expect(find.text('You have no tasks'), findsOneWidget);
  });

  testWidgets('agrega una tarea desde el diálogo', (tester) async {
    await pumpApp(tester);
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
    await pumpApp(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '   ');
    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();

    expect(find.text('Escribe un título para la tarea.'), findsOneWidget);
    expect(find.byType(Dialog), findsOneWidget);
  });

  testWidgets('edita una tarea desde su menú', (tester) async {
    await pumpApp(
      tester,
      tasks: const [Task(id: '1', title: 'Leer')],
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
    await pumpApp(
      tester,
      tasks: const [Task(id: '1', title: 'Leer')],
    );

    await tester.tap(find.byTooltip('Opciones de la tarea'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();

    expect(find.text('Se eliminó «Leer».'), findsOneWidget);
    expect(find.text('No tienes tareas'), findsOneWidget);
  });

  testWidgets('marca una tarea y la muestra en Completadas', (tester) async {
    await pumpApp(
      tester,
      tasks: const [Task(id: '1', title: 'Hacer ejercicio')],
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
