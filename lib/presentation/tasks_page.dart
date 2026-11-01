import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/task.dart';
import '../l10n/app_localizations.dart';
import 'bloc/tasks_bloc.dart';
import 'bloc/tasks_event.dart';
import 'bloc/tasks_state.dart';
import 'theme/aura_theme.dart';
import 'widgets/empty_tasks_message.dart';
import 'widgets/task_filter_bar.dart';
import 'widgets/task_tile.dart';
import 'widgets/task_title_dialog.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  Future<void> _addTask(BuildContext context) async {
    final title = await showTaskTitleDialog(context);
    if (title == null || !context.mounted) return;
    context.read<TasksBloc>().add(TaskAdded(title));
  }

  Future<void> _editTask(BuildContext context, Task task) async {
    final title = await showTaskTitleDialog(context, initialTitle: task.title);
    if (title == null || !context.mounted) return;
    context.read<TasksBloc>().add(TaskTitleEdited(task.id, title));
  }

  void _deleteTask(BuildContext context, Task task) {
    context.read<TasksBloc>().add(TaskDeleted(task.id));
    final message = AppLocalizations.of(context).taskDeletedMessage(task.title);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final background = Theme.of(context).colorScheme.surface;

    return Scaffold(
      appBar: AppBar(title: _AppTitle(l10n.appTitle)),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: TaskFilterBar(),
          ),
          Expanded(
            child: Stack(
              children: [
                BlocBuilder<TasksBloc, TasksState>(
                  builder: (context, state) {
                    final tasks = state.visibleTasks;
                    if (tasks.isEmpty) {
                      return EmptyTasksMessage(filter: state.filter);
                    }

                    return ListView.separated(
                      // Espacio para que el botón flotante no tape la última
                      // tarea.
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      itemCount: tasks.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskTile(
                          key: ValueKey(task.id),
                          task: task,
                          onToggle: () => context.read<TasksBloc>().add(
                            TaskToggled(task.id),
                          ),
                          onEdit: () => _editTask(context, task),
                          onDelete: () => _deleteTask(context, task),
                        );
                      },
                    );
                  },
                ),
                // Fundido inferior para que el botón flotante no se monte
                // sobre el texto de las tareas.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 110,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [background.withValues(alpha: 0), background],
                          stops: const [0, 0.55],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addTask(context),
        icon: const Icon(Icons.add_rounded, size: 24),
        label: Text(l10n.newTaskButton),
      ),
    );
  }
}

/// «Aura» en grande con el punto de acento de la marca.
class _AppTitle extends StatelessWidget {
  const _AppTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title),
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(left: 4, bottom: 9),
            decoration: const BoxDecoration(
              color: AuraColors.accent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
