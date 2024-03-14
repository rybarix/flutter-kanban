import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanban/models/kanban_model.dart';
import 'package:flutter_kanban/widgets/kanban.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'kanbanf2.db'),
    onCreate: (db, version) async {
      // Run the CREATE TABLE statement on the database.
      await db.rawQuery(
          'CREATE TABLE boards(id INTEGER PRIMARY KEY, title VARCHAR)');
      await db.rawQuery(
          'CREATE TABLE columns(id INTEGER PRIMARY KEY, title VARCHAR, board_id INTEGER, FOREIGN KEY(board_id) REFERENCES boards(id))');
      await db.rawQuery(
          'CREATE TABLE cards(id INTEGER PRIMARY KEY, title VARCHAR, body TEXT, column_id INTEGER, FOREIGN KEY(column_id) REFERENCES columns(id))');
      await db.rawInsert('INSERT INTO boards VALUES (1, "main_board")');
      await db.rawInsert(
          'INSERT INTO columns VALUES (1, "Todo", 1), (2, "In progress", 1), (3, "Done", 1)');
      await db.rawInsert(
          'INSERT INTO cards VALUES (1, "First task TODO", "Some description here and there...", 1), (2, "Second task TODO", "Some description here and there...", 1)');
    },
    version: 1,
  );

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    minimumSize: Size(800, 400),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(ChangeNotifierProvider(
    create: (context) => KanbanModel(database),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Kanban board',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade800),
        tooltipTheme: const TooltipThemeData(preferBelow: false),
        useMaterial3: true,
      ),
      home: const KanbanApp(title: 'Kanban board'),
    );
  }
}

class KanbanApp extends StatefulWidget {
  final String title;
  const KanbanApp({super.key, required this.title});

  @override
  State<KanbanApp> createState() => _KanbanAppState();
}

class _KanbanAppState extends State<KanbanApp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Kanban(),
      ),
    );
  }
}
