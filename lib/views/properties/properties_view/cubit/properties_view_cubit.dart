import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/database/properties_repository.dart';
import 'package:rateit/models/property.model.dart';
import 'package:collection/collection.dart';

part 'properties_view_state.dart';

class PropertiesViewCubit extends Cubit<PropertiesViewState> {
  final CollectionRepository _collectionRepository;
  final PropertiesRepository _propertiesRepository;

  PropertiesViewCubit() :
        _collectionRepository = CollectionRepository(),
        _propertiesRepository = PropertiesRepository(),
        super(PropertiesViewInitial());

  void getProperties(int collectionId) async{
    emit(PropertiesViewInitial());

    try{
      List<Property>? properties = await _collectionRepository.getCollectionProperties(collectionId);
      emit(PropertiesViewSuccess(properties ?? List.empty(growable: true), false));
    }catch(e){
      return emit(PropertiesViewError(e.toString(), null, false));
    }
  }

  void updatePropertyList(Property property) async{
    emit(PropertiesViewLoading(state.properties, state.hasEdits));

    try{
      Property? prop = state.properties!.firstWhereOrNull((p) => p.id == property.id);
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
    final Property item = state.properties!.removeAt(oldIndex);
    state.properties!.insert(newIndex, item);
    emit(PropertiesViewSuccess(state.properties!, true));
  }

  void saveOrder() async{
    emit(PropertiesViewLoading(state.properties, state.hasEdits));
    for(var prop in state.properties!){
      try{
        int index = state.properties!.indexOf(prop);
        Property property = prop.copyWith(order: index);
        await _propertiesRepository.updateProperty(property);
      }
      catch(e){
        return emit(PropertiesViewError(e.toString(), state.properties!, state.hasEdits));
      }
    }
    emit(PropertiesViewSuccess(state.properties!, false));
  }
}
