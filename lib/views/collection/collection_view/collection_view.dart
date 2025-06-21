
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/models/collection.model.dart';
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
        listener: (context, state){},
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

                              }
                              //Navigator.pop(context);
                            })
                      ]
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
