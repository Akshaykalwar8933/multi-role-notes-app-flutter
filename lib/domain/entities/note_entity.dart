import 'note_priority.dart';

class NoteEntity {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final bool isVisibleToAdmin;
  final String createdBy;

  final NotePriority priority; // 🔥 IMPORTANT

  NoteEntity({
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

  NoteEntity copyWith({
    String? title,
    String? description,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isVisibleToAdmin,
    NotePriority? priority,
  }) {
    return NoteEntity(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isVisibleToAdmin: isVisibleToAdmin ?? this.isVisibleToAdmin,
      createdBy: createdBy,
      priority: priority ?? this.priority,
    );
  }
}
