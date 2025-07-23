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
        emit(CollectionViewSuccess(collection, OrderOptionsArgs("Name", "Desc")));
      }
    }catch(e){
      print(e.toString());
      return emit(CollectionViewError(e.toString(), null, null));
    }
  }

  void updateCollectionDetails(Collection collection) async{
    emit(CollectionViewLoading(state.collection, state.orderOptions));

    try{
      Collection updCollection = state.collection!.copyWith(name: collection.name, description: collection.description, icon: collection.icon);
      emit(CollectionViewSuccess(updCollection, state.orderOptions));
    }catch(e){
      print(e.toString());
      return emit(CollectionViewError(e.toString(), state.collection, state.orderOptions));
    }
  }

  void addNewItem(int collectionId, CollectionItem? item) async{
    emit(CollectionViewLoading(state.collection, state.orderOptions));

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
      emit(CollectionViewSuccess(state.collection!, state.orderOptions));
    }
    catch(e){
      print(e.toString());
      return emit(CollectionViewError(e.toString(), state.collection, state.orderOptions));
    }
  }

  void updateItem(CollectionItem item, int position){
    emit(CollectionViewLoading(state.collection, state.orderOptions));

    state.collection!.items![position] = item;

    emit(CollectionViewSuccess(state.collection!, state.orderOptions));
  }

  void removeItem(int id){
    emit(CollectionViewLoading(state.collection, state.orderOptions));
    state.collection!.items!.removeWhere((i)=> i.id == id);
    emit(CollectionViewSuccess(state.collection!, state.orderOptions));
  }

  void updateOrder(OrderOptionsArgs orderOptions){
    emit(CollectionViewLoading(state.collection, state.orderOptions));
    if(state.collection!.items.isNotNullOrEmpty){
      switch(orderOptions.field){
        case "Rating": state.collection!.items!.sort((a, b) => a.rating!.compareTo(b.rating!));
        case "Date": state.collection!.items!.sort((a, b) => a.date!.millisecondsSinceEpoch.compareTo(b.date!.millisecondsSinceEpoch));
        case "Date Modified": state.collection!.items!.sort((a, b) => a.updatedDate!.millisecondsSinceEpoch.compareTo(b.updatedDate!.millisecondsSinceEpoch));
        default: state.collection!.items!.sort((a, b) => a.name!.toUpperCase().compareTo(b.name!.toUpperCase()));
      }
    }
    emit(CollectionViewSuccess(state.collection!, orderOptions));
  }

}
