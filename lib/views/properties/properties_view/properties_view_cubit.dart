import 'package:bloc/bloc.dart';
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
      emit(PropertiesViewSuccess(properties ?? List.empty(growable: true)));
    }catch(e){
      return emit(PropertiesViewError(e.toString(), null));
    }
  }

  void updatePropertyList(CollectionProperty property) async{
    emit(PropertiesViewLoading(state.properties));

    try{
      CollectionProperty? prop = state.properties!.firstWhereOrNull((p) => p.id == property.id);
      if(prop != null){
        int index = state.properties!.indexOf(prop);
        state.properties![index] = property;
      }else{
        state.properties!.add(property);
      }
      emit(PropertiesViewSuccess(state.properties!));
    }catch(e){
      return emit(PropertiesViewError(e.toString(), null));
    }
  }

}
