import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_list.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> _todos = [];

  void _addTodo(Todo todo) {
    setState(() {
      _todos.add(todo);
    });
  }

  void _toggleTodoDone(String id) {
    setState(() {
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        _todos[index].isDone = !_todos[index].isDone;
      }
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });
  }

  Future<void> _navigateToAddTodo() async {
    final newTodo = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (context) => const AddTodoScreen()),
    );

    if (newTodo != null) {
      _addTodo(newTodo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
      ),
      body: TodoList(
        todos: _todos,
        onToggleDone: _toggleTodoDone,
        onDelete: _deleteTodo,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}