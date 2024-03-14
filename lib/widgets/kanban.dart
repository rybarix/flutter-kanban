import 'package:flutter/material.dart';
import 'package:flutter_kanban/models/kanban_card.dart';
import 'package:flutter_kanban/models/kanban_column.dart';
import 'package:flutter_kanban/models/kanban_model.dart';
import 'package:flutter_kanban/widgets/kanban_column_widget.dart';
import 'package:provider/provider.dart';

class Kanban extends StatelessWidget {
  const Kanban({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<KanbanModel>(
        builder: (context, model, child) {
          return FutureBuilder(
              future: model.board(1),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text("Loading");
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (KanbanColumn c in snapshot.data?.columns ?? [])
                      Expanded(
                          key: ObjectKey(c),
                          child: KanbanColumnWidget(
                            // title: c.title,
                            column: c,
                            // things: c.cards,
                            onNew: () {
                              Provider.of<KanbanModel>(context, listen: false)
                                  .add(KanbanCard(0, 'Untitled', '', c.id));
                            },
                          )),
                  ],
                );
              }));
        },
      ),
    );
  }
}
