import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_iconpicker/extensions/list_extensions.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/attachment.model.dart';
import 'package:rateit/models/collection.model.dart';

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
}
