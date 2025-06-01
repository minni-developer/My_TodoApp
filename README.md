# 📝 DailyWins - Hive-based Flutter To-Do App

DailyWins is a beautifully designed Flutter application that helps you manage your daily tasks with priority-based filtering, due date tracking, and a persistent storage system powered by Hive.

---

## 🚀 Features

* Add, edit, and delete tasks with due dates
* Set priority: High, Medium, or Low
* Mark tasks as completed
* Visual styling based on task urgency and priority
* Filter tasks via BottomNavigationBar
* Switch between light and dark themes
* Persistent data using Hive (No internet required)

---

## 📁 Project Structure

```
lib/
├── main.dart                   # App entry point and theme + Hive initialization
├── home_screen.dart            # UI logic and filtering, displays task list
├── models/
│   └── todo.dart               # Hive data model class with fields like title, dueDate, priority
│   └── todo.g.dart             # Generated Hive TypeAdapter (auto-created by build_runner)
├── screens/
│   └── add_todo_screen.dart    # UI screen for adding a new task manually
├── widgets/
│   ├── add_todo.dart           # (Unused or duplicate – can be cleaned)
│   ├── home_screen.dart        # (Duplicate reference – original is in lib/)
│   └── todo_item.dart          # (Can be used to style individual todo list items, optional)
```

---

## 📦 Dependencies

* flutter
* hive
* hive\_flutter
* uuid
* intl

---

## 🛠️ How to Set Up the Project

1. **Clone the repository**:

```bash
git clone https://github.com/your-username/dailywins-todo.git
cd dailywins-todo
```

2. **Install Flutter dependencies**:

```bash
flutter pub get
```

3. **Generate Hive TypeAdapter (if needed)**:

```bash
flutter packages pub run build_runner build
```

4. **Run the app**:

```bash
flutter run
```

5. **Build for release** (optional):

```bash
flutter build apk --release
```

---

## 🗃️ Hive Configuration

* Initializes Hive in `main.dart` using `Hive.initFlutter()`
* Registers the `TodoAdapter`
* Uses `Hive.box<Todo>('todos')` to read/write todos

---

## 🎨 Theme

* AppBar and UI elements are styled with a purple palette
* Bottom navigation bar filters tasks by priority
* Light/dark theme toggle available via AppBar

---

## 📌 Task Filtering

| Tab    | Filter               |
| ------ | -------------------- |
| All    | All tasks            |
| High   | Only High Priority   |
| Medium | Only Medium Priority |
| Low    | Only Low Priority    |

---

## 📸 Screenshots (Optional)

* Add screenshots or demo gifs to showcase the UI

---

## 🧑‍💻 Author

* Developed by **Manahil** with ❤️ using Flutter and Hive

Feel free to contribute, fork, or suggest improvements!
