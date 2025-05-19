enum Priority { high, medium, low }

class Todo {
  final String id;
  String title;
  bool completed;
  DateTime? dueDate;     // nullable due date
  Priority priority;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
    this.dueDate,
    this.priority = Priority.medium,
  });
}
