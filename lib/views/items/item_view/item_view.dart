

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/extensions/list_extensions.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/main.dart';
import 'package:rateit/models/args_models/item_args.model.dart';
import 'package:rateit/models/attachment.model.dart';
import 'package:rateit/models/collection_item.model.dart';
import 'package:rateit/models/collection_property.model.dart';
import 'package:rateit/views/items/item_view/cubit/item_view_cubit.dart';
import 'package:rateit/views/items/item_view/items_image_provider.dart';

class ItemView extends StatefulWidget {
  final int collectionId;
  final int itemId;
  const ItemView({required this.collectionId, required this.itemId, super.key});

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  late ItemsImageProvider itemImageProvider;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemViewCubit, ItemViewState>(
      listener: (context, state){
        if(state is ItemViewLoading){
          var duration = Duration(days: 1);
          globalScaffoldMessenger.currentState!
            ..hideCurrentSnackBar()
            ..showSnackBar(customSnackBar(SnackBarState.loading, null, duration));
        }
        if(state is ItemViewInitial || state is ItemViewSuccess){
          globalScaffoldMessenger.currentState!
              .hideCurrentSnackBar();
        }
        if(state is ItemViewError){
          var duration = Duration(days: 1);
          globalScaffoldMessenger.currentState!
            ..hideCurrentSnackBar()
            ..showSnackBar(customSnackBar(SnackBarState.error, state.error, duration));
        }
      },
        child: BlocBuilder<ItemViewCubit, ItemViewState>(
        builder: (context, state){
          CollectionItem? item = state.item;
          List<CollectionProperty>? properties = item?.properties;
          return Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context, state.hasEdit ? state.item : null);
                    }),
                actions: [
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        if(item != null){
                          context.read<ItemViewCubit>().setEditState();
                          Navigator.pushNamed(context, editItemRoute, arguments: ItemEditArgs(collectionId: widget.collectionId, item: item)).then((value)
                          {
                            if(value != null && value is CollectionItem){
                              context.read<ItemViewCubit>().getItem(widget.collectionId, value.id!);
                            }
                          });
                        }
                        //Navigator.pop(context);
                      }),
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        if(item != null){
                          //Navigator.pushNamed(context, viewPropertiesRoute, arguments: collection.id);
                        }
                        //Navigator.pop(context);
                      })
                ]
            ),
          body: item != null ? Container(
            padding: EdgeInsets.only(left: viewPadding, right: viewPadding, bottom: formBottomPadding),
              child: SingleChildScrollView(
                child: Column(children: [
                  Text(item.name!, style: appTextStyle(fontSize: accentFontSize),),
                  Text(item.description ?? ''),
                  (item.attachments.isNotNullOrEmpty) ? SizedBox(
                    height: width30,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:[
                            ...List.generate(item.attachments!.length, (int index) {
                              Attachment att = item.attachments![index];
                              return Row(children: [
                              InkWell(
                                child: Image.memory(att.source!),
                                onTap: () {
                                  itemImageProvider = ItemsImageProvider(attachments: item.attachments!, initialIndex: index);
                                  showImageViewerPager(context, itemImageProvider);
                                }
                                ),
                                SizedBox(width: sizerWidthsm),

                              ],);
                            })
                          ]
                      )
                  )  : SizedBox(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Text('Rating:', style: appTextStyle(weight: FontWeight.bold, fontSize: fontSize17)),
                    Flex(direction: Axis.horizontal, mainAxisSize: MainAxisSize.min, children: [RatingBarIndicator(
                      rating: item.rating!,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: ColorsPalette.flirtatious,
                      ),
                      itemCount: 5,
                      itemSize: starSize,
                      direction: Axis.horizontal,
                    )]),
                    Text(item.rating!.toString(), style: appTextStyle(fontSize: fontSize17))
                  ],),
                  SizedBox(height: sizerHeightsm,),
                  properties != null ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: properties.length,
                      itemBuilder: (BuildContext context, int index) {
                        var property = properties[index];
                        String propertyName = property.name!;
                        return Column(children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('$propertyName:', style: appTextStyle(weight: FontWeight.bold, fontSize: fontSize17)),
                            Text('${property.value!} ${property.comment ?? ''}', style: appTextStyle(fontSize: fontSize17))
                          ],),
                          SizedBox(height: sizerHeightsm,)
                        ],);

                      }
                  ) : SizedBox()
                ],),
              )
          ) : loadingWidget(ColorsPalette.algalFuel)
          );
        })
    );
  }

}

