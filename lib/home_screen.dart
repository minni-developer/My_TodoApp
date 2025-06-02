// home_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

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
  final DateFormat dateFormatter = DateFormat.yMd();

  DateTime? selectedDueDate;
  Priority selectedPriority = Priority.medium;

  int _selectedIndex = 0;
  Priority? selectedFilter; // null = show all

  void _onFilterChanged(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 1:
          selectedFilter = Priority.high;
          break;
        case 2:
          selectedFilter = Priority.medium;
          break;
        case 3:
          selectedFilter = Priority.low;
          break;
        default:
          selectedFilter = null;
      }
    });
  }

  void addTodo() {
    final taskText = todoController.text.trim();
    if (taskText.isEmpty) return;

    final todoBox = Hive.box<Todo>('todos');
    final newTodo = Todo(
      id: uuid.v4(),
      title: taskText,
      description: '',
      dueDate: selectedDueDate,
      priority: selectedPriority,
    );
    todoBox.add(newTodo);

    todoController.clear();
    selectedDueDate = null;
    selectedPriority = Priority.medium;
  }

  void toggleCompletion(Todo todo) {
    todo.isDone = !todo.isDone;
    todo.save();
  }

  void editTodo(Todo todo, String title, DateTime? dueDate, Priority priority) {
    todo.title = title;
    todo.dueDate = dueDate;
    todo.priority = priority;
    todo.save();
  }

  void removeTodo(Todo todo) {
    todo.delete();
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
      setState(() => selectedDueDate = picked);
    }
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editController,
                  decoration: const InputDecoration(hintText: 'Task Title'),
                ),
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
                        if (picked != null) setState(() => editDueDate = picked);
                      },
                      child: Text(editDueDate == null ? 'Pick Date' : dateFormatter.format(editDueDate!)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Priority: '),
                    DropdownButton<Priority>(
                      value: editPriority,
                      items: Priority.values.map((Priority value) {
                        return DropdownMenuItem<Priority>(
                          value: value,
                          child: Text(value.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (Priority? newValue) {
                        if (newValue != null) setState(() => editPriority = newValue);
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (editController.text.trim().isNotEmpty) {
                    editTodo(todo, editController.text.trim(), editDueDate, editPriority);
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
  }

  Color priorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.deepPurple.shade500;
      case Priority.medium:
        return Colors.deepPurple.shade300;
      case Priority.low:
        return Colors.deepPurple.shade100;
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
                DropdownButton<Priority>(
                  value: selectedPriority,
                  items: Priority.values.map((Priority value) {
                    return DropdownMenuItem<Priority>(
                      value: value,
                      child: Text(value.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (Priority? newValue) {
                    if (newValue != null) setState(() => selectedPriority = newValue);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Todo>('todos').listenable(),
                builder: (context, Box<Todo> box, _) {
                  if (box.values.isEmpty) {
                    return Center(child: Text("No tasks added yet!"));
                  }

                  final allTodos = box.values.toList();
                  final filteredTodos = selectedFilter == null
                      ? allTodos
                      : allTodos.where((todo) => todo.priority == selectedFilter).toList();

                  filteredTodos.sort((a, b) => (a.dueDate ?? DateTime(2100)).compareTo(b.dueDate ?? DateTime(2100)));

                  return ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
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
                            value: todo.isDone,
                            onChanged: (_) => toggleCompletion(todo),
                            fillColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.isDone ? TextDecoration.lineThrough : null,
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
                                color: Colors.white,
                                onPressed: () => showEditDialog(todo),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.white,
                                onPressed: () => removeTodo(todo),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onFilterChanged,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All'),
          BottomNavigationBarItem(icon: Icon(Icons.priority_high), label: 'High'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Medium'),
          BottomNavigationBarItem(icon: Icon(Icons.low_priority), label: 'Low'),
        ],
      ),
    );
  }
}
