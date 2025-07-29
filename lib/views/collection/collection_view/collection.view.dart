
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_iconpicker/extensions/list_extensions.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/main.dart';
import 'package:rateit/models/args_models/filter_args.model.dart';
import 'package:rateit/models/args_models/order_options_args.model.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/models/args_models/item_args.model.dart';
import 'package:rateit/models/collection_item.model.dart';
import 'package:rateit/models/filter.model.dart';
import 'package:rateit/views/collection/collection_view/collection_order.dialog.dart';
import 'package:rateit/views/collection/collection_view/cubit/collection_view_cubit.dart';

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
            var duration = Duration(seconds: 3);
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
              List<CollectionItem>? items = (state.searchPattern != null && state.searchPattern != "")
                  ? state.filteredItems?.where((i) => i.name!.toUpperCase().contains(state.searchPattern!.toUpperCase())).toList()
                  : state.filteredItems;
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
                            icon: Icon(Icons.filter_alt),
                            onPressed: (){
                              if(collection != null && collection.items.isNotNullOrEmpty){
                                Navigator.pushNamed(context, collectionFiltersRoute, arguments: FilterArgsModel(collection.id!, state.filterModel)).then((value)
                                {
                                  if(value is FilterModel){
                                    context.read<CollectionViewCubit>().applyFilters(value);
                                  }else if(value == null){
                                    context.read<CollectionViewCubit>().resetFilters();
                                  }
                                });
                              }
                            }),
                        IconButton(
                            icon: Icon(Icons.sort),
                            onPressed: (){
                              if(collection != null){
                                showDialog(
                                    barrierDismissible: false, context: context, builder: (_) =>
                                    CollectionOrderDialog()
                                ).then((val) {
                                  if(val is OrderOptionsArgs){
                                    context.read<CollectionViewCubit>().updateOrder(val);
                                  }
                                });
                              }
                            }),
                        IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () {
                              if(collection != null){
                                Navigator.pushNamed(context, collectionSettingsRoute, arguments: collection).then((value)
                                {
                                  if(value != null){
                                    if(value is Collection){
                                      context.read<CollectionViewCubit>().updateCollectionDetails(value);
                                    }else if(value is int){
                                      Future.delayed(const Duration(seconds: 2), () {
                                        Navigator.pop(context, value);
                                      });
                                    }
                                  }
                                });
                              }
                            })
                      ]
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      if(collection != null){
                        Navigator.pushNamed(context, editItemRoute, arguments: ItemEditArgs(collectionId: collection.id!, item: null)).then((value)
                        {
                          if(value != null && value is CollectionItem){
                            context.read<CollectionViewCubit>().addNewItem(state.collection!.id!, value);
                          }
                        });
                      }
                    },
                    tooltip: 'Add new item',
                    backgroundColor: ColorsPalette.boyzone,
                    child: Icon(Icons.add, color: ColorsPalette.white),
                  ),
                body: collection != null ? Container(
                  padding: EdgeInsets.only(left: viewPadding, right: viewPadding, bottom: formBottomPadding),
                  child: Column(children: [
                    Text(collection.description ?? ''),
                    FormBuilderTextField(
                        name: "name",
                        decoration: const InputDecoration(labelText: 'Search by name', icon: Icon(Icons.search)),
                        onChanged: (val){
                          context.read<CollectionViewCubit>().searchByName(val);
                        },
                    ),
                    items.isNotNullOrEmpty ? SingleChildScrollView(
                        child: Container(constraints: BoxConstraints(
                          maxHeight: scrollViewHeightLg,
                        ), child:
                          ListView.builder(
                            shrinkWrap: true,
                            reverse: state.orderOptions != null && state.orderOptions!.direction == "Asc",
                            //physics: NeverScrollableScrollPhysics(),
                            itemCount: items!.length,
                            itemBuilder: (context, position){
                              final CollectionItem item = items[position];
                              final att = item.attachments?.firstOrNull;
                              return Card(
                                child: InkWell(
                                    onTap: (){
                                      Navigator.pushNamed(context, viewItemRoute, arguments: ItemViewArgs(collectionId: collection.id!, itemId: item.id!)).then((value)
                                      {
                                        if(value != null){
                                          if(value is CollectionItem){
                                            context.read<CollectionViewCubit>().updateItem(value, position);
                                          }else if(value is int){
                                            context.read<CollectionViewCubit>().removeItem(value);
                                          }
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: width30,
                                      child: Row(children: [
                                        Container(
                                            width: width30,
                                            child: att?.source != null ? Card(
                                              child: SizedBox(
                                                height: width30,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(9.0),
                                                  child: Image.memory(att!.source!)
                                                ) ,
                                              )
                                            ) : Card(
                                              color: ColorsPalette.blueGrey,
                                              child: SizedBox(
                                                height: width30,
                                                child: Icon(Icons.image, color: Colors.white, size: iconSize),
                                              ),
                                            )
                                        ),
                                        Expanded(child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: borderPadding),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [
                                            Text(item.name!, style: appTextStyle(fontSize: accentFontSize), overflow: TextOverflow.ellipsis,),
                                            Flex(direction: Axis.horizontal, mainAxisSize: MainAxisSize.min, children: [RatingBarIndicator(
                                              rating: item.rating ?? 0,
                                              itemBuilder: (context, index) => Icon(
                                                Icons.star,
                                                color: ColorsPalette.flirtatious,
                                              ),
                                              itemCount: 5,
                                              itemSize: starSize,
                                              direction: Axis.horizontal,
                                            )]),
                                            Text('${DateFormat.yMMMd().format(item.date!)}')
                                          ],),
                                        )),
                                      ]),
                                    )
                                ),
                              );
                            },
                          )
                        )
                    ) : Center(child: Text('No items')),
                  ],),
                ) : loadingWidget(ColorsPalette.algalFuel)
              );
            })
    );
  }
}
