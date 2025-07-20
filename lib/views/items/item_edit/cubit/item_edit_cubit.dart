import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_iconpicker/extensions/list_extensions.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/collection_item.model.dart';
import 'package:rateit/models/collection_property.model.dart';
import 'package:rateit/models/view_models/attachment_view.model.dart';

part 'item_edit_state.dart';

class ItemEditCubit extends Cubit<ItemEditState> {
  final CollectionRepository _collectionRepository;
  ItemEditCubit() :
        _collectionRepository = CollectionRepository(),
        super(ItemEditInitial());

  void loadItem(int collectionId, CollectionItem? item) async{
    emit(ItemEditInitial());

    List<AttachmentViewModel> files = List.empty(growable: true);
    List<CollectionProperty>? properties = await _collectionRepository.getCollectionProperties(collectionId);

    if(item == null){
      CollectionItem newItem = CollectionItem(properties: properties);
      emit(ItemEditSuccess(newItem, files));
    }else{
      if(item.attachments != null){
        for(var att in item.attachments!){
          if(att.source == null){
            Uint8List? imageSource = await _collectionRepository.getAttachmentById(collectionId, att.id);
            //att.source = imageSource;
            if(imageSource != null){
              files.add(AttachmentViewModel(id: att.id!, source: imageSource, state: AttState.keep));
            }
          }else{
            files.add(AttachmentViewModel(id: att.id!, source: att.source, state: AttState.keep));
          }
          //item.attachments![index] = att;
        }
      }
      if(item.properties != null && properties.isNotNullOrEmpty){
        for(var prop in properties!){
          var p = item.properties!.where((p) => p.id == prop.id);
          if(p.isEmpty){
            item.properties!.add(prop);
          }
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
    List<AttachmentViewModel> files = state.files!;
    files.add(AttachmentViewModel(id: null, file: XFile(file.path), state: AttState.create));
    emit(ItemEditSuccess(state.item!, files));
  }


  void removeImage(int index){
    emit(ItemEditLoading(state.item, state.files));
    List<AttachmentViewModel> files = state.files!;
    if(files[index].id != null){
      files[index].state = AttState.delete;
    }else{

      files.removeAt(index);
    }
    emit(ItemEditSuccess(state.item!, files));
  }

  void submitItem(int collectionId, CollectionItem item) async{
    emit(ItemEditLoading(item, state.files));

    try{
      CollectionItem? newItem = item.id != null
          ? await _collectionRepository.updateItem(collectionId, item)
          : await _collectionRepository.createItem(collectionId, item);

      List<CollectionProperty> newProps = List.empty(growable: true);
      List<CollectionProperty> updProps = List.empty(growable: true);

      if(newItem != null){
        if(item.properties != null){
          for(var prop in item.properties!){
            if(prop.valueId != null){
              updProps.add(prop);
            }else{
              newProps.add(prop);
            }
          }
          await _collectionRepository.updatePropertyValues(collectionId, updProps);
          await _collectionRepository.createPropertyValues(collectionId, newItem.id!, newProps);
        }

        if(state.files.isNotNullOrEmpty){
          List<XFile> newFiles = List.empty(growable: true);

          for(var att in state.files!){
            if(att.state == AttState.create){
              newFiles.add(att.file!);
            }
            if(att.state == AttState.delete){
              await _collectionRepository.deleteAttachment(collectionId, att.id!);
            }
          }
          if(newFiles.isNotEmpty){
            await _collectionRepository.createAttachments(collectionId, newItem.id!, newFiles);
          }
        }
        emit(ItemEditCreated(newItem, state.files));
      }else{
        emit(ItemEditError('Oops, something went wrong. Try again!', item, state.files));
      }

    }catch(e){
      return emit(ItemEditError(e.toString(), item, state.files));
    }
  }
}
