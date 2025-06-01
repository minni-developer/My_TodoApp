import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
enum Priority {
  @HiveField(0)
  high,
  @HiveField(1)
  medium,
  @HiveField(2)
  low,
}

@HiveType(typeId: 1)
class Todo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  bool isDone;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  Priority priority;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    this.dueDate,
    this.priority = Priority.medium,
  });
} 
