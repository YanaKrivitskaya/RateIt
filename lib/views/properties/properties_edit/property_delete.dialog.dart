import 'package:flutter/material.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';

class PropertyDeleteDialog extends StatefulWidget {
  final String propertyName;
  const PropertyDeleteDialog({super.key, required this.propertyName});

  @override
  _PropertyDeleteDialogState createState() => _PropertyDeleteDialogState();
}

class _PropertyDeleteDialogState extends State<PropertyDeleteDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      insetPadding: EdgeInsets.all(viewPadding),
      title: Text("Delete ${widget.propertyName}?"),
      content: SizedBox(
          width: fullWidth,
          child: SingleChildScrollView(
              child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("All item values for this property will be deleted as well")
                ],
              )
          )
      ),
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