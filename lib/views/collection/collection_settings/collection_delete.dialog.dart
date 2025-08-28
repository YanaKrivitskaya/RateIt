import 'package:flutter/material.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';

class CollectionDeleteDialog extends StatelessWidget {
  final String collectionName;
  const CollectionDeleteDialog({super.key, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      insetPadding: EdgeInsets.all(viewPadding),
      title: Text("Delete $collectionName?"),
      content: SizedBox(
          width: fullWidth,
          child: SingleChildScrollView(
              child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("All items and properties will be deleted as well")
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

