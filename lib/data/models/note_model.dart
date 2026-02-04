import 'package:hive/hive.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/note_priority.dart';
part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool isSynced;

  @HiveField(5)
  String createdBy;

  @HiveField(6)
  DateTime? updatedAt;

  @HiveField(7)
  bool isVisibleToAdmin;

  @HiveField(8)
  String priority;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
    required this.isSynced,
    required this.isVisibleToAdmin,
    required this.createdBy,
    required this.priority,
  });

  factory NoteModel.fromEntity(NoteEntity e) {
    return NoteModel(
      id: e.id,
      title: e.title,
      description: e.description,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
      isSynced: e.isSynced,
      isVisibleToAdmin: e.isVisibleToAdmin,
      createdBy: e.createdBy,
      priority: e.priority.name,
    );
  }

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
      isVisibleToAdmin: isVisibleToAdmin,
      createdBy: createdBy,
      priority: NotePriorityX.fromString(priority),
    );
  }
}
