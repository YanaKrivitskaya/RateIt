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
}
