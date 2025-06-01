import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import '../models/todo.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final uuid = const Uuid();

  DateTime? _dueDate;
  Priority _priority = Priority.medium;

  Future<void> _pickDueDate() async {
    DateTime today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 5),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final newTodo = Todo(
        id: uuid.v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
      );

      final box = Hive.box<Todo>('todos');
      await box.add(newTodo);

      Navigator.of(context).pop(); // no need to return object
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add ToDo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(_dueDate == null
                    ? 'Pick Due Date'
                    : 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}'),
                onTap: _pickDueDate,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.priority_high),
                title: DropdownButtonFormField<Priority>(
                  value: _priority,
                  items: Priority.values.map((Priority value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (Priority? val) {
                    if (val != null) setState(() => _priority = val);
                  },
                  decoration: const InputDecoration(labelText: 'Priority'),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add ToDo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
