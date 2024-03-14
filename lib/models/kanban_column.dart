import 'package:flutter_kanban/models/kanban_card.dart';

class KanbanColumn {
  final int id;
  final String title;
  // final int boardId;
  final List<KanbanCard> cards;
  KanbanColumn(this.id, this.title, /*this.boardId,*/ this.cards);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      // 'board_id': boardId,
      'cards': cards.map((c) => {
        'id': c.id,
        'title': c.title,
        'body': c.body,
        // 'column_id': c.columnId,
      }).toList(),
    };
  }
}
