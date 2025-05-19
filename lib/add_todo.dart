import 'package:flutter/material.dart';

class AddTodoField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onAdd;

  const AddTodoField({super.key, required this.controller, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter a task...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        filled: true,
        fillColor: Colors.deepPurple.shade50,
      ),
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          onAdd(value.trim());
          controller.clear();
        }
      },
    );
  }
}
