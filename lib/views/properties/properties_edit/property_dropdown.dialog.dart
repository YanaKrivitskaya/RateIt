import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';

class PropertyDropdownDialog extends StatefulWidget {
  final String propertyName;
  final String value;
  const PropertyDropdownDialog({required this.propertyName, required this.value, super.key});

  @override
  _PropertyDropdownDialogState createState() => _PropertyDropdownDialogState();
}

class _PropertyDropdownDialogState extends State<PropertyDropdownDialog> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      insetPadding: EdgeInsets.all(viewPadding),
      title: Text("${widget.propertyName} value"),
      content: SizedBox(
          width: fullWidth,
          child: SingleChildScrollView(
              child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormBuilder(
                    key: _formKey,
                    child: FormBuilderTextField(
                      name: "value",
                      maxLength: 50,
                      initialValue: widget.value,
                      decoration: const InputDecoration(labelText: 'Value'),
                    ),
                  )
                ],
              )
          )
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Delete', style: TextStyle(color: ColorsPalette.desire)),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        TextButton(
          child: Text('Save', style: TextStyle(color: ColorsPalette.algalFuel)),
          onPressed: () {
            String newValue = _formKey.currentState?.fields['value']?.value;
            Navigator.pop(context, newValue);
          },
        )
      ],
    );
  }
}