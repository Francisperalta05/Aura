import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/task_filter.dart';
import '../../l10n/app_localizations.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../theme/aura_theme.dart';

/// Selector tipo pista: el filtro activo es una píldora que se levanta sobre
/// una pista tonal.
class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filter = context.select((TasksBloc bloc) => bloc.state.filter);

    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: const StadiumBorder(),
      ),
      child: Row(
        spacing: 4,
        children: [
          for (final option in TaskFilter.values)
            Expanded(
              child: _FilterSegment(
                label: option.label(l10n),
                isSelected: option == filter,
                onTap: () =>
                    context.read<TasksBloc>().add(TaskFilterChanged(option)),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterSegment extends StatelessWidget {
  const _FilterSegment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: ShapeDecoration(
          color: isSelected ? colors.surfaceContainerLowest : null,
          shape: const StadiumBorder(),
          shadows: isSelected ? AuraColors.segmentShadow : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: onTap,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? colors.onSurface
                        : colors.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on TaskFilter {
  String label(AppLocalizations l10n) => switch (this) {
    TaskFilter.all => l10n.filterAll,
    TaskFilter.pending => l10n.filterPending,
    TaskFilter.completed => l10n.filterCompleted,
  };
}
