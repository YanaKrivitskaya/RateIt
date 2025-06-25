import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/collection_property.model.dart';

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
      if(properties != null){
        emit(PropertiesViewSuccess(properties));
      }
    }catch(e){
      return emit(PropertiesViewError(e.toString(), null));
    }
  }
}
