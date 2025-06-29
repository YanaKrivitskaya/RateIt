
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/main.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/models/args_models/item_edit_args.model.dart';
import 'package:rateit/views/collection/collection_view/collection_view_cubit.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({super.key});

  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CollectionViewCubit, CollectionViewState>(
        listener: (context, state){
          if(state is CollectionViewLoading){
            var duration = Duration(days: 1);
            globalScaffoldMessenger.currentState!
              ..hideCurrentSnackBar()
              ..showSnackBar(customSnackBar(SnackBarState.loading, null, duration));
          }
          if(state is CollectionViewSuccess){
            globalScaffoldMessenger.currentState!
                .hideCurrentSnackBar();
          }
          if(state is CollectionViewError){
            var duration = Duration(days: 1);
            globalScaffoldMessenger.currentState!
              ..hideCurrentSnackBar()
              ..showSnackBar(customSnackBar(SnackBarState.error, state.error, duration));
          }
        },
        child: BlocBuilder<CollectionViewCubit, CollectionViewState>(
            builder: (context, state){
              Collection? collection = state.collection;
              return Scaffold(
                  appBar: AppBar(
                      centerTitle: true,
                      title: Text(collection?.name ?? ''),
                      leading: IconButton(
                          icon: Icon(Icons.home),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
                          }),
                      actions: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              if(collection != null){
                                Navigator.pushNamed(context, editCollectionRoute, arguments: collection);
                              }
                              //Navigator.pop(context);
                            }),
                        IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () {
                              if(collection != null){
                                Navigator.pushNamed(context, viewPropertiesRoute, arguments: collection.id);
                              }
                              //Navigator.pop(context);
                            })
                      ]
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      if(collection != null){
                        Navigator.pushNamed(context, editItemRoute, arguments: ItemEditArgs(collectionId: collection.id!, item: null));
                      }
                    },
                    tooltip: 'Add new item',
                    backgroundColor: ColorsPalette.boyzone,
                    child: Icon(Icons.add, color: ColorsPalette.white),
                  ),
                body: collection != null ? Container(
                  padding: EdgeInsets.symmetric(horizontal: borderPadding),
                  child: Column(children: [
                    Text(collection.description ?? '')
                  ],),
                ) : loadingWidget(ColorsPalette.algalFuel)
              );
            })
    );
  }
}
