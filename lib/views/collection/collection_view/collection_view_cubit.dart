import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_iconpicker/extensions/list_extensions.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
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
        emit(CollectionViewSuccess(collection));
      }
    }catch(e){
      print(e.toString());
      return emit(CollectionViewError(e.toString(), null));
    }
  }

  void updateCollectionDetails(Collection collection) async{
    emit(CollectionViewLoading(state.collection));

    try{
      Collection updCollection = state.collection!.copyWith(name: collection.name, description: collection.description, icon: collection.icon);
      emit(CollectionViewSuccess(updCollection));
    }catch(e){
      print(e.toString());
      return emit(CollectionViewError(e.toString(), state.collection));
    }
  }

  void addNewItem(int collectionId, CollectionItem? item) async{
    emit(CollectionViewLoading(state.collection));

    try{
      if(item != null) {
        CollectionItem newItem = item.copyWith(attachments: List.empty(growable: true));
        var att = await _collectionRepository.getCoverAttachment(item.id!);
        if(att != null){
          Uint8List? imageSource = await _collectionRepository.getAttachmentById(collectionId, att.id);
          att.source = imageSource;
          newItem.attachments!.add(att);
          state.collection!.items?.add(newItem);
        }
      }
      emit(CollectionViewSuccess(state.collection!));
    }
    catch(e){
      print(e.toString());
      return emit(CollectionViewError(e.toString(), state.collection));
    }
  }

  void updateItem(CollectionItem item, int position){
    emit(CollectionViewLoading(state.collection));

    state.collection!.items![position] = item;

    emit(CollectionViewSuccess(state.collection!));
  }

  void removeItem(int id){
    emit(CollectionViewLoading(state.collection));
    state.collection!.items!.removeWhere((i)=> i.id == id);
    emit(CollectionViewSuccess(state.collection!));
  }

}
