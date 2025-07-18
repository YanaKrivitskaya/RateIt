import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/collection_item.model.dart';

part 'item_view_state.dart';

class ItemViewCubit extends Cubit<ItemViewState> {
  final CollectionRepository _collectionRepository;

  ItemViewCubit() :
        _collectionRepository = CollectionRepository(),
        super(ItemViewInitial());

  void getItem(int collectionId, int itemId) async{
    emit(ItemViewLoading(state.item, state.hasEdit));

    try{
      CollectionItem? item = await _collectionRepository.getItemById(collectionId, itemId);
      if(item != null){
        if(item.attachments != null){
          for(var att in item.attachments!){
            var index = item.attachments!.indexOf(att);
            Uint8List? imageSource = await _collectionRepository.getAttachmentById(collectionId, att.id);
            att.source = imageSource;
            item.attachments![index] = att;
          }
        }
        emit(ItemViewSuccess(item, state.hasEdit));
      }
    }catch(e){
      print(e.toString());
      return emit(ItemViewError(e.toString(), null, state.hasEdit));
    }
  }

  void setEditState(){
    emit(ItemViewSuccess(state.item!, true));
  }
  
  void deleteItem(int id) async{
    emit(ItemViewLoading(state.item, state.hasEdit));

    try{
      await _collectionRepository.deleteItem(id);
      emit(ItemViewDelete(id));
    }catch(e){
      print(e.toString());
      return emit(ItemViewError(e.toString(), null, state.hasEdit));
    }

  }

}
