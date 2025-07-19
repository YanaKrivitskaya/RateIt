import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';

class ItemDeleteDialog extends StatefulWidget {
  final String itemName;

  const ItemDeleteDialog({required this.itemName});

  @override
  _ItemDeleteDialogState createState() => _ItemDeleteDialogState();
}

class _ItemDeleteDialogState extends State<ItemDeleteDialog> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      insetPadding: EdgeInsets.all(viewPadding),
      title: Text("Delete ${widget.itemName}?"),
      actions: <Widget>[
        TextButton(
          child: Text('Delete', style: TextStyle(color: ColorsPalette.desire)),
          onPressed: () {
            Navigator.pop(context, 1);
          },
        ),
        TextButton(
          child: Text('Cancel', style: TextStyle(color: ColorsPalette.algalFuel)),
          onPressed: () {
            Navigator.pop(context, null);
          },
        )
      ],
    );
  }
}