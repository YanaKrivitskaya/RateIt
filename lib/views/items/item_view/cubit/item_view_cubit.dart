import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/attachments_repository.dart';
import 'package:rateit/database/items_repository.dart';
import 'package:rateit/models/item.model.dart';

part 'item_view_state.dart';

class ItemViewCubit extends Cubit<ItemViewState> {
  final ItemsRepository _itemsRepository;
  final AttachmentsRepository _attachmentsRepository;

  ItemViewCubit() :
        _itemsRepository = ItemsRepository(),
        _attachmentsRepository = AttachmentsRepository(),
        super(ItemViewInitial());

  void getItem(int itemId) async{
    emit(ItemViewLoading(state.item, state.hasEdit));

    try{
      Item? item = await _itemsRepository.getItemById(itemId);
      if(item != null){
        if(item.attachments != null){
          for(var att in item.attachments!){
            var index = item.attachments!.indexOf(att);
            Uint8List? imageSource = await _attachmentsRepository.getAttachmentById(att.id);
            att.source = imageSource;
            item.attachments![index] = att;
          }
        }
        emit(ItemViewSuccess(item, state.hasEdit));
      }
    }catch(e){
      return emit(ItemViewError(e.toString(), null, state.hasEdit));
    }
  }

  void setEditState(){
    emit(ItemViewSuccess(state.item!, true));
  }
  
  void deleteItem(int id) async{
    emit(ItemViewLoading(state.item, state.hasEdit));

    try{
      await _itemsRepository.deleteItem(id);
      emit(ItemViewDelete(id));
    }catch(e){
      return emit(ItemViewError(e.toString(), null, state.hasEdit));
    }

  }

}
