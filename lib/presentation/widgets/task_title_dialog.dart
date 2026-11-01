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

    return AlertDialog(
      title: Text(
        widget.isEditing ? l10n.editTaskDialogTitle : l10n.newTaskDialogTitle,
      ),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          controller: _titleController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: l10n.taskTitleLabel,
            hintText: l10n.taskTitleHint,
          ),
          validator: (value) =>
              Task.isValidTitle(value ?? '') ? null : l10n.taskTitleRequired,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelAction),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.isEditing ? l10n.saveAction : l10n.addAction),
        ),
      ],
    );
  }
}
