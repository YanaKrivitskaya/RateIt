
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/main.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/views/collection/collection_settings/collection_delete.dialog.dart';
import 'package:rateit/views/collection/collection_settings/cubit/collection_settings_cubit.dart';

class CollectionSettingsView extends StatefulWidget {
  //final Collection collection;

  const CollectionSettingsView({super.key});

  @override
  _CollectionSettingsViewState createState() => _CollectionSettingsViewState();

}

class _CollectionSettingsViewState extends State<CollectionSettingsView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CollectionSettingsCubit, CollectionSettingsState>(
        listener: (context, state){
          if(state is CollectionSettingsDelete){
            var duration = Duration(seconds: 2);
            globalScaffoldMessenger.currentState!
              ..hideCurrentSnackBar()
              ..showSnackBar(customSnackBar(SnackBarState.success, null, duration));
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context, state.id);
            });
          }
        },
        child: BlocBuilder<CollectionSettingsCubit, CollectionSettingsState>(
        builder: (context, state){
          Collection collection = state.collection;
          return Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title: Text('Settings'),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        if(state is CollectionSettingsSuccess && state.hasEdit){
                          Navigator.pop(context, state.collection);
                        }else{
                          Navigator.pop(context);
                        }
                      })),
              persistentFooterButtons: [
                deleteButton(context, state.collection)
              ],
              body: Container(
                  padding: EdgeInsets.symmetric(horizontal: borderPadding),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, editCollectionRoute, arguments: collection).then((value)
                            {
                              if(value != null && value is Collection){
                                context.read<CollectionSettingsCubit>().setEdit(value);
                              }
                            });
                          },
                          child: ListTile(
                              title: Text('Edit collection',
                                  style: appTextStyle(fontSize: accentFontSize))
                          ),
                        ),
                      ),
                      Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, viewPropertiesRoute,
                                arguments: collection.id);
                          },
                          child: ListTile(
                              title: Text('Properties',
                                  style: appTextStyle(fontSize: accentFontSize))
                          ),
                        ),
                      ),
                      /*Card(
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, categoriesRoute);
                },
                child: ListTile(
                    title: Text('Categories', style: appTextStyle(fontSize: accentFontSize))
                ),
              ),
            )*/
                    ],),
                  )
              )
          );
        })
    );
  }

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
              context.read<CollectionSettingsCubit>().deleteCollection(collection.id!);
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
