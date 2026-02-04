import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../local_data.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  NoteRepositoryImpl(this.localDataSource);

  @override
  Future<void> addNote(NoteEntity note) {
    return localDataSource.addNote(NoteModel.fromEntity(note));
  }

  @override
  Future<void> updateNote(NoteEntity note) {
    return localDataSource.updateNote(NoteModel.fromEntity(note));
  }

  @override
  Future<void> deleteNote(String id) {
    return localDataSource.deleteNote(id);
  }

  // @override
  // Future<List<NoteEntity>> getNotes() async {
  //   return localDataSource.getNotes().map((model) => model.toEntity()).toList();
  // }
  //
  // @override
  // Future<bool> syncNotes() async {
  //   print("SyncNotes  starting");
  //
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   final success = true;
  //   print("syncNotes is success=$success");
  //
  //   if (success) {
  //     await localDataSource.markAllSynced();
  //   }
  //   return success;
  // }

  @override
  Future<bool> syncNotes() async {
    try {
      print("===== SYNC START =====");
      await localDataSource.markAllSynced();
      print("===== SYNC SUCCESS =====");
      return true;
    } catch (e) {
      print("SYNC ERROR: $e");
      return false;
    }
  }

  @override
  Future<List<NoteEntity>> getNotes() async {
    return localDataSource.getNotes().map((e) => e.toEntity()).toList();
  }

}
