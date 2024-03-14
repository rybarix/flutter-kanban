import 'package:flutter/widgets.dart';
import 'package:flutter_kanban/models/kanban_card.dart';
import 'package:flutter_kanban/models/kanban_board.dart';
import 'package:flutter_kanban/models/kanban_column.dart';
import 'package:sqflite/sqflite.dart';

class KanbanModel extends ChangeNotifier {
  final Future<Database> connection;
  KanbanModel(this.connection);

  // TODO: there is problem in this logic below
  // FIXME:
  List<KanbanBoard> transformToModelHierarchy(
      List<Map<String, dynamic>> result) {
    Map<int, KanbanBoard> boardMap = {};
    Map<int, KanbanColumn> columnMap = {};

    for (var row in result) {
      String boardTitle = row['board_title'];
      int boardId = row['board_id'];
      String columnTitle = row['column_title'];
      int columnId = row['column_id'];


      // We're doing left join on columns. We want all columns even if they're empty.
      if (row['card_id'] == null) {
        if (!columnMap.containsKey(columnId)) {
          columnMap[columnId] = KanbanColumn(columnId, columnTitle, []);
          if (!boardMap.containsKey(boardId)) {
            boardMap[boardId] = KanbanBoard(boardId, boardTitle, []);
          }
          boardMap[boardId]?.columns.add(columnMap[columnId]!);
        }

        continue;
      }

      int cardId = row['card_id'];

      if (!boardMap.containsKey(boardId)) {
        boardMap[boardId] = KanbanBoard(boardId, boardTitle, []);
      }

      if (!columnMap.containsKey(columnId)) {
        columnMap[columnId] = KanbanColumn(columnId, columnTitle, []);
        boardMap[boardId]?.columns.add(columnMap[columnId]!);
      }

      columnMap[columnId]!
          .cards
          .add(KanbanCard(cardId, row['title'], row['body'], columnId));
    }

    return boardMap.values.toList();
  }

  Future<KanbanBoard> board(int ofBoardId /*, int columnId*/) async {
    final db = await connection;

    final List<Map<String, Object?>> result = await db.rawQuery("""
      SELECT boards.id  as board_id,
             boards.title as board_title,
             columns.id as column_id,
             columns.title as column_title,
             cards.id    as card_id,
             cards.body  as body,
             cards.title as title
      FROM boards
      JOIN columns ON columns.board_id = boards.id
      LEFT JOIN cards   ON cards.column_id  = columns.id
      WHERE boards.id = ? ORDER BY columns.id ASC, cards.id DESC;
      """, [ofBoardId]);

    return transformToModelHierarchy(result).first;
  }

  void edit(KanbanCard editedCard) async {
    final db = await connection;
    await db.update('cards', editedCard.toMap(), where: 'id = ?', whereArgs: [editedCard.id], conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  void add(KanbanCard item) async {
    final db = await connection;
    final newCard = item.toMap();
    newCard.remove('id');
    await db.insert('cards', newCard);
    notifyListeners();
  }

  void remove(KanbanCard item) async {
    final db = await connection;
    await db.delete('cards', where: 'id = ? ', whereArgs: [item.id]);
    notifyListeners();
  }

  void move(KanbanCard item, KanbanColumn toColumn) async {
    final db = await connection;
    // final batch = db.batch();
    item.columnId = toColumn.id;
    final map = item.toMap();
    await db.update('cards', map, where: 'id = ?', whereArgs: [item.id]);
    // await batch.commit();
    notifyListeners();
  }
}
