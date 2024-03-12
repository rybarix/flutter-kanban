import 'package:flutter/material.dart';
import 'package:flutter_kanban/kanban_card.dart';
import 'package:flutter_kanban/widgets/kanban_item.dart';

class KanbanColum extends StatelessWidget {
  final String title;
  final List<KanbanCard> things;
  final VoidCallback onNew;

  const KanbanColum(
      {super.key,
      required this.things,
      required this.title,
      required this.onNew});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              IconButton(
                  onPressed: onNew,
                  icon: Icon(Icons.add, color: Colors.grey.shade400)),
            ],
          ),
          const Divider(
            height: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
            child: Column(
              children: things
                  .map((card) => KanbanItem(
                        card: card,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
