import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_iconpicker/extensions/list_extensions.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/main.dart';
import 'package:rateit/models/collection_item.model.dart';
import 'package:rateit/models/collection_property.model.dart';
import 'package:rateit/models/view_models/attachment_view.model.dart';
import 'package:rateit/views/items/item_edit/cubit/item_edit_cubit.dart';
import 'package:rateit/views/items/item_edit/image_crop.view.dart';

class ItemEditView extends StatefulWidget {
  final int collectionId;
  const ItemEditView({required this.collectionId, super.key});

  @override
  _ItemEditViewState createState() => _ItemEditViewState();
}

class _ItemEditViewState extends State<ItemEditView> {
  final _formKey = GlobalKey<FormBuilderState>();
  final int maxImages = 5;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemEditCubit, ItemEditState>(
      listener: (context, state){
        if(state is ItemEditLoading){
          var duration = Duration(days: 1);
          globalScaffoldMessenger.currentState!
            ..hideCurrentSnackBar()
            ..showSnackBar(customSnackBar(SnackBarState.loading, null, duration));
        }
        if(state is ItemEditSuccess){
          globalScaffoldMessenger.currentState!
              .hideCurrentSnackBar();
        }
        if(state is ItemEditError){
          var duration = Duration(days: 1);
          globalScaffoldMessenger.currentState!
            ..hideCurrentSnackBar()
            ..showSnackBar(customSnackBar(SnackBarState.error, state.error, duration));
        }
        if(state is ItemEditCreated){
          globalScaffoldMessenger.currentState!
              .hideCurrentSnackBar();
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context, state.item);
          });
        }
      },
      child: BlocBuilder<ItemEditCubit, ItemEditState>(
        builder: (context, state){
          CollectionItem? item = state.item;
          List<CollectionProperty>? properties = item?.properties;
          return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text("Item"),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                actions: [
                  IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () {
                        if(item != null){
                          var isFormValid = _formKey.currentState!.validate();

                          if(isFormValid){
                            List<CollectionProperty> properties = List.empty(growable: true);

                            for (var prop in item.properties!) {
                              var value = _formKey.currentState?.fields[prop.name!]?.value;
                              if(value != null && value.toString().isNotEmpty){
                                properties.add(prop.copyWith(value: _formKey.currentState?.fields[prop.name!]?.value.toString()));
                              }
                            }
                            CollectionItem newItem = item.copyWith(
                                name: _formKey.currentState?.fields['name']?.value,
                                description: _formKey.currentState?.fields['description']?.value,
                                date: _formKey.currentState?.fields['date']?.value,
                                rating: item.rating ?? 0,
                                properties: properties
                            );
                            context.read<ItemEditCubit>().submitItem(widget.collectionId, newItem);
                          }
                        }
                      })
                ]
            ),
          body: item != null ? Container(
            padding: EdgeInsets.only(left: viewPadding, right: viewPadding, bottom: formBottomPadding),
              child: SingleChildScrollView(
                  child: FormBuilder(
                      key: _formKey,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Text("Photos"),
                        SizedBox(
                          height: width30,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children:[
                                ...List.generate(state.files!.length, (int index) {
                                  AttachmentViewModel att = state.files![index];
                                  if(att.state == AttState.delete) {
                                    return SizedBox();
                                  } else {return Row(children: [
                                    Stack(
                                      children: [
                                        att.id != null ? Image.memory(att.source!) : Image.file(File(att.file!.path)),
                                        PositionedDirectional(
                                            top: 0,
                                            end: 0,
                                            child:InkWell(
                                              onTap: (){
                                                context.read<ItemEditCubit>().removeImage(index);
                                              },
                                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                              child: Container(
                                                margin: const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.withValues(alpha: .7),
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                height: 22,
                                                width: 22,
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                    SizedBox(width: sizerWidthsm)
                                  ],) ;}

                                }),
                                (state.files!.where((f)=> f.state != AttState.delete).length < maxImages) ? InkWell(
                                  child: Card(
                                    color: ColorsPalette.blueGrey,
                                    child: SizedBox(
                                      width: width30,
                                      height: width30,
                                      child: Icon(Icons.image, color: Colors.white, size: iconSize),
                                    ),
                                  ),
                                  onTap: (){
                                    _showSelectionDialog(context);
                                  },
                                ) : SizedBox()
                              ]
                          ),
                        ),
                        FormBuilderTextField(
                          name: "name",
                          maxLength: 50,
                          initialValue: item.name,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required()
                          ]),
                        ),
                        FormBuilderTextField(
                            name: "description",
                            maxLength: 250,
                            initialValue: item.description,
                            decoration: const InputDecoration(labelText: 'Description')
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          RatingBar.builder(
                            initialRating: item.rating ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              context.read<ItemEditCubit>().updateRating(rating);
                            },
                          ),
                          Text(item.rating?.toString() ?? '')
                        ],),
                        FormBuilderDateTimePicker(
                          name: "date",
                          initialEntryMode: DatePickerEntryMode.calendar,
                          initialValue: DateTime.now(),
                          inputType: InputType.both,
                          format: DateFormat.yMMMd(),
                          decoration: InputDecoration(
                            labelText: "Date",
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                //_formKey.currentState!.fields['date']?.didChange(null);
                              },
                            ),
                          ),
                          initialTime: const TimeOfDay(hour: 8, minute: 0),
                          // locale: const Locale.fromSubtags(languageCode: 'fr'),
                        ),
                        SizedBox(height: sizerHeightMd),
                        (properties != null) ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: properties.length,
                            itemBuilder: (BuildContext context, int index) {
                              var property = properties[index];
                              String propertyName = property.name!;
                              if(property.isDropdown! && property.dropdownOptions.isNotNullOrEmpty){
                                return Column(children: [
                                  FormBuilderDropdown<String>(
                                    name: propertyName,
                                    decoration: InputDecoration(
                                      labelText: propertyName,
                                      hintText: propertyName,
                                    ),
                                    initialValue: property.dropdownOptions!.first,
                                    validator: property.isRequired! ? FormBuilderValidators.compose(
                                        [FormBuilderValidators.required()]) : null,
                                    items: property.dropdownOptions!
                                        .map((value) => DropdownMenuItem(
                                      alignment: AlignmentDirectional.centerStart,
                                      value: value,
                                      child: Text(value),
                                    )).toList(),
                                    valueTransformer: (val) => val?.toString(),
                                  ),
                                  SizedBox(height: sizerHeightMd)
                                ]);
                              }else if(property.type == "Date"){
                                return Column(children: [
                                  FormBuilderDateTimePicker(
                                    name: propertyName,
                                    initialEntryMode: DatePickerEntryMode.calendar,
                                    initialValue: DateTime.now(),
                                    inputType: InputType.both,
                                    decoration: InputDecoration(
                                      labelText: propertyName,
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          //_formKey.currentState!.fields['date']?.didChange(null);
                                        },
                                      ),
                                    ),
                                    initialTime: const TimeOfDay(hour: 8, minute: 0),
                                    // locale: const Locale.fromSubtags(languageCode: 'fr'),
                                  )
                                ],);}
                              else{
                                String label = property.comment != null ? "$propertyName, ${property.comment}" : propertyName;
                                return Column(children: [
                                  FormBuilderTextField(
                                    name: propertyName,
                                    maxLength: 50,
                                    keyboardType: property.type == "Number" ?  TextInputType.number : TextInputType.text,
                                    initialValue: property.value,
                                    decoration: InputDecoration(labelText: label),
                                    validator: property.isRequired! ? FormBuilderValidators.compose([
                                      FormBuilderValidators.required()
                                    ]) : null,
                                  ),
                                  SizedBox(height: sizerHeightMd)
                                ]);
                              }
                            }
                        ) : SizedBox()
                      ],)
                  )
              )
          ) : loadingWidget(ColorsPalette.algalFuel)
          );
        }
      )
    );
  }

  Future selectOrTakePhoto(ImageSource imageSource, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: imageSource);

    if(pickedFile != null){
      var fileSize = await pickedFile.length();
      var compressPercent = 50;

      var args = ImageCropArguments(compress: compressPercent, file: File(pickedFile.path));
      Navigator.pushNamed(context, imageCropRoute, arguments: args).then((imageFile) {
        if(imageFile != null){
          context.read<ItemEditCubit>().addImage(imageFile as CroppedFile);
        }
      });
    }
  }

  Future _showSelectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text('Select photo'),
        children: <Widget>[
          SimpleDialogOption(
            child: Text('From gallery'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.gallery, context);
              Navigator.pop(context);
            },
          ),
          SimpleDialogOption(
            child: Text('Take a photo'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.camera, context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
