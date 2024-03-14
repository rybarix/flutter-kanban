class KanbanCard {
  int id;
  String title;
  String body;
  int columnId;

  KanbanCard(this.id, this.title, this.body, this.columnId);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'column_id': columnId,
    };
  }
}
