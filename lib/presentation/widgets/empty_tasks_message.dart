import 'package:flutter/material.dart';

import '../../domain/task_filter.dart';
import '../../l10n/app_localizations.dart';

/// Lo que se muestra cuando el filtro seleccionado no tiene tareas.
class EmptyTasksMessage extends StatelessWidget {
  const EmptyTasksMessage({super.key, required this.filter});

  final TaskFilter filter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final (icon, title, hint) = switch (filter) {
      TaskFilter.all => (
        Icons.inbox_outlined,
        l10n.emptyAllTitle,
        l10n.emptyAllHint,
      ),
      TaskFilter.pending => (
        Icons.celebration_outlined,
        l10n.emptyPendingTitle,
        l10n.emptyPendingHint,
      ),
      TaskFilter.completed => (
        Icons.task_alt,
        l10n.emptyCompletedTitle,
        l10n.emptyCompletedHint,
      ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              hint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
