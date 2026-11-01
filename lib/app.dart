import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/task_repository.dart';
import 'l10n/app_localizations.dart';
import 'presentation/bloc/tasks_bloc.dart';
import 'presentation/tasks_page.dart';

class AuraApp extends StatelessWidget {
  const AuraApp({super.key, required this.taskRepository});

  final TaskRepository taskRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasksBloc(taskRepository),
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo),
        darkTheme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.dark,
        ),
        home: const TasksPage(),
      ),
    );
  }
}
