import 'package:flutter/material.dart';

import '../../domain/task.dart';
import '../../l10n/app_localizations.dart';
import '../theme/aura_theme.dart';

enum _TaskAction { edit, delete }

/// Tarjeta de una tarea: las pendientes flotan con una sombra suave y las
/// completadas se hunden en un tono más oscuro, tachadas.
class TaskTile extends StatefulWidget {
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
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  // Con el menú abierto, la tarjeta se resalta para saber a cuál afecta.
  bool _isMenuOpen = false;

  void _setMenuOpen(bool isOpen) {
    if (mounted) setState(() => _isMenuOpen = isOpen);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final task = widget.task;
    final radius = BorderRadius.circular(22);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: task.isCompleted
            ? colors.surfaceContainer
            : colors.surfaceContainerLowest,
        borderRadius: radius,
        border: Border.all(
          color: _isMenuOpen ? colors.primary : Colors.transparent,
          width: 2,
        ),
        boxShadow: task.isCompleted || _isMenuOpen
            ? null
            : AuraColors.cardShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: widget.onToggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 10, 4, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MergeSemantics(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // El diseño pide una casilla redonda de 26 px.
                        Transform.scale(
                          scale: 1.4,
                          child: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) => widget.onToggle(),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 12, 0, 12),
                            child: Text(
                              task.title,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: task.isCompleted
                                    ? FontWeight.w400
                                    : FontWeight.w500,
                                letterSpacing: -0.08,
                                color: task.isCompleted
                                    ? colors.onSurfaceVariant
                                    : colors.onSurface,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _TaskMenu(
                  onEdit: widget.onEdit,
                  onDelete: widget.onDelete,
                  onOpened: () => _setMenuOpen(true),
                  onClosed: () => _setMenuOpen(false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskMenu extends StatelessWidget {
  const _TaskMenu({
    required this.onEdit,
    required this.onDelete,
    required this.onOpened,
    required this.onClosed,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onOpened;
  final VoidCallback onClosed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return PopupMenuButton<_TaskAction>(
      tooltip: l10n.taskOptionsTooltip,
      icon: Icon(Icons.more_vert_rounded, color: colors.onSurfaceVariant),
      position: PopupMenuPosition.under,
      onOpened: onOpened,
      onCanceled: onClosed,
      onSelected: (action) {
        onClosed();
        switch (action) {
          case _TaskAction.edit:
            onEdit();
          case _TaskAction.delete:
            onDelete();
        }
      },
      itemBuilder: (context) => [
        _menuItem(
          value: _TaskAction.edit,
          icon: Icons.edit_outlined,
          label: l10n.editAction,
          iconColor: colors.onSurfaceVariant,
          textColor: colors.onSurface,
        ),
        _menuItem(
          value: _TaskAction.delete,
          icon: Icons.delete_outline_rounded,
          label: l10n.deleteAction,
          iconColor: colors.error,
          textColor: colors.error,
        ),
      ],
    );
  }

  PopupMenuItem<_TaskAction> _menuItem({
    required _TaskAction value,
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color textColor,
  }) {
    return PopupMenuItem(
      value: value,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        spacing: 12,
        children: [
          Icon(icon, size: 22, color: iconColor),
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
