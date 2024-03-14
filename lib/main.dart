// import 'dart:js';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanban/models/kanban_model.dart';
import 'package:flutter_kanban/widgets/kanban.dart';
import 'package:provider/provider.dart';

void main() async {
  print("works");
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'kanbanf2.db'),
    onCreate: (db, version) async {
      // Run the CREATE TABLE statement on the database.
      print("works");

      print("Seeding db");
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

  runApp(ChangeNotifierProvider(
    create: (context) => KanbanModel(database),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanban board',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade800),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Kanban board'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedBoard = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Kanban(),
        ),
      ),
    );
  }
}
