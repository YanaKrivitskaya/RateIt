import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/collection.model.dart';

part 'collection_view_state.dart';

class CollectionViewCubit extends Cubit<CollectionViewState> {
  final CollectionRepository _collectionRepository;

  CollectionViewCubit() :
      _collectionRepository = CollectionRepository(),
      super(CollectionViewInitial());

  void loadCollection(int collectionId) async{
    emit(CollectionViewInitial());

    try{
      Collection? collection = await _collectionRepository.getCollectionById(collectionId);
      if(collection != null){
        emit(CollectionViewSuccess(collection));
      }
    }catch(e){
      return emit(CollectionViewError(e.toString(), null));
    }
  }
}
