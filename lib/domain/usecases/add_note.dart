import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class AddNote {
  final NoteRepository repository;

  AddNote(this.repository);

  Future<void> call(NoteEntity note) {
    return repository.addNote(note);
  }
}
