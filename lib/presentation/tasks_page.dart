import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/tasks_bloc.dart';
import 'bloc/tasks_event.dart';
import 'bloc/tasks_state.dart';
import 'widgets/add_task_dialog.dart';
import 'widgets/empty_tasks_message.dart';
import 'widgets/task_filter_bar.dart';
import 'widgets/task_tile.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  Future<void> _addTask(BuildContext context) async {
    final title = await showAddTaskDialog(context);
    if (title == null || !context.mounted) return;
    context.read<TasksBloc>().add(TaskAdded(title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aura')),
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
        label: const Text('Nueva tarea'),
      ),
    );
  }
}
