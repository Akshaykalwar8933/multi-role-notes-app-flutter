enum NotePriority {
  low,
  moderate,
  high,
}

extension NotePriorityX on NotePriority {
  String get label {
    switch (this) {
      case NotePriority.low:
        return "Low";
      case NotePriority.moderate:
        return "Moderate";
      case NotePriority.high:
        return "High";
    }
  }

  static NotePriority fromString(String value) {
    return NotePriority.values.firstWhere(
          (e) => e.name == value,
      orElse: () => NotePriority.moderate,
    );
  }
}
