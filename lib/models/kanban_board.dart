import 'package:flutter_kanban/models/kanban_column.dart';

class KanbanBoard {
  // CREATE TABLE boards(id INTEGER PRIMARY KEY, title VARCHAR);
  final int id;
  final String title;
  final List<KanbanColumn> columns;
  KanbanBoard(this.id, this.title, this.columns);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'columns': columns.map((c) => {
        'id': c.id,
        'title': c.title,
        // 'board_id': c.boardId,
      }).toList(),
    };
  }
}