import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';

import 'app.dart';
import 'data/in_memory_task_repository.dart';
import 'l10n/app_localizations.dart';
import 'sample_tasks.dart';

void main() {
  // Los ejemplos se crean una vez, en el idioma que también elegirá MaterialApp.
  final locale = basicLocaleListResolution(
    PlatformDispatcher.instance.locales,
    AppLocalizations.supportedLocales,
  );
  final sampleTasks = buildSampleTasks(lookupAppLocalizations(locale));

  runApp(
    AuraApp(taskRepository: InMemoryTaskRepository(initialTasks: sampleTasks)),
  );
}
