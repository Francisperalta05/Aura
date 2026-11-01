import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/task_filter.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final filter = context.select((TasksBloc bloc) => bloc.state.filter);

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<TaskFilter>(
        segments: [
          for (final option in TaskFilter.values)
            ButtonSegment(value: option, label: Text(option.label)),
        ],
        selected: {filter},
        showSelectedIcon: false,
        onSelectionChanged: (selection) {
          context.read<TasksBloc>().add(TaskFilterChanged(selection.first));
        },
      ),
    );
  }
}

extension on TaskFilter {
  String get label => switch (this) {
    TaskFilter.all => 'Todas',
    TaskFilter.pending => 'Pendientes',
    TaskFilter.completed => 'Completadas',
  };
}
