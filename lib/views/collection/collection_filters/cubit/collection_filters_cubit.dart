import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/models/collection_item.model.dart';
import 'package:rateit/models/collection_property.model.dart';
import 'package:collection/collection.dart';

part 'collection_filters_state.dart';

class CollectionFiltersCubit extends Cubit<CollectionFiltersState> {

  final CollectionRepository _collectionRepository;

  CollectionFiltersCubit(Collection collection) :
        _collectionRepository = CollectionRepository(),
        super(CollectionFiltersSuccess(collection, null));

  void getProperties() async{
    emit(CollectionFiltersLoading(state.collection, null));

    try{
      List<CollectionProperty>? properties = await _collectionRepository.getCollectionProperties(state.collection.id!);
      if(properties != null){
        emit(CollectionFiltersSuccess(state.collection, properties.where((p) => p.isFilter!).toList()));
      }else{
        emit(CollectionFiltersSuccess(state.collection, null));
      }
    }catch(e){
      print(e.toString());
      return emit(CollectionFiltersError(e.toString(), state.collection, null));
    }
  }

  void applyFilters(Collection collection, List<CollectionProperty>? properties, DateTime? date, RangeValues? ratingRange){
    emit(CollectionFiltersLoading(state.collection, state.properties));

    try{
      List<CollectionItem> items = List.empty(growable: true);

      if(ratingRange != null){
        items.addAll(collection.items!.where((i)=> i.rating! >= ratingRange.start && i.rating! <= ratingRange.end));
      }else{
        items.addAll(collection.items!);
      }

      if(properties != null){
        for(var prop in properties){
          if(prop.isDropdown! && prop.value != null && prop.value!.isNotEmpty){
            if(prop.value != "All"){
              items.removeWhere((i) => (i.properties!.firstWhereOrNull((p) => p.id == prop.id) == null));
              items.removeWhere((i) => i.properties!.firstWhere((p) => p.id == prop.id).value != prop.value);
            }
          }else{
            if(prop.type == "Number" && (prop.minValue != null || prop.maxValue != null)){
              items.removeWhere((i) => (i.properties!.firstWhereOrNull((p) => p.id == prop.id) == null));
              if(prop.minValue != null){
                items.removeWhere((i) =>
                int.tryParse(i.properties!.firstWhere((p) => p.id == prop.id).value!)! < prop.minValue!);
              }
              if(prop.maxValue != null){
                items.removeWhere((i) =>
                int.tryParse(i.properties!.firstWhere((p) => p.id == prop.id).value!)! > prop.maxValue!);
              }
            }
            if(prop.type == "Text" && prop.value != null && prop.value!.isNotEmpty){
              items.removeWhere((i) => (i.properties!.firstWhereOrNull((p) => p.id == prop.id) == null));
              items.removeWhere((i) => i.properties!.firstWhere((p) => p.id == prop.id).value != prop.value);
            }
          }
        }
      }

      emit(CollectionFiltersApplied(state.collection.copyWith(items: items), state.properties));
    }catch(e){
      print(e.toString());
      return emit(CollectionFiltersError(e.toString(), state.collection, state.properties));
    }
  }

}
