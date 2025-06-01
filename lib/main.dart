import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/todo.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PriorityAdapter());
  Hive.registerAdapter(TodoAdapter());

  await Hive.openBox<Todo>('todos');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive ToDo',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
theme: ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.deepPurple.shade300,
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'Roboto',
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.deepPurple.shade300,
    foregroundColor: Colors.white,
    elevation: 2,
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.purple.shade300,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white70, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      elevation: 8,
      shadowColor: Colors.black54,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurple.shade300,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  iconTheme: const IconThemeData(color: Colors.deepPurple),
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  ),
),
darkTheme: ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.black,
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurpleAccent,
    foregroundColor: Colors.white,
    elevation: 2,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurpleAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurpleAccent,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  ),
),

      home: HomeScreen(toggleTheme: toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),
    );
  }
}
