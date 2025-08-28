import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_iconpicker/extensions/list_extensions.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/attachments_repository.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/args_models/order_options_args.model.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/models/item.model.dart';
import 'package:rateit/models/property.model.dart';
import 'package:rateit/models/filter.model.dart';

part 'collection_view_state.dart';

class CollectionViewCubit extends Cubit<CollectionViewState> {
  final CollectionRepository _collectionRepository;
  final AttachmentsRepository _attachmentsRepository;
  final log = Logger('CollectionViewCubit');

  CollectionViewCubit() :
      _collectionRepository = CollectionRepository(),
      _attachmentsRepository = AttachmentsRepository(),
      super(CollectionViewInitial());

  void getCollection(int collectionId) async{
    emit(CollectionViewInitial());

    try{
      Collection? collection = await _collectionRepository.getCollectionById(collectionId);
      if(collection != null){
        emit(CollectionViewSuccess(collection, collection.items,
            OrderOptionsArgs("Name", "Desc"), null, null));
        if(collection.items.isNotNullOrEmpty){
          for(var item in collection.items!){
            if(item.attachments.isNotNullOrEmpty){
              try{
                var att = item.attachments!.first;
                Uint8List? imageSource = await _attachmentsRepository.getAttachmentById(att.id);
                att.source = imageSource;
                item.attachments![0] = att;
                emit(CollectionViewSuccess(collection, collection.items,
                    OrderOptionsArgs("Name", "Desc"), null, null));
              }
              catch(e){
                log.shout(e.toString());
                emit(CollectionViewSuccess(collection, collection.items,
                    OrderOptionsArgs("Name", "Desc"), null, null));
              }
            }
          }
        }
        emit(CollectionViewSuccess(collection, collection.items,
            OrderOptionsArgs("Name", "Desc"), null, null));
      }
    }catch(e){
      log.shout(e.toString());
      return emit(CollectionViewError(e.toString(), null, null, null, null, state.searchPattern));
    }
  }

  void updateCollectionDetails(Collection collection) async{
    emit(CollectionViewLoading(state.collection, state.filteredItems, state.orderOptions, state.filterModel, state.searchPattern));

    try{
      Collection updCollection = state.collection!.copyWith(name: collection.name, description: collection.description, icon: collection.icon);
      emit(CollectionViewSuccess(updCollection, state.filteredItems, state.orderOptions!, state.filterModel, state.searchPattern));
    }catch(e){
      log.shout(e.toString());
      return emit(CollectionViewError(e.toString(), state.collection, state.filteredItems, state.orderOptions, state.filterModel, state.searchPattern));
    }
  }

  void addNewItem(int collectionId, Item? item) async{
    emit(CollectionViewLoading(state.collection, state.filteredItems, state.orderOptions, state.filterModel, state.searchPattern));

    try{
      if(item != null) {
        Item newItem = item.copyWith(attachments: List.empty(growable: true));
        var att = await _attachmentsRepository.getCoverAttachment(item.id!);
        if(att != null){
          Uint8List? imageSource = await _attachmentsRepository.getAttachmentById(att.id);
          att.source = imageSource;
          newItem.attachments!.add(att);
        }
        state.collection!.items?.add(newItem);
        if(state.filterModel != null && isFilterCompliant(newItem, state.filterModel!)){
          state.filteredItems!.add(newItem);
        }
      }
      emit(CollectionViewSuccess(state.collection!, state.filteredItems, state.orderOptions!, state.filterModel, state.searchPattern));
    }
    catch(e){
      return emit(CollectionViewError(e.toString(), state.collection, state.filteredItems, state.orderOptions, state.filterModel, state.searchPattern));
    }
  }

  void updateItem(Item item, int position){
    emit(CollectionViewLoading(state.collection, state.filteredItems, state.orderOptions, state.filterModel, state.searchPattern));

    int filteredIndex = state.filteredItems!.indexWhere((i) => i.id == item.id);
    if(filteredIndex != -1){
      state.filteredItems![filteredIndex] = item;
    }else{
      if(state.filterModel != null && isFilterCompliant(item, state.filterModel!)){
        state.filteredItems!.add(item);
      }
    }

    int index = state.collection!.items!.indexWhere((i) => i.id == item.id);
    state.collection!.items![index] = item;

    emit(CollectionViewSuccess(state.collection!, state.filteredItems, state.orderOptions!, state.filterModel, state.searchPattern));
  }

  void removeItem(int id){
    emit(CollectionViewLoading(state.collection, state.filteredItems, state.orderOptions, state.filterModel, state.searchPattern));
    state.collection!.items!.removeWhere((i)=> i.id == id);
    state.filteredItems!.removeWhere((i)=> i.id == id);
    emit(CollectionViewSuccess(state.collection!, state.filteredItems, state.orderOptions!, state.filterModel, state.searchPattern));
  }

  void updateOrder(OrderOptionsArgs orderOptions){
    emit(CollectionViewLoading(state.collection, state.filteredItems, state.orderOptions, state.filterModel, state.searchPattern));
    if(state.filteredItems.isNotNullOrEmpty){
      switch(orderOptions.field){
        case "Rating": state.filteredItems!.sort((a, b) => a.rating!.compareTo(b.rating!));
        case "Date": state.filteredItems!.sort((a, b) => a.date!.millisecondsSinceEpoch.compareTo(b.date!.millisecondsSinceEpoch));
        case "Date Modified": state.filteredItems!.sort((a, b) => a.updatedDate!.millisecondsSinceEpoch.compareTo(b.updatedDate!.millisecondsSinceEpoch));
        default: state.filteredItems!.sort((a, b) => a.name!.toUpperCase().compareTo(b.name!.toUpperCase()));
      }
    }
    emit(CollectionViewSuccess(state.collection!, state.filteredItems, orderOptions, state.filterModel, state.searchPattern));
  }

  void applyFilters(FilterModel filterModel){
    emit(CollectionViewLoading(state.collection, state.filteredItems, state.orderOptions, state.filterModel, state.searchPattern));
    List<Item> items = List.empty(growable: true);
    for(var item in state.collection!.items!){
      if(isFilterCompliant(item, filterModel)){
        items.add(item);
      }
    }
    emit(CollectionViewSuccess(state.collection!, items, state.orderOptions!, filterModel, state.searchPattern));
  }

  bool isFilterCompliant(Item item, FilterModel filter){
    if(filter.rating != null){
      if(item.rating! < filter.rating!.start || item.rating! > filter.rating!.end){
        return false;
      }
    }

    if(filter.dateFrom != null && item.date!.isBefore(filter.dateFrom!)){
      return false;
    }

    if(filter.dateTo != null && item.date!.isAfter(filter.dateTo!)){
      return false;
    }

    if(filter.properties.isNotNullOrEmpty){
      if(item.properties.isNotNullOrEmpty){
        for(var prop in item.properties!){
          Property filterProperty = filter.properties!.firstWhere((p) => p.id == prop.id);
          if(filterProperty.isDropdown! || filterProperty.type! == "Checkbox"){
            String val = filterProperty.value!.toUpperCase();
            if(val != "ALL" && val != prop.value!.toUpperCase()){
              return false;
            }
          }else{
            if(filterProperty.type! == "Number" && (filterProperty.minValue != null || filterProperty.maxValue != null )){
              if(prop.value == null){return false;}
              else{
                double? value = double.tryParse(prop.value!);
                if(value! < filterProperty.minValue! || (filterProperty.maxValue != null && value > filterProperty.maxValue!)){
                  return false;
                }
              }
            }
            if(filterProperty.type == "Text" && filterProperty.value != null && filterProperty.value != ""){
              if(prop.value == null || prop.value!.toUpperCase() != filterProperty.value!.toUpperCase()){
                return false;
              }
            }
          }
        }
        return true;
      } else{
        return false;
      }
    }else{
      return true;
    }
  }

  void searchByName(String? nameValue){
    emit(CollectionViewSuccess(state.collection!, state.filteredItems, state.orderOptions!, state.filterModel, nameValue));
  }

  void resetSearch(){
    emit(CollectionViewSuccess(state.collection!, state.filteredItems, state.orderOptions!, state.filterModel, ""));
  }

  void resetFilters(){
    emit(CollectionViewSuccess(state.collection!, state.collection!.items, state.orderOptions!, null, state.searchPattern));
  }

}
