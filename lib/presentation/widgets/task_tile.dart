import 'package:flutter/material.dart';

import '../../domain/task.dart';
import '../../l10n/app_localizations.dart';

enum _TaskAction { edit, delete }

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return CheckboxListTile(
      value: task.isCompleted,
      onChanged: (_) => onToggle(),
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        task.title,
        style: task.isCompleted
            ? TextStyle(
                color: colors.onSurfaceVariant,
                decoration: TextDecoration.lineThrough,
              )
            : null,
      ),
      secondary: PopupMenuButton<_TaskAction>(
        tooltip: l10n.taskOptionsTooltip,
        onSelected: (action) => switch (action) {
          _TaskAction.edit => onEdit(),
          _TaskAction.delete => onDelete(),
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: _TaskAction.edit,
            child: ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.editAction),
            ),
          ),
          PopupMenuItem(
            value: _TaskAction.delete,
            child: ListTile(
              leading: Icon(Icons.delete_outline, color: colors.error),
              title: Text(
                l10n.deleteAction,
                style: TextStyle(color: colors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
