import 'package:flutter/material.dart';

import '../../domain/task_filter.dart';

/// Lo que se muestra cuando el filtro seleccionado no tiene tareas.
class EmptyTasksMessage extends StatelessWidget {
  const EmptyTasksMessage({super.key, required this.filter});

  final TaskFilter filter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, title, hint) = switch (filter) {
      TaskFilter.all => (
        Icons.inbox_outlined,
        'No tienes tareas',
        'Agrega una con el botón «Nueva tarea».',
      ),
      TaskFilter.pending => (
        Icons.celebration_outlined,
        'No tienes tareas pendientes',
        '¡Estás al día!',
      ),
      TaskFilter.completed => (
        Icons.task_alt,
        'Aún no has completado ninguna tarea',
        'Marca una tarea para verla aquí.',
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
