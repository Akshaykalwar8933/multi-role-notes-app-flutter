import '../../../domain/entities/note_priority.dart';

abstract class NotesEvent {}

class LoadNotes extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final String title;
  final String description;
  final NotePriority priority;

  AddNoteEvent(this.title, this.description, this.priority);
}

class UpdateNoteEvent extends NotesEvent {
  final String id;
  final String title;
  final String description;
  final NotePriority priority;

  UpdateNoteEvent(
      this.id,
      this.title,
      this.description,
      this.priority,
      );
}

class DeleteNoteEvent extends NotesEvent {
  final String id;
  DeleteNoteEvent(this.id);
}

class SyncNotesEvent extends NotesEvent {}

class SearchNotesEvent extends NotesEvent {
  final String query;
  SearchNotesEvent(this.query);
}
