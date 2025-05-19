// home_screen.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

enum Priority { high, medium, low }

class Todo {
  final String id;
  String title;
  bool completed;
  DateTime? dueDate;
  Priority priority;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
    this.dueDate,
    this.priority = Priority.medium,
  });
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uuid = const Uuid();
  final TextEditingController todoController = TextEditingController();
  final List<Todo> todos = [];

  DateTime? selectedDueDate;
  Priority selectedPriority = Priority.medium;
  final DateFormat dateFormatter = DateFormat.yMd();

  void addTodo() {
    final taskText = todoController.text.trim();
    if (taskText.isEmpty) return;

    setState(() {
      todos.add(Todo(
        id: uuid.v4(),
        title: taskText,
        dueDate: selectedDueDate,
        priority: selectedPriority,
      ));
      todoController.clear();
      selectedDueDate = null;
      selectedPriority = Priority.medium;
    });
  }

  void removeTodo(String id) {
    setState(() {
      todos.removeWhere((todo) => todo.id == id);
    });
  }

  void toggleCompletion(String id) {
    setState(() {
      final todo = todos.firstWhere((t) => t.id == id);
      todo.completed = !todo.completed;
    });
  }

  void editTodo(String id, String title, DateTime? dueDate, Priority priority) {
    setState(() {
      final todo = todos.firstWhere((t) => t.id == id);
      todo.title = title;
      todo.dueDate = dueDate;
      todo.priority = priority;
    });
  }

  Future<void> pickDueDate() async {
    DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 5),
    );

    if (picked != null) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }

  Widget buildPriorityDropdown(Priority current, void Function(Priority) onChanged) {
    return DropdownButton<Priority>(
      value: current,
      items: Priority.values.map((Priority value) {
        return DropdownMenuItem<Priority>(
          value: value,
          child: Text(value.name.toUpperCase()),
        );
      }).toList(),
      onChanged: (Priority? newValue) {
        if (newValue != null) onChanged(newValue);
      },
    );
  }

  Future<void> showEditDialog(Todo todo) async {
    final TextEditingController editController = TextEditingController(text: todo.title);
    DateTime? editDueDate = todo.dueDate;
    Priority editPriority = todo.priority;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: editController,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: 'Task Title'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Due Date: '),
                      TextButton(
                        onPressed: () async {
                          DateTime today = DateTime.now();
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: editDueDate ?? today,
                            firstDate: today,
                            lastDate: DateTime(today.year + 5),
                          );
                          if (picked != null) {
                            setState(() => editDueDate = picked);
                          }
                        },
                        child: Text(
                          editDueDate == null
                              ? 'Pick Date'
                              : dateFormatter.format(editDueDate!),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Priority: '),
                      buildPriorityDropdown(editPriority, (val) => setState(() => editPriority = val)),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (editController.text.trim().isNotEmpty) {
                    editTodo(todo.id, editController.text.trim(), editDueDate, editPriority);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
    editController.dispose();
  }

Color priorityColor(Priority priority) {
  switch (priority) {
    case Priority.high:
      return Colors.deepPurple.shade500; // Darker purple for high priority
    case Priority.medium:
      return Colors.deepPurple.shade300; // Medium purple
    case Priority.low:
      return Colors.deepPurple.shade100; // Light purple
  }
}


  bool isDueSoon(DateTime dueDate) => dueDate.difference(DateTime.now()).inDays <= 2 && dueDate.isAfter(DateTime.now());
  bool isPastDue(DateTime dueDate) => dueDate.isBefore(DateTime.now());

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;
    todos.sort((a, b) => (a.dueDate ?? DateTime(2100)).compareTo(b.dueDate ?? DateTime(2100)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('DailyWins'),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: isDarkMode,
                onChanged: (_) => widget.toggleTheme(),
                activeColor: Colors.white,
                inactiveThumbColor: Colors.white,
              ),
              const Icon(Icons.dark_mode),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: todoController,
                    decoration: InputDecoration(
                      hintText: 'Enter your task',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (_) => addTodo(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                TextButton.icon(
                  onPressed: pickDueDate,
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(selectedDueDate == null
                      ? 'Pick Due Date'
                      : dateFormatter.format(selectedDueDate!)),
                ),
                const SizedBox(width: 20),
                buildPriorityDropdown(selectedPriority, (val) => setState(() => selectedPriority = val)),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: todos.isEmpty
                  ? Center(
                      child: Text('No tasks added yet!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.deepPurple.shade700,
                          ),
                        ),
                    )
                  : ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        final dueDate = todo.dueDate;
                        final bool nearDue = dueDate != null && isDueSoon(dueDate);
                        final bool pastDue = dueDate != null && isPastDue(dueDate);

                        return Card(
                          color: priorityColor(todo.priority),
                          shape: (pastDue || nearDue)
                              ? RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: pastDue ? Colors.red : Colors.orange,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                )
                              : RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            leading: Checkbox(
                              value: todo.completed,
                              onChanged: (_) => toggleCompletion(todo.id),
                              fillColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
                            ),
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                decoration: todo.completed ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            subtitle: dueDate != null
                                ? Text(
                                    'Due: ${dateFormatter.format(dueDate)}',
                                    style: TextStyle(
                                      color: pastDue
                                          ? Colors.red.shade900
                                          : nearDue
                                              ? Colors.orange.shade800
                                              : null,
                                    ),
                                  )
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () => showEditDialog(todo),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red.shade700,
                                  onPressed: () => removeTodo(todo.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
