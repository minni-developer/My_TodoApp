import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final Function(String) onToggleDone;
  final Function(String) onDelete;

  const TodoList({
    super.key,
    required this.todos,
    required this.onToggleDone,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const Center(
        child: Text('No ToDos yet! Add some.'),
      );
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItem(
          todo: todo,
          onToggleDone: () => onToggleDone(todo.id),
          onDelete: () => onDelete(todo.id),
        );
      },
    );
  }
}