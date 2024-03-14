import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_kanban/models/kanban_card.dart';
import 'package:flutter_kanban/models/kanban_model.dart';
import 'package:provider/provider.dart';

enum CardMenu { delete, edit }

class KanbanItem extends StatefulWidget {
  final KanbanCard card;
  final bool editable;

  const KanbanItem({super.key, required this.card, this.editable = false});

  @override
  State<KanbanItem> createState() => _KanbanItemState();
}

class _KanbanItemState extends State<KanbanItem> {
  TextEditingController tecTitle = TextEditingController(text: '');
  TextEditingController tecBody = TextEditingController(text: '');
  late KanbanCard _card;
  late int id;
  bool editable = false;

  @override
  void initState() {
    super.initState();
    _card = widget.card;

    // Set initial values
    tecTitle.text = _card.title;
    tecBody.text = _card.body;

    tecTitle.addListener(() {
      final String text = tecTitle.text;
      _card.title = text;
    });

    tecBody.addListener(() {
      final String text = tecBody.text;
      _card.body = text;
    });
  }

  void dblTap() {
    var _timer = Timer(
      Duration(milliseconds: 300),
      () => setState(
        () {},
      ),
    );
  }

  void _startEditable() {
    setState(() {
      editable = true;
    });
  }

  void _endEditable() {
    setState(() {
      editable = false;
    });

    // Update model with edited model.
    Provider.of<KanbanModel>(context, listen: false).edit(_card);
  }

  @override
  Widget build(BuildContext context) {
    Widget isEditable() {
      return Column(
        children: [
          TextField(controller: tecTitle),
          TextField(controller: tecBody),
        ],
      );
    }

    Widget notEditable() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_card.title, style: Theme.of(context).textTheme.titleMedium),
          Text(_card.body),
        ],
      );
    }

    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Card(
        color: Colors.grey.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    '#${widget.card.id}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(editable ? Icons.done : Icons.edit,
                        color: Colors.grey.shade400),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: EdgeInsets.all(0.0),
                    visualDensity: VisualDensity.compact,
                    iconSize: 14,
                    // hover: Colors.grey.shade600,
                    onPressed: () {
                      editable ? _endEditable() : _startEditable();
                    },
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      Provider.of<KanbanModel>(context, listen: false)
                          .remove(_card);
                    },
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.grey.shade400),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      // hoverColor: Colors.transparent,
                      padding: EdgeInsets.all(0.0),
                      visualDensity: VisualDensity.compact,
                      iconSize: 14,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              editable ? isEditable() : notEditable(),
            ],
          ),
        ),
      ),
    );
  }
}
