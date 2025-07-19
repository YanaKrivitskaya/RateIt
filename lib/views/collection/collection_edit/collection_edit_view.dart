import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/main.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/views/collection/collection_edit/collection_delete_dialog.dart';
import 'package:rateit/views/collection/collection_edit/cubit/collection_edit_cubit.dart';

class CollectionEditView extends StatefulWidget {
  const CollectionEditView({super.key});

  @override
  _CollectionEditViewState createState() => _CollectionEditViewState();
}

class _CollectionEditViewState extends State<CollectionEditView> {
  final _formKey = GlobalKey<FormBuilderState>();

  IconData? selectedIcon;

  _pickIcon(Collection collection) async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        iconPackModes: [IconPack.material],
      ),
    );

    if(icon != null){
      context.read<CollectionEditCubit>().setIcon(icon.data, collection);
    }
    debugPrint('Picked Icon:  $icon');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollectionEditCubit, CollectionEditState>(
      listener: (context, state){
        if(state is CollectionEditLoading){
          var duration = Duration(seconds: 3);
          globalScaffoldMessenger.currentState!
            ..hideCurrentSnackBar()
            ..showSnackBar(customSnackBar(SnackBarState.loading, null, duration));
        }
        if(state is CollectionEditSuccess){
          globalScaffoldMessenger.currentState!
              .hideCurrentSnackBar();
        }
        if(state is CollectionEditError){
          var duration = Duration(days: 1);
          globalScaffoldMessenger.currentState!
            ..hideCurrentSnackBar()
            ..showSnackBar(customSnackBar(SnackBarState.error, state.error, duration));
        }
        if(state is CollectionEditCreated){
          var duration = Duration(seconds: 2);
          globalScaffoldMessenger.currentState!
            ..hideCurrentSnackBar()
            ..showSnackBar(customSnackBar(SnackBarState.success, null, duration));
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context, state.collection!);
          });
        }
        if(state is CollectionEditDelete){
          var duration = Duration(seconds: 2);
          globalScaffoldMessenger.currentState!
            ..hideCurrentSnackBar()
            ..showSnackBar(customSnackBar(SnackBarState.success, null, duration));
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context, state.id);
          });
        }
      },
      child: BlocBuilder<CollectionEditCubit, CollectionEditState>(
          builder: (context, state){
            return Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title: Text('Edit collection'),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      })),
              persistentFooterButtons: [
                deleteButton(context, state.collection)
              ],
              body: state.collection != null ? SingleChildScrollView(
                  padding: EdgeInsets.all(viewPadding),
                  child: FormBuilder(
                      key: _formKey,
                      child: Column(children: [
                        collectionPreview(state.collection!, state.collection?.colorPrimary, state.collection?.colorAccent, state.collection?.icon),
                        FormBuilderTextField(
                          name: "name",
                          maxLength: 50,
                          initialValue: state.collection?.name ?? '',
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required()
                          ]),
                        ),
                        FormBuilderTextField(
                          name: "description",
                          initialValue: state.collection?.description ?? '',
                          decoration: const InputDecoration(labelText: 'Description'),
                          maxLength: 250,
                          maxLines: 5,
                        ),
                        _submitButton(context, state.collection!)
                      ])
                  )
              ) : loadingWidget(ColorsPalette.algalFuel)
            );
          }
      )
    );
  }

  Widget collectionPreview(Collection collection, Color? colorPrimary, Color? colorSecondary, IconData? icon)=>
    SizedBox(
      width: width30,
      height: width30,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0), // Adjust for rounded corners
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorPrimary ?? ColorsPalette.algalFuel,
              colorSecondary ?? ColorsPalette.boyzone
            ],
          ),
        ),
        child: InkWell(
          onTap: ()=>_pickIcon(collection),
          child: Icon(icon ?? Icons.collections, color: Colors.white, size: iconSize),
        )
      ),
    );

  Widget _submitButton(BuildContext context, Collection collection) => ElevatedButton(
      style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: buttonPadding)),
          backgroundColor: WidgetStateProperty.all<Color>(ColorsPalette.algalFuel),
          foregroundColor: WidgetStateProperty.all<Color>(ColorsPalette.white)
      ),
      onPressed: (){
        var isFormValid = _formKey.currentState!.validate();

        if(isFormValid){
          Collection newCollection = collection.copyWith(
            name: _formKey.currentState?.fields['name']?.value,
            description: _formKey.currentState?.fields['description']?.value
          );
          context.read<CollectionEditCubit>().submitCollection(newCollection);
        }
      },
      child: collection.id != null ? Text("Save") : Text("Create")
  );

  Widget deleteButton(BuildContext context, Collection? collection) => OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9.0),
        ),
        backgroundColor: ColorsPalette.desire,
        foregroundColor: ColorsPalette.white,
        side: BorderSide(color: ColorsPalette.desire),
      ),
      onPressed: (){
        if(collection != null){
          showDialog(
              barrierDismissible: false, context: context, builder: (_) =>
              CollectionDeleteDialog(collectionName: collection.name!)
          ).then((val) {
            if(val == 1){
              context.read<CollectionEditCubit>().deleteCollection(collection.id!);
            }
          });
        }
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
        Icon(Icons.delete),
        Text('Delete collection')
      ],)
  );

}
