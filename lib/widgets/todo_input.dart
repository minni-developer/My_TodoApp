import 'package:flutter/material.dart';

class TodoInput extends StatefulWidget {
  final Function(String) onSubmit;

  const TodoInput({super.key, required this.onSubmit});

  @override
  State<TodoInput> createState() => _TodoInputState();
}

class _TodoInputState extends State<TodoInput> {
  final _controller = TextEditingController();

  void _submitData() {
    final entered = _controller.text.trim();
    if (entered.isEmpty) return;

    widget.onSubmit(entered);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter a new task',
              prefixIcon: Icon(Icons.edit, color: Colors.deepPurple),
            ),
            onSubmitted: (_) => _submitData(),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _submitData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
