import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_iconpicker/extensions/list_extensions.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/attachment.model.dart';
import 'package:rateit/models/collection_item.model.dart';
import 'package:rateit/models/collection_property.model.dart';

part 'item_edit_state.dart';

class ItemEditCubit extends Cubit<ItemEditState> {
  final CollectionRepository _collectionRepository;
  ItemEditCubit() :
        _collectionRepository = CollectionRepository(),
        super(ItemEditInitial());

  void loadItem(int collectionId, CollectionItem? item) async{
    emit(ItemEditInitial());

    List<XFile> files = List.empty(growable: true);

    if(item == null){
      List<CollectionProperty>? properties = await _collectionRepository.getCollectionProperties(collectionId);
      CollectionItem newItem = CollectionItem(properties: properties);
      emit(ItemEditSuccess(newItem, files));
    }else{
      if(item.attachments.isNotNullOrEmpty){
        for(var att in item.attachments!){
          files.add(XFile.fromData(att.source!));
        }
      }

      emit(ItemEditSuccess(item, files));
    }
  }

  void updateRating(double rating){
    emit(ItemEditSuccess(state.item!.copyWith(rating: rating), state.files));
  }

  void addImage(CroppedFile file){
    emit(ItemEditLoading(state.item, state.files));
    List<XFile> files = state.files!;
    files.add(XFile(file.path));
    emit(ItemEditSuccess(state.item!, files));
  }


  void removeImage(int index){
    emit(ItemEditLoading(state.item, state.files));
    List<XFile> files = state.files!;
    files.removeAt(index);
    emit(ItemEditSuccess(state.item!, files));
  }

  void submitItem(int collectionId, CollectionItem item) async{
    emit(ItemEditLoading(item, state.files));

    try{
      CollectionItem? newItem = await _collectionRepository.createItem(collectionId, item);
      if(newItem!= null){
        if(item.properties != null){
          await _collectionRepository.updatePropertyValues(collectionId, newItem.id!, item.properties!);
        }
        if(state.files.isNotNullOrEmpty){
          await _collectionRepository.createAttachments(collectionId, newItem.id!, state.files!);
        }
        emit(ItemEditCreated(newItem, state.files));
      }
    }catch(e){
      return emit(ItemEditError(e.toString(), item, state.files));
    }
  }
}
