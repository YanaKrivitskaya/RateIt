
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/models/args_models/order_options_args.model.dart';
import 'package:rateit/models/order.models.dart';

class CollectionOrderDialog extends StatelessWidget {
  String? orderField;
  String? orderDirection;

  CollectionOrderDialog({this.orderField, this.orderDirection});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(viewPadding),
      title: Text("Order by"),
      content: SizedBox(
          width: fullWidth,
          child: SingleChildScrollView(
              child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormBuilder(
                    key: _formKey,
                    onChanged: () {
                      _formKey.currentState!.save();
                      debugPrint(_formKey.currentState!.value.toString());
                    },
                    child: Column(children: [
                      FormBuilderRadioGroup<String>(
                        initialValue: orderField ?? 'Date',
                        name: 'orderField',
                        //onChanged: _onChanged,
                        options: ['Name', 'Rating', 'Date', 'Date Modified']
                            .map((field) => FormBuilderFieldOption(
                          value: field,
                          child: Text(field),
                        ),
                        ).toList(growable: false),
                        controlAffinity: ControlAffinity.leading,
                        orientation: OptionsOrientation.vertical,
                      ),
                      FormBuilderRadioGroup<String>(
                        initialValue: orderDirection ?? 'Desc',
                        name: 'orderDirection',
                        //onChanged: _onChanged,
                        options: ['Asc', 'Desc']
                            .map((field) => FormBuilderFieldOption(
                          value: field,
                          child: Text(field),
                        ),
                        ).toList(growable: false),
                        controlAffinity: ControlAffinity.leading,
                        orientation: OptionsOrientation.vertical,
                      ),
                    ],)
                   )
                ],
              )
          )
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Done', style: TextStyle(color: ColorsPalette.algalFuel)),
          onPressed: () {
            String orderOption = _formKey.currentState?.fields['orderField']?.value;
            String orderDirection = _formKey.currentState?.fields['orderDirection']?.value;
            Navigator.pop(context, OrderOptionsArgs(orderOption, orderDirection));
          },
        )
      ],
    );
  }
}