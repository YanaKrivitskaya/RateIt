import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_iconpicker/extensions/list_extensions.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/args_models/order_options_args.model.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/models/collection_item.model.dart';
import 'package:collection/collection.dart';

part 'collection_view_state.dart';

class CollectionViewCubit extends Cubit<CollectionViewState> {
  final CollectionRepository _collectionRepository;

  CollectionViewCubit() :
      _collectionRepository = CollectionRepository(),
      super(CollectionViewInitial());

  void getCollection(int collectionId) async{
    emit(CollectionViewInitial());

    try{
      Collection? collection = await _collectionRepository.getCollectionById(collectionId);
      if(collection != null){
        if(collection.items.isNotNullOrEmpty){
          for(var item in collection.items!){
            if(item.attachments.isNotNullOrEmpty){
              var att = item.attachments!.first;
              Uint8List? imageSource = await _collectionRepository.getAttachmentById(collectionId, att.id);
              att.source = imageSource;
              item.attachments![0] = att;
            }
          }
        }
        emit(CollectionViewSuccess(collection, collection.items,
            OrderOptionsArgs("Name", "Desc")));
      }
    }catch(e){
      print(e.toString());
      return emit(CollectionViewError(e.toString(), null, null, null));
    }
  }

  void updateCollectionDetails(Collection collection) async{
    emit(CollectionViewLoading(state.collection, state.filteredItems, state.orderOptions));

    try{
      Collection updCollection = state.collection!.copyWith(name: collection.name, description: collection.description, icon: collection.icon);
      emit(CollectionViewSuccess(updCollection, state.filteredItems, state.orderOptions!));
    }catch(e){
      print(e.toString());
      return emit(CollectionViewError(e.toString(), state.collection, state.filteredItems, state.orderOptions));
    }
  }

  void updateCollectionItems(Collection collection) async{
    emit(CollectionViewSuccess(state.collection!, collection.items, state.orderOptions!));
  }

  void addNewItem(int collectionId, CollectionItem? item) async{
    emit(CollectionViewLoading(state.collection, state.filteredItems, state.orderOptions));

    try{
      if(item != null) {
        CollectionItem newItem = item.copyWith(attachments: List.empty(growable: true));
        var att = await _collectionRepository.getCoverAttachment(item.id!);
        if(att != null){
          Uint8List? imageSource = await _collectionRepository.getAttachmentById(collectionId, att.id);
          att.source = imageSource;
          newItem.attachments!.add(att);
        }
        state.collection!.items?.add(newItem);
      }
      emit(CollectionViewSuccess(state.collection!, state.collection!.items!, state.orderOptions!));
    }
    catch(e){
      print(e.toString());
      return emit(CollectionViewError(e.toString(), state.collection, state.filteredItems, state.orderOptions));
    }
  }

  void updateItem(CollectionItem item, int position){
    emit(CollectionViewLoading(state.collection, state.filteredItems, state.orderOptions));

    state.filteredItems![position] = item;
    int index = state.collection!.items!.indexWhere((i) => i.id == item.id);
    state.collection!.items![index] = item;

    emit(CollectionViewSuccess(state.collection!, state.filteredItems, state.orderOptions!));
  }

  void removeItem(int id){
    emit(CollectionViewLoading(state.collection, state.filteredItems, state.orderOptions));
    state.collection!.items!.removeWhere((i)=> i.id == id);
    emit(CollectionViewSuccess(state.collection!, state.collection!.items!, state.orderOptions!));
  }

  void updateOrder(OrderOptionsArgs orderOptions){
    emit(CollectionViewLoading(state.collection, state.filteredItems, state.orderOptions));
    if(state.filteredItems.isNotNullOrEmpty){
      switch(orderOptions.field){
        case "Rating": state.filteredItems!.sort((a, b) => a.rating!.compareTo(b.rating!));
        case "Date": state.filteredItems!.sort((a, b) => a.date!.millisecondsSinceEpoch.compareTo(b.date!.millisecondsSinceEpoch));
        case "Date Modified": state.filteredItems!.sort((a, b) => a.updatedDate!.millisecondsSinceEpoch.compareTo(b.updatedDate!.millisecondsSinceEpoch));
        default: state.filteredItems!.sort((a, b) => a.name!.toUpperCase().compareTo(b.name!.toUpperCase()));
      }
    }
    emit(CollectionViewSuccess(state.collection!, state.filteredItems, orderOptions));
  }

  void searchByName(String? nameValue){
    //emit(CollectionViewLoading(state.collection, state.orderOptions));
    if(nameValue != null){
      if(nameValue != ""){
        List<CollectionItem> items = state.filteredItems!.where((i) => i.name!.toUpperCase().contains(nameValue.toUpperCase())).toList();
        emit(CollectionViewSuccess(state.collection!, items, state.orderOptions!));
      }else{
        emit(CollectionViewSuccess(state.collection!, state.collection!.items, state.orderOptions!));
      }
    }
  }

  void resetFilters(){
    emit(CollectionViewSuccess(state.collection!, state.collection!.items, state.orderOptions!));
  }

}
