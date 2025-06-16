import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/helpers/styles.dart';

class CreateCollectionView extends StatefulWidget {
  const CreateCollectionView({super.key});

  @override
  _CreateCollectionViewState createState() => _CreateCollectionViewState();
}

class _CreateCollectionViewState extends State<CreateCollectionView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New collection'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
      })),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(viewPadding),
        child: FormBuilder(
          key: _formKey,
          child: Column(children: [
            FormBuilderTextField(
              name: "name",
              maxLength: 50,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required()
              ]),
            ),
            FormBuilderTextField(
              name: "description",
              decoration: const InputDecoration(labelText: 'Description'),
              maxLength: 250,
              maxLines: 5,
            )
          ],)
        )
      )
    );
  }
}
