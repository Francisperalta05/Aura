import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/task_filter.dart';
import '../../l10n/app_localizations.dart';

/// Lo que se muestra cuando el filtro seleccionado no tiene tareas.
class EmptyTasksMessage extends StatelessWidget {
  const EmptyTasksMessage({super.key, required this.filter});

  final TaskFilter filter;

  // El contenedor del icono va girado y el icono se endereza.
  static const _tilt = -6 * math.pi / 180;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final (icon, title, hint) = switch (filter) {
      TaskFilter.all => (
        Icons.checklist_rounded,
        l10n.emptyAllTitle,
        l10n.emptyAllHint,
      ),
      TaskFilter.pending => (
        Icons.spa_outlined,
        l10n.emptyPendingTitle,
        l10n.emptyPendingHint,
      ),
      TaskFilter.completed => (
        Icons.task_alt_rounded,
        l10n.emptyCompletedTitle,
        l10n.emptyCompletedHint,
      ),
    };

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: _tilt,
              child: Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Transform.rotate(
                  angle: -_tilt,
                  child: Icon(icon, size: 52, color: colors.onPrimaryContainer),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                hint,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
