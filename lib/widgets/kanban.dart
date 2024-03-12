import 'package:flutter/material.dart';
import 'package:flutter_kanban/kanban_card.dart';
import 'package:flutter_kanban/models/kanban_model.dart';
import 'package:flutter_kanban/widgets/kanban_column.dart';
import 'package:provider/provider.dart';

class Kanban extends StatelessWidget {
  Kanban({super.key});

  // TODO: persist in sqlite db.
  // List<KanbanCard> cards = [
  //   KanbanCard(1, "Hello", "WORLD", "todo"),
  // ];

  // List<KanbanCard> fromColumn(String column) {
  //   Provider.of<KanbanModel>(context, listen: false).
  //   return cards.where((element) => element.column == column).toList();
  // }

  void _onNew() {
    // Provider.of<KanbanModel>(context, listen: false).add(KanbanCard());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<KanbanModel>(
        builder: (context, model, child) {
          return Row(
            children: <Widget>[
              Expanded(
                  child: KanbanColum(
                title: "TODO",
                things: model.fromColumn("todo"),
                onNew: () => {},
              )),
              Expanded(
                  child: KanbanColum(
                      title: "In progress",
                      things: model.fromColumn("in_progress"),
                      onNew: () => {})),
              Expanded(
                  child: KanbanColum(
                      title: "Done",
                      things: model.fromColumn("done"),
                      onNew: () => {})),
            ],
          );
        },
      ),
    );
  }
}
