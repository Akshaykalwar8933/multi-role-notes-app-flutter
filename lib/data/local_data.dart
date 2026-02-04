import 'package:hive/hive.dart';
import 'models/note_model.dart';

class NoteLocalDataSource {
  final Box<NoteModel> box;

  NoteLocalDataSource(this.box);

  Future<void> addNote(NoteModel note) async {
    await box.put(note.id, note);
  }

  Future<void> updateNote(NoteModel note) async {
    await box.put(note.id, note);
  }

  Future<void> deleteNote(String id) async {
    await box.delete(id);
  }

  List<NoteModel> getNotes() {
    return box.values.toList();
  }

  Future<void> markAllSynced() async {
    print("markAllSynced CALLED");

    for (var note in box.values) {
      print(
        "BEFORE SYNC -> id=${note.id}, "
        "isSynced=${note.isSynced}, "
        "isVisibleToAdmin=${note.isVisibleToAdmin}",
      );

      note.isSynced = true;
      note.isVisibleToAdmin = true;

      await note.save();

      print(
        "AFTER SYNC  -> id=${note.id}, "
        "isSynced=${note.isSynced}, "
        "isVisibleToAdmin=${note.isVisibleToAdmin}",
      );
    }

    print("markAllSynced END");
  }
}
