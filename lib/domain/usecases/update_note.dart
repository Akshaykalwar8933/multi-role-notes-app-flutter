import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class UpdateNote {
  final NoteRepository repository;

  UpdateNote(this.repository);

  Future<void> call(NoteEntity note) {
    return repository.updateNote(note);
  }
}
