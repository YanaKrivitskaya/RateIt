import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/main.dart';
import 'package:rateit/models/collection_property.model.dart';
import 'package:rateit/views/properties/properties_edit/property_dropdown_dialog.dart';

import 'cubit/property_edit_cubit.dart';

class PropertyEditView extends StatefulWidget {
  final int collectionId;
  const PropertyEditView({required this.collectionId, super.key});

  @override
  _PropertyEditViewState createState() => _PropertyEditViewState();
}

class _PropertyEditViewState extends State<PropertyEditView> {
  final _formKey = GlobalKey<FormBuilderState>();

  var typeOptions = ['Text', 'Number', 'Date'];

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyEditCubit, PropertyEditState>(
        listener: (context, state){
          if(state is PropertyEditLoading){
            var duration = Duration(days: 1);
            globalScaffoldMessenger.currentState!
              ..hideCurrentSnackBar()
              ..showSnackBar(customSnackBar(SnackBarState.loading, null, duration));
          }
          if(state is PropertyEditSuccess){
            globalScaffoldMessenger.currentState!
              .hideCurrentSnackBar();
          }
          if(state is PropertyEditError){
            var duration = Duration(days: 1);
            globalScaffoldMessenger.currentState!
              ..hideCurrentSnackBar()
              ..showSnackBar(customSnackBar(SnackBarState.error, state.error, duration));
          }
          if(state is PropertyEditCreated){
            globalScaffoldMessenger.currentState!
                .hideCurrentSnackBar();
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context, state.property!);
            });
          }
        },
        child: BlocBuilder<PropertyEditCubit, PropertyEditState>(
        builder: (context, state){
          CollectionProperty? property = state.property;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Property"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
                actions: [
                  IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () {
                        if(property != null){
                          var isFormValid = _formKey.currentState!.validate();

                          if(isFormValid){
                            CollectionProperty newProperty = property.copyWith(
                              name: _formKey.currentState?.fields['name']?.value,
                              type: _formKey.currentState?.fields['type']?.value,
                              comment: _formKey.currentState?.fields['comment']?.value,
                              isFilter: _formKey.currentState?.fields['isFilter']?.value,
                              isDropdown: _formKey.currentState?.fields['isDropdown']?.value,
                            );
                            context.read<PropertyEditCubit>().submitProperty(widget.collectionId, newProperty);
                        }}
                        //Navigator.pop(context);
                      })
                ]
            ),
            body: property != null ? Container(
              padding: EdgeInsets.symmetric(horizontal: borderPadding),
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(children: [
                    FormBuilderTextField(
                      name: "name",
                      maxLength: 50,
                      initialValue: property.name,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required()
                      ]),
                    ),
                    FormBuilderDropdown<String>(
                      name: 'type',
                      decoration: InputDecoration(
                        labelText: 'Type',
                        hintText: 'Type',
                      ),
                      initialValue: property.type != null ? typeOptions.where((option)=> option.toString() == property.type).first : typeOptions.first,
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: typeOptions
                          .map((type) => DropdownMenuItem(
                        alignment: AlignmentDirectional.centerStart,
                        value: type,
                        child: Text(type),
                      )).toList(),                      
                      valueTransformer: (val) => val?.toString(),
                    ),
                    FormBuilderTextField(
                      name: "comment",
                      maxLength: 50,
                      initialValue: property.comment,
                      decoration: const InputDecoration(labelText: 'Comment')
                    ),
                    FormBuilderCheckbox(
                      name: 'isFilter',
                      initialValue: true,
                      title: Text("Property can be used as a filter", style: appTextStyle(fontSize: fontSize16),)
                    ),
                    FormBuilderCheckbox(
                        name: 'isDropdown',
                        initialValue: property?.isDropdown ?? false,
                        onChanged: (value) {
                          context.read<PropertyEditCubit>().toggleDropdown(value!);
                        },
                        title: Text("Property is a dropdown", style: appTextStyle(fontSize: fontSize16),)
                    ),
                    Visibility(
                      visible: property?.isDropdown ?? false,
                      // Can use to recreate completely the field
                      // maintainState: false,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Divider(color: ColorsPalette.algalFuel),
                        OutlinedButton(
                            style: ButtonStyle(
                              //padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: buttonPadding)),
                                backgroundColor: WidgetStateProperty.all<Color>(ColorsPalette.algalFuel),
                                foregroundColor: WidgetStateProperty.all<Color>(ColorsPalette.white)
                            ),
                            onPressed: () {
                              String propertyName = property!.name ?? _formKey.currentState?.fields['name']?.value;
                              showDialog(
                                  barrierDismissible: false, context: context, builder: (_) =>
                                  PropertyDropdownDialog(propertyName: propertyName, value: '')
                              ).then((val) {
                                if(val != null && val != ''){
                                  context.read<PropertyEditCubit>().updateDropdownValues(null, val, false);
                                }
                              });
                            },
                            child: Text('Add value')),
                        Text("Dropdown values:", style: appTextStyle(fontSize: accentFontSize),),
                        (property?.dropdownOptions != null && property!.dropdownOptions!.isNotEmpty )?
                        Column(children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: property.dropdownOptions!.length,
                            itemBuilder: (context, position){
                              final String option = property.dropdownOptions![position];
                              return Card(
                                child: InkWell(
                                  onTap: (){
                                    String propertyName = property.name ?? _formKey.currentState?.fields['name']?.value;
                                    showDialog(
                                        barrierDismissible: false, context: context, builder: (_) =>
                                          PropertyDropdownDialog(propertyName: propertyName, value: option)
                                    ).then((val) {
                                      if(val != null){
                                        context.read<PropertyEditCubit>().updateDropdownValues(position, val, false);
                                      }else{
                                        context.read<PropertyEditCubit>().updateDropdownValues(position, '', true);
                                      }
                                    });
                                  },
                                  child: ListTile(
                                      title: Text(option)
                                  ),
                                ),
                              );
                            },
                          )
                        ],)
                        : SizedBox(),
                      ],)
                    )
                  ],)
                )
              )
            ): loadingWidget(ColorsPalette.algalFuel)
          );
        })
    );
  }
}