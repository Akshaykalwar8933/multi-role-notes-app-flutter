import 'package:flutter/material.dart';
import '../../domain/entities/note_priority.dart';

class NoteDialog extends StatefulWidget {
  final String title;
  final String? initialTitle;
  final String? initialDescription;
  final NotePriority? initialPriority;

  final void Function(
      String title,
      String description,
      NotePriority priority,
      ) onSubmit;

  const NoteDialog({
    super.key,
    required this.title,
    this.initialTitle,
    this.initialDescription,
    this.initialPriority,
    required this.onSubmit,
  });

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController titleCtrl;
  late final TextEditingController descCtrl;
  late NotePriority selectedPriority;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.initialTitle ?? "");
    descCtrl = TextEditingController(text: widget.initialDescription ?? "");
    selectedPriority = widget.initialPriority ?? NotePriority.moderate;
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: theme.cardColor,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Title
                Text(
                  widget.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                ///------- Note title-----
                TextFormField(
                  controller: titleCtrl,
                  decoration:
                  _inputDecoration(context, label: "Title"),
                  validator: (v) =>
                  v == null || v.trim().isEmpty
                      ? "Title is required"
                      : null,
                ),

                const SizedBox(height: 12),

                /// -------Description------
                TextFormField(
                  controller: descCtrl,
                  minLines: 2,
                  maxLines: 5,
                  decoration:
                  _inputDecoration(context, label: "Description"),
                  validator: (v) =>
                  v == null || v.trim().isEmpty
                      ? "Description is required"
                      : null,
                ),

                const SizedBox(height: 12),

                //  Priority
                DropdownButtonFormField<NotePriority>(
                  value: selectedPriority,
                  decoration:
                  _inputDecoration(context, label: "Priority"),
                  items: NotePriority.values.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(
                        p.label,
                        style: theme.textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedPriority = value);
                    }
                  },
                  validator: (v) =>
                  v == null ? "Please select priority" : null,
                ),

                const SizedBox(height: 22),

                /// ---------- Actions--------
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSubmit(
                            titleCtrl.text.trim(),
                            descCtrl.text.trim(),
                            selectedPriority,
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ------------INPUT DECORATION------------
  InputDecoration _inputDecoration(
      BuildContext context, {
        required String label,
      }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isDark
        ? Colors.grey.shade600
        : Colors.grey.shade400;

    return InputDecoration(
      labelText: label,
      labelStyle: theme.textTheme.bodyMedium,
      filled: true,
      fillColor: theme.cardColor,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: cs.primary,
          width: 1.4,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.error),
      ),
    );
  }
}
