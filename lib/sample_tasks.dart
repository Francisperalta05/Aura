import 'domain/task.dart';
import 'l10n/app_localizations.dart';

/// Tareas de ejemplo con las que arranca la app, en el idioma recibido.
List<Task> buildSampleTasks(AppLocalizations l10n) => [
  Task(id: 'sample-1', title: l10n.sampleTask1),
  Task(id: 'sample-2', title: l10n.sampleTask2),
  Task(id: 'sample-3', title: l10n.sampleTask3),
  Task(id: 'sample-4', title: l10n.sampleTask4, isCompleted: true),
];
