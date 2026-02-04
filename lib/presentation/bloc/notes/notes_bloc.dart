import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/note_entity.dart';
import '../../../domain/repositories/note_repository.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepository repository;

  NotesBloc(this.repository) : super(NotesInitial()) {
    on<LoadNotes>(_loadNotes);
    on<AddNoteEvent>(_addNote);
    on<UpdateNoteEvent>(_updateNote);
    on<DeleteNoteEvent>(_deleteNote);
    on<SyncNotesEvent>(_syncNotes);
    on<SearchNotesEvent>(_searchNotes);
  }

  // ================= SORT =================
  List<NoteEntity> _sortLatestFirst(List<NoteEntity> notes) {
    notes.sort((a, b) {
      final aTime = a.updatedAt ?? a.createdAt;
      final bTime = b.updatedAt ?? b.createdAt;
      return bTime.compareTo(aTime);
    });
    return notes;
  }

  // ================= LOAD =================
  Future<void> _loadNotes(
      LoadNotes event,
      Emitter<NotesState> emit,
      ) async {
    final notes = await repository.getNotes();
    emit(NotesLoaded(_sortLatestFirst(notes)));
  }

  // ================= ADD =================
  Future<void> _addNote(
      AddNoteEvent event,
      Emitter<NotesState> emit,
      ) async {
    final note = NoteEntity(
      id: const Uuid().v4(),
      title: event.title,
      description: event.description,
      priority: event.priority,
      createdAt: DateTime.now(),
      updatedAt: null,
      isSynced: false,
      isVisibleToAdmin: false,
      createdBy: "user",
    );

    await repository.addNote(note);
    final notes = await repository.getNotes();
    emit(NotesLoaded(_sortLatestFirst(notes)));
  }

  /// ================= UPDATE =================
  Future<void> _updateNote(
      UpdateNoteEvent event,
      Emitter<NotesState> emit,
      ) async {
    final old = (state as NotesLoaded)
        .notes
        .firstWhere((n) => n.id == event.id);

    final updated = NoteEntity(
      id: old.id,
      title: event.title,
      description: event.description,
      priority: event.priority,
      createdAt: old.createdAt,
      updatedAt: DateTime.now(),
      isSynced: false,
      isVisibleToAdmin: old.isVisibleToAdmin,
      createdBy: old.createdBy,
    );

    await repository.updateNote(updated);
    final notes = await repository.getNotes();
    emit(NotesLoaded(_sortLatestFirst(notes)));
  }

  /// ================= DELETE=================
  Future<void> _deleteNote(
      DeleteNoteEvent event,
      Emitter<NotesState> emit,
      ) async {
    await repository.deleteNote(event.id);
    final notes = await repository.getNotes();
    emit(NotesLoaded(_sortLatestFirst(notes)));
  }

  /// ================= SYNC =================
  Future<void> _syncNotes(
      SyncNotesEvent event,
      Emitter<NotesState> emit,
      ) async {
    if (state is! NotesLoaded) return;

    // show loader but do NOT trust filtered UI list
    emit(NotesLoaded(
      (state as NotesLoaded).notes,
      isSyncing: true,
    ));

    await Future.delayed(const Duration(seconds: 1));

    final success = await repository.syncNotes();
    final updatedNotes = await repository.getNotes();

    emit(NotesSyncStatus(success));
    emit(
      NotesLoaded(
        _sortLatestFirst(updatedNotes),
        isSyncing: false,
      ),
    );
  }

  /// Search notes by title, description, or priority
  Future<void> _searchNotes(
      SearchNotesEvent event,
      Emitter<NotesState> emit,
      ) async {
    final allNotes = await repository.getNotes();

    if (event.query.trim().isEmpty) {
      emit(NotesLoaded(_sortLatestFirst(allNotes)));
      return;
    }

    final q = event.query.toLowerCase();

    final filtered = allNotes.where((n) {
      return n.title.toLowerCase().contains(q) ||
          n.description.toLowerCase().contains(q) ||
          n.priority.name.toLowerCase().contains(q);
    }).toList();

    emit(NotesLoaded(_sortLatestFirst(filtered)));
  }
}
