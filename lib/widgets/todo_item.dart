import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggleDone,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(todo.description),
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (value) => onToggleDone(),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.grey),
        onPressed: onDelete,
      ),
    );
  }
}