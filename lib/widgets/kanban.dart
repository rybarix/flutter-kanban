import 'package:flutter/material.dart';
import 'package:flutter_kanban/kanban_card.dart';
import 'package:flutter_kanban/widgets/kanban_column.dart';

class Kanban extends StatefulWidget {
  const Kanban({super.key});

  @override
  State<StatefulWidget> createState() {
    return _KanbanState();
  }
}

class _KanbanState extends State<Kanban> {
  // TODO: persist in sqlite db.
  List<KanbanCard> cards = [
    KanbanCard("Hello", "WORLD", "todo"),
  ];

  // TODO: hook this to the + button in canban onNew()
  void _addCard(String title, String body, String column) {
    cards.add(KanbanCard(title, body, column));
  }

  List<KanbanCard> fromColumn(String column) {
    return cards.where((element) => element.column == column).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
          children: <Widget>[
            Expanded(child: KanbanColum(title: "TODO", things: fromColumn("todo"), onNew: () => {},)),
            Expanded(child: KanbanColum(title: "In progress", things: fromColumn("in_progress"), onNew: () => {})),
            Expanded(child: KanbanColum(title: "Done", things: fromColumn("done"), onNew: () => {})),
          ],
        ),
      );
  }

}