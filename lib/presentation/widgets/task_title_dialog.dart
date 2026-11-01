import 'package:flutter/material.dart';

import '../../domain/task.dart';
import '../../l10n/app_localizations.dart';

/// Abre el diálogo para crear una tarea o, si recibe [initialTitle], para
/// editarla. Devuelve el título ya recortado, o `null` si se cancela.
Future<String?> showTaskTitleDialog(
  BuildContext context, {
  String? initialTitle,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => TaskTitleDialog(initialTitle: initialTitle),
  );
}

class TaskTitleDialog extends StatefulWidget {
  const TaskTitleDialog({super.key, this.initialTitle});

  final String? initialTitle;

  bool get isEditing => initialTitle != null;

  @override
  State<TaskTitleDialog> createState() => _TaskTitleDialogState();
}

class _TaskTitleDialogState extends State<TaskTitleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController(
    text: widget.initialTitle,
  );

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(_titleController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.isEditing
                    ? l10n.editTaskDialogTitle
                    : l10n.newTaskDialogTitle,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: l10n.taskTitleLabel,
                  hintText: l10n.taskTitleHint,
                ),
                validator: (value) => Task.isValidTitle(value ?? '')
                    ? null
                    : l10n.taskTitleRequired,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 24),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.surfaceContainerHigh,
                        foregroundColor: colors.onSurface,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.cancelAction),
                    ),
                  ),
                  Expanded(
                    child: FilledButton(
                      onPressed: _submit,
                      child: Text(
                        widget.isEditing ? l10n.saveAction : l10n.addAction,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
