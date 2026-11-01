import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/task.dart';
import '../l10n/app_localizations.dart';
import 'bloc/tasks_bloc.dart';
import 'bloc/tasks_event.dart';
import 'bloc/tasks_state.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TaskFilterBar(),
          ),
          Expanded(
            child: BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                final tasks = state.visibleTasks;
                if (tasks.isEmpty) {
                  return EmptyTasksMessage(filter: state.filter);
                }

                return ListView.builder(
                  // Espacio para que el botón flotante no tape la última tarea.
                  padding: const EdgeInsets.only(bottom: 88),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(
                      key: ValueKey(task.id),
                      task: task,
                      onToggle: () =>
                          context.read<TasksBloc>().add(TaskToggled(task.id)),
                      onEdit: () => _editTask(context, task),
                      onDelete: () => _deleteTask(context, task),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addTask(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.newTaskButton),
      ),
    );
  }
}
