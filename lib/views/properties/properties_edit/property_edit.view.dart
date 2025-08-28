import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/main.dart';
import 'package:rateit/models/property.model.dart';
import 'package:rateit/views/properties/properties_edit/property_delete.dialog.dart';
import 'package:rateit/views/properties/properties_edit/property_dropdown.dialog.dart';

import 'cubit/property_edit_cubit.dart';

class PropertyEditView extends StatefulWidget {
  final int collectionId;
  const PropertyEditView({required this.collectionId, super.key});

  @override
  _PropertyEditViewState createState() => _PropertyEditViewState();
}

class _PropertyEditViewState extends State<PropertyEditView> {
  final _formKey = GlobalKey<FormBuilderState>();

  var typeOptions = ['Text', 'Number', 'Checkbox'];

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
          if(state is PropertyEditDeleted){
            var duration = Duration(seconds: 2);
            globalScaffoldMessenger.currentState!
              ..hideCurrentSnackBar()
              ..showSnackBar(customSnackBar(SnackBarState.success, "Property deleted", duration));
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context, state.id);
            });
          }
        },
        child: BlocBuilder<PropertyEditCubit, PropertyEditState>(
        builder: (context, state){
          Property? property = state.property;
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
                            String? minValue = _formKey.currentState?.fields['minValue']?.value;
                            String? maxValue = _formKey.currentState?.fields['maxValue']?.value;

                            Property newProperty = property.copyWith(
                              name: _formKey.currentState?.fields['name']?.value,
                              type: _formKey.currentState?.fields['type']?.value,
                              comment: _formKey.currentState?.fields['comment']?.value,
                              isFilter: _formKey.currentState?.fields['isFilter']?.value,
                              isRequired: _formKey.currentState?.fields['isRequired']?.value,
                              isDropdown: _formKey.currentState?.fields['isDropdown']?.value,
                              minValue: minValue != null && minValue.isNotEmpty ? int.tryParse(minValue) : 0,
                              maxValue: maxValue != null && maxValue.isNotEmpty ? int.tryParse(maxValue) : null
                            );
                            context.read<PropertyEditCubit>().submitProperty(widget.collectionId, newProperty);
                        }}
                        //Navigator.pop(context);
                      })
                ]
            ),
            persistentFooterButtons: state.property?.id != null ? [
                deleteButton(context, state.property)
            ] : [],
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
                      onChanged: (val){
                        context.read<PropertyEditCubit>().updatePropertyType(val!);
                      },
                    ),
                    Visibility(
                      visible: property.type == "Number",
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //Text("Min"),
                        SizedBox(width: width40, child:
                          FormBuilderTextField(
                            name: "minValue",
                            initialValue: property.minValue != null ? property.minValue.toString() : "0",
                            decoration: const InputDecoration(labelText: 'Min'),
                            keyboardType: TextInputType.number,
                          )),
                        SizedBox(width: width40, child:
                        FormBuilderTextField(
                          name: "maxValue",
                          initialValue: property.maxValue != null ? property.maxValue.toString() : "",
                          decoration: const InputDecoration(labelText: 'Max'),
                          keyboardType: TextInputType.number,
                        )),
                      ],)),
                    FormBuilderTextField(
                      name: "comment",
                      maxLength: 50,
                      initialValue: property.comment,
                      decoration: const InputDecoration(labelText: 'Comment')
                    ),
                    FormBuilderCheckbox(
                        name: 'isRequired',
                        initialValue: property.isRequired ?? false,
                        title: Text("Property is required", style: appTextStyle(fontSize: fontSize16),)
                    ),
                    FormBuilderCheckbox(
                      name: 'isFilter',
                      initialValue: property.isFilter ?? true,
                      title: Text("Property can be used as a filter", style: appTextStyle(fontSize: fontSize16),)
                    ),
                    FormBuilderCheckbox(
                        name: 'isDropdown',
                        initialValue: property.isDropdown ?? false,
                        onChanged: (value) {
                          context.read<PropertyEditCubit>().toggleDropdown(value!);
                        },
                        title: Text("Property is a dropdown", style: appTextStyle(fontSize: fontSize16),)
                    ),
                    Visibility(
                      visible: property.isDropdown ?? false,
                      // Can use to recreate completely the field
                      // maintainState: false,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Divider(color: ColorsPalette.algalFuel),
                        Text("Dropdown values", style: appTextStyle(fontSize: accentFontSize),),
                        OutlinedButton(
                            style: ButtonStyle(
                              //padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: buttonPadding)),
                                backgroundColor: WidgetStateProperty.all<Color>(ColorsPalette.algalFuel),
                                foregroundColor: WidgetStateProperty.all<Color>(ColorsPalette.white)
                            ),
                            onPressed: () {
                              String propertyName = property.name ?? _formKey.currentState?.fields['name']?.value;
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
                        (property.dropdownOptions != null && property.dropdownOptions!.isNotEmpty )?
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
                        : SizedBox()
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

  Widget deleteButton(BuildContext context, Property? property) => OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9.0),
        ),
        backgroundColor: ColorsPalette.desire,
        foregroundColor: ColorsPalette.white,
        side: BorderSide(color: ColorsPalette.desire),
      ),
      onPressed: (){
        if(property != null){
          showDialog(
              barrierDismissible: false, context: context, builder: (_) =>
              PropertyDeleteDialog(propertyName: property.name!)
          ).then((val) {
            if(val == 1){
              context.read<PropertyEditCubit>().deleteProperty(property.id!);
            }
          });
        }
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
        Icon(Icons.delete),
        Text('Delete property')
      ],)
  );
}