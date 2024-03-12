import 'package:flutter/widgets.dart';
import 'package:flutter_kanban/kanban_card.dart';

class KanbanModel extends ChangeNotifier {
  final List<KanbanCard> _items = [
    KanbanCard(1, "Title", "body", "todo"),
    KanbanCard(1, "Title", "body", "in_progress"),
    KanbanCard(1, "Title", "body", "done"),
  ];

  /// Retrieve all cards from given column.
  /// Eeach KanbanCard belongs to column.
  List<KanbanCard> fromColumn(String column) {
    return _items.where((element) => element.column == column).toList();
  }

  void edit(KanbanCard editedCard) {
    int index =_items.indexWhere((element) => element.id == editedCard.id);
    _items[index] = editedCard;
    notifyListeners();
  }

  void add(KanbanCard item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(KanbanCard item) {
    int index =_items.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      _items.removeAt(index);
      notifyListeners();
    }
  }
}
