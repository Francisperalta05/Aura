/// Una tarea personal.
class Task {
  const Task({required this.id, required this.title, this.isCompleted = false});

  final String id;
  final String title;
  final bool isCompleted;

  /// Un título es válido si tiene al menos un carácter que no sea espacio.
  static bool isValidTitle(String title) => title.trim().isNotEmpty;

  Task copyWith({String? title, bool? isCompleted}) {
    return Task(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Task &&
      other.id == id &&
      other.title == title &&
      other.isCompleted == isCompleted;

  @override
  int get hashCode => Object.hash(id, title, isCompleted);
}
