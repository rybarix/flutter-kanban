import 'package:flutter/material.dart';

class KanbanItem extends StatelessWidget {
  final String text;
  final String title;
  final bool editable;
  // final void Function(String)? onChange;

  const KanbanItem(
      {super.key,
      required this.text,
      required this.title,
      // required this.onChange,
      this.editable = false});

  @override
  Widget build(BuildContext context) {
    Widget isEditable() {
      return Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(text),
        ],
      );
    }

    Widget notEditable() {
      return Column(
        children: [
          // TextField(),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(text),
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
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField(
                // onChanged: onChange,
              // ),
              editable ? isEditable() : notEditable(),
            ],
          ),
        ),
      ),
    );
  }
}
