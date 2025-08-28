import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/collection.model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final CollectionRepository _collectionRepository;

  HomeCubit() :
    _collectionRepository = CollectionRepository(),
    super(HomeInitial());

  void getUserCollections() async{
    emit(HomeStateLoading(null));
    try{
      var collections = await _collectionRepository.getCollections();
      return emit(HomeStateSuccess(collections ?? []));
    }catch(e){
      return emit(HomeStateError(null, e.toString()));
    }
  }

  void getCollectionBasic(int collectionId) async{
    emit(HomeStateLoading(state.collections));

    try{
      Collection? collection = await _collectionRepository.getCollectionBasic(collectionId);
      if(collection != null){
        state.collections!.add(collection);
        emit(HomeStateSuccess(state.collections!));
      }
    }catch(e){
      return emit(HomeStateError(state.collections, e.toString()));
    }
  }

  void removeCollection(int id){
    emit(HomeStateLoading(state.collections));

    state.collections!.removeWhere((c)=> c.id == id);
    emit(HomeStateSuccess(state.collections!));
  }
}
