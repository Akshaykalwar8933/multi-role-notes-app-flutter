import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/entities/note_priority.dart';
import '../../utils/widgets/note_dialog.dart';
import '../../utils/widgets/snackbar_utils.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/notes/notes_bloc.dart';
import '../bloc/notes/notes_event.dart';
import '../bloc/notes/notes_state.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart';

class NotesScreen extends StatelessWidget {
  final bool isAdmin;
  const NotesScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return BlocListener<NotesBloc, NotesState>(
      listener: (context, state) {
        if (state is NotesSyncStatus) {
          SnackbarUtil.show(
            context,
            message: state.success ? "Sync successful" : "Sync failed",
            success: state.success,
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            isAdmin ? "Admin Dashboard" : "User Dashboard",
            style: theme.textTheme.titleMedium,
          ),
          actions: [

            if (!isAdmin)
              BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                final syncing = state is NotesLoaded && state.isSyncing;
                return IconButton(
                  icon: const Icon(Icons.sync),
                  onPressed: syncing
                      ? null
                      : () => context.read<NotesBloc>().add(SyncNotesEvent()),
                );
              },
            ),

            // 🌗 Theme toggle
            IconButton(
              icon: Icon(
                context.watch<ThemeBloc>().state.isDark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () =>
                  context.read<ThemeBloc>().add(ToggleThemeEvent()),
            ),

            // 🚪 Logout
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _showLogoutBottomSheet(context),
            ),
          ],
        ),

        floatingActionButton:
        BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (isAdmin) return const SizedBox();
            if (state is NotesLoaded && state.isSyncing) {
              return const SizedBox();
            }
            return FloatingActionButton(
              backgroundColor: cs.primary,
              child: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => NoteDialog(
                    title: "Add Note",
                    onSubmit: (t, d, p) {
                      context
                          .read<NotesBloc>()
                          .add(AddNoteEvent(t, d, p));
                    },
                  ),
                );
              },
            );
          },
        ),

        body: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (state is! NotesLoaded) {
              return const SizedBox();
            }

            if (state.isSyncing) {
              return const Center(child: CircularProgressIndicator());
            }

            final notes = isAdmin
                ? state.notes.where((n) => n.isVisibleToAdmin).toList()
                : state.notes.where((n) => n.createdBy == "user").toList();

            return Column(
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: TextField(
                    onChanged: (v) =>
                        context.read<NotesBloc>().add(SearchNotesEvent(v)),
                    decoration: InputDecoration(
                      hintText: "Search notes...",
                      filled: true,
                      fillColor: theme.brightness == Brightness.dark
                          ? Colors.grey.shade800.withOpacity(0.4)
                          : Colors.grey.shade50,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: cs.primary,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),


                Expanded(
                  child: notes.isEmpty
                      ? Center(
                    child: Text(
                      "No notes found",
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                      : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (_, i) =>
                        _noteCard(context, notes[i]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Card Widget for each note
  Widget _noteCard(BuildContext context, NoteEntity note) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 0,
      color: isDark
          ? Colors.grey.shade900.withOpacity(0.55)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark
              ? Colors.grey.shade700.withOpacity(0.6)
              : Colors.grey.shade300,
        ),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          childrenPadding:
          const EdgeInsets.fromLTRB(14, 0, 14, 14),

          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sync dot
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Icon(
                  Icons.circle,
                  size: 10,
                  color: note.isSynced ? Colors.green : cs.error,
                ),
              ),
              const SizedBox(width: 10),

              // ===== TEXT =====
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _priorityBadge(note.priority),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatNoteTime(note),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              /// Edit Option
              if (!isAdmin)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.edit, color: cs.primary),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => NoteDialog(
                        title: "Edit Note",
                        initialTitle: note.title,
                        initialDescription: note.description,
                        initialPriority: note.priority,
                        onSubmit: (t, d, p) {
                          context.read<NotesBloc>().add(
                            UpdateNoteEvent(note.id, t, d, p),
                          );
                        },
                      ),
                    );
                  },
                ),

              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.delete, color: cs.error),
                onPressed: () =>
                    _showDeleteBottomSheet(context, note.id),
              ),
            ],
          ),

          /// DESCRIPTION
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                note.description,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// PRIORITY BADGE
  Widget _priorityBadge(NotePriority p) {
    final color = _priorityColor(p);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        p.name.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _priorityColor(NotePriority p) {
    switch (p) {
      case NotePriority.high:
        return Colors.red;
      case NotePriority.moderate:
        return Colors.orange;
      case NotePriority.low:
        return Colors.green;
    }
  }

  /// -------- BOTTOM SHEETS --------
  static void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _confirmSheet(
        context,
        icon: Icons.logout,
        title: "Logout",
        message: "Are you sure you want to logout?",
        action: "Logout",
        onConfirm: () =>
            context.read<AuthBloc>().add(LogoutEvent()),
      ),
    );
  }

  static void _showDeleteBottomSheet(
      BuildContext context, String id) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _confirmSheet(
        context,
        icon: Icons.delete_forever,
        title: "Delete Note",
        message:
        "Are you sure you want to delete this note?\n\nID:\n$id",
        action: "Delete",
        onConfirm: () =>
            context.read<NotesBloc>().add(DeleteNoteEvent(id)),
      ),
    );
  }

  static Widget _confirmSheet(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String message,
        required String action,
        required VoidCallback onConfirm,
      }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36, color: cs.error),
          const SizedBox(height: 12),
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.error,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: Text(
                    action,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// -------- TIME -------
  static String _formatNoteTime(NoteEntity note) {
    if (note.updatedAt == null) {
      return "Created ${_fmt(note.createdAt)}";
    }
    final diff = DateTime.now().difference(note.updatedAt!);
    if (diff.inMinutes < 1) return "Edited just now";
    if (diff.inMinutes < 60) {
      return "Edited ${diff.inMinutes} minutes ago";
    }
    if (diff.inHours < 24) {
      return "Edited ${diff.inHours} hours ago";
    }
    return "Edited on ${_fmt(note.updatedAt!)}";
  }

  static String _fmt(DateTime d) {
    return "${d.day}/${d.month}/${d.year} "
        "${d.hour}:${d.minute.toString().padLeft(2, '0')}";
  }
}
