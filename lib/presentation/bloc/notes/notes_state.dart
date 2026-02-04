import '../../../domain/entities/note_entity.dart';

abstract class NotesState {}

class NotesInitial extends NotesState {}

class NotesLoaded extends NotesState {
  final List<NoteEntity> notes;
  final bool isSyncing;

  NotesLoaded(this.notes, {this.isSyncing = false});
}

class NotesSyncStatus extends NotesState {
  final bool success;
  NotesSyncStatus(this.success);
}
