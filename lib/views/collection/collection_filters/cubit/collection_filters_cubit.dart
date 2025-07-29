import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/models/collection_item.model.dart';
import 'package:rateit/models/collection_property.model.dart';
import 'package:collection/collection.dart';
import 'package:rateit/models/filter.model.dart';

part 'collection_filters_state.dart';

class CollectionFiltersCubit extends Cubit<CollectionFiltersState> {

  final CollectionRepository _collectionRepository;

  CollectionFiltersCubit() :
        _collectionRepository = CollectionRepository(),
        super(CollectionFiltersInitial());
  
  void initFilters(int collectionId, FilterModel? filterModel) async{
    emit(CollectionFiltersInitial());
    if(filterModel != null){
      emit(CollectionFiltersSuccess(collectionId, filterModel));
    }else{
      emit(CollectionFiltersLoading(collectionId, filterModel));
      try{
        List<CollectionProperty>? properties = await _collectionRepository.getCollectionProperties(collectionId);
        FilterModel model = FilterModel(rating: RangeValues(0, 5), properties: properties!.where((p) => p.isFilter!).toList());
        return emit(CollectionFiltersSuccess(collectionId, model));
      }catch(e){
        print(e.toString());
        return emit(CollectionFiltersError(e.toString(), state.collectionId, filterModel));
      }
    }
  }
}
