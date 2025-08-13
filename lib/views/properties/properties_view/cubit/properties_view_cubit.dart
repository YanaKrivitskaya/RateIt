import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/collection_property.model.dart';
import 'package:collection/collection.dart';

part 'properties_view_state.dart';

class PropertiesViewCubit extends Cubit<PropertiesViewState> {
  final CollectionRepository _collectionRepository;

  PropertiesViewCubit() :
        _collectionRepository = CollectionRepository(),
        super(PropertiesViewInitial());

  void getProperties(int collectionId) async{
    emit(PropertiesViewInitial());

    try{
      List<CollectionProperty>? properties = await _collectionRepository.getCollectionProperties(collectionId);
      emit(PropertiesViewSuccess(properties ?? List.empty(growable: true), false));
    }catch(e){
      return emit(PropertiesViewError(e.toString(), null, false));
    }
  }

  void updatePropertyList(CollectionProperty property) async{
    emit(PropertiesViewLoading(state.properties, state.hasEdits));

    try{
      CollectionProperty? prop = state.properties!.firstWhereOrNull((p) => p.id == property.id);
      if(prop != null){
        int index = state.properties!.indexOf(prop);
        state.properties![index] = property;
      }else{
        state.properties!.add(property);
      }
      emit(PropertiesViewSuccess(state.properties!, state.hasEdits));
    }catch(e){
      return emit(PropertiesViewError(e.toString(), null, state.hasEdits));
    }
  }

  void removeProperty(int id){
    emit(PropertiesViewLoading(state.properties, state.hasEdits));

    state.properties!.removeWhere((p)=> p.id == id);
    emit(PropertiesViewSuccess(state.properties!, state.hasEdits));
  }

  void editOrder(int oldIndex, int newIndex){
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final CollectionProperty item = state.properties!.removeAt(oldIndex);
    state.properties!.insert(newIndex, item);
    emit(PropertiesViewSuccess(state.properties!, true));
  }

  void saveOrder(int collectionId) async{
    emit(PropertiesViewLoading(state.properties, state.hasEdits));
    for(var prop in state.properties!){
      try{
        int index = state.properties!.indexOf(prop);
        CollectionProperty property = prop.copyWith(order: index);
        await _collectionRepository.updateProperty(collectionId, property);
      }
      catch(e){
        return emit(PropertiesViewError(e.toString(), state.properties!, state.hasEdits));
      }
    }
    emit(PropertiesViewSuccess(state.properties!, false));
  }
}
