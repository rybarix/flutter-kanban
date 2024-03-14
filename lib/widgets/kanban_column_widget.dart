import 'package:flutter/material.dart';
import 'package:flutter_kanban/models/kanban_card.dart';
import 'package:flutter_kanban/models/kanban_column.dart';
import 'package:flutter_kanban/models/kanban_model.dart';
import 'package:flutter_kanban/widgets/kanban_item.dart';
import 'package:provider/provider.dart';

class KanbanColumnWidget extends StatefulWidget {
  final KanbanColumn column;
  final VoidCallback onNew;

  const KanbanColumnWidget(
      {super.key, required this.column, required this.onNew});

  @override
  State<KanbanColumnWidget> createState() => _KanbanColumnWidgetState();
}

class _KanbanColumnWidgetState extends State<KanbanColumnWidget> {
  bool draggedOver = false;

  void _moveCard(KanbanCard card, KanbanColumn toColumn) {
    Provider.of<KanbanModel>(context, listen: false).move(card, toColumn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: draggedOver ? Colors.grey.shade100 : Colors.transparent,
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DragTarget<KanbanCard>(
            onWillAccept: (data) {
              setState(() {
                draggedOver = true;
              });
              return true;
            },
            onLeave: (data) {
              setState(() {
                draggedOver = false;
              });
            },
            onAccept: (data) {
              setState(() {
                draggedOver = false;
              });
              _moveCard(data, widget.column);
            },
            builder: (context, candidateData, rejectedData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.column.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      IconButton(
                          onPressed: widget.onNew,
                          icon: Icon(Icons.add, color: Colors.grey.shade400)),
                    ],
                  ),
                  const Divider(
                    height: 1.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                    child: Column(
                      children: widget.column.cards
                          .map((card) => LayoutBuilder(
                                key: ObjectKey(card),
                                builder: (context, constraints) => Draggable(
                                  data: card,
                                  feedback: Container(
                                    width: constraints.maxWidth,
                                    child: KanbanItem(
                                      card: card,
                                    ),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.5,
                                    child: KanbanItem(
                                      card: card,
                                    ),
                                  ), //Text(card.title.substring(0, card.title.length.clamp(0, 10)), style: TextStyle(color: Colors.black, fontSize: 10),),
                                  child: KanbanItem(
                                    card: card,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }
}
