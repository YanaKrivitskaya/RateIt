import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_iconpicker/extensions/list_extensions.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/attachments_repository.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/database/items_repository.dart';
import 'package:rateit/database/properties_repository.dart';
import 'package:rateit/models/item.model.dart';
import 'package:rateit/models/property.model.dart';
import 'package:rateit/models/view_models/attachment_view.model.dart';
import 'package:collection/collection.dart';

part 'item_edit_state.dart';

class ItemEditCubit extends Cubit<ItemEditState> {
  final CollectionRepository _collectionRepository;
  final PropertiesRepository _propertiesRepository;
  final ItemsRepository _itemsRepository;
  final AttachmentsRepository _attachmentsRepository;

  ItemEditCubit() :
        _collectionRepository = CollectionRepository(),
        _propertiesRepository = PropertiesRepository(),
        _itemsRepository = ItemsRepository(),
        _attachmentsRepository = AttachmentsRepository(),
        super(ItemEditInitial());

  void loadItem(int collectionId, Item? item) async{
    emit(ItemEditInitial());

    List<AttachmentViewModel> files = List.empty(growable: true);
    List<Property>? properties = await _collectionRepository.getCollectionProperties(collectionId);

    if (properties != null){
      for(var prop in properties){
        if(!prop.isDropdown! && prop.type == "Text"){
          try{
            List<String>? values = await _propertiesRepository.getPropertyValuesDistinct(prop.id!);
            if(values != null){
              int index = properties.indexWhere((p) => p.id == prop.id);
              properties[index] = prop.copyWith(dropdownOptions: values);
            }
          }catch(e){
            continue;
          }
        }
        if(prop.isDropdown! && prop.dropdownOptions != null){
          prop.dropdownOptions!.insert(0, "N/A");
        }
      }
    }

    if(item == null){
      Item newItem = Item(properties: properties);
      emit(ItemEditSuccess(newItem, files));
    }else{
      if(item.attachments != null){
        for(var att in item.attachments!){
          if(att.source == null){
            Uint8List? imageSource = await _attachmentsRepository.getAttachmentById(att.id);
            if(imageSource != null){
              files.add(AttachmentViewModel(id: att.id!, source: imageSource, state: AttState.keep));
            }
          }else{
            files.add(AttachmentViewModel(id: att.id!, source: att.source, state: AttState.keep));
          }
        }
      }
      if(item.properties != null && properties.isNotNullOrEmpty){
        for(var prop in properties!){
          Property? p = item.properties!.firstWhereOrNull((p) => p.id == prop.id);
          if(p == null){
            item.properties!.add(prop);
          }else{
            if(prop.dropdownOptions != null){
              int index = item.properties!.indexWhere((p) => p.id == prop.id);
              item.properties![index] = p.copyWith(dropdownOptions: prop.dropdownOptions);
            }
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

  void submitItem(int collectionId, Item item) async{
    emit(ItemEditLoading(item, state.files));

    try{
      Item? newItem = item.id != null
          ? await _itemsRepository.updateItem(item)
          : await _itemsRepository.createItem(collectionId, item);

      List<Property> newProps = List.empty(growable: true);
      List<Property> updProps = List.empty(growable: true);

      if(newItem != null){
        if(item.properties != null){
          for(var prop in item.properties!){
            if(prop.valueId != null){
              updProps.add(prop);
            }else{
              newProps.add(prop);
            }
          }
          await _itemsRepository.updatePropertyValues(newItem.id!, updProps);
          await _itemsRepository.createPropertyValues(newItem.id!, newProps);
        }

        if(state.files.isNotNullOrEmpty){
          List<XFile> newFiles = List.empty(growable: true);

          for(var att in state.files!){
            if(att.state == AttState.create){
              newFiles.add(att.file!);
            }
            if(att.state == AttState.delete){
              await _attachmentsRepository.deleteAttachment(att.id!);
            }
          }
          if(newFiles.isNotEmpty){
            await _attachmentsRepository.createAttachments(newItem.id!, newFiles);
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
