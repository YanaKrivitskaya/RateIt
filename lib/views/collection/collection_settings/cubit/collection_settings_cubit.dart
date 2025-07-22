import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/collection.model.dart';

part 'collection_settings_state.dart';

class CollectionSettingsCubit extends Cubit<CollectionSettingsState> {

  final CollectionRepository _collectionRepository;

  CollectionSettingsCubit(Collection collection) :
        _collectionRepository = CollectionRepository(),
        super(CollectionSettingsSuccess(collection, false));

  void deleteCollection(int id)async{
    emit(CollectionSettingsLoading(state.collection));
    try{
      await _collectionRepository.deleteCollection(id);
      emit(CollectionSettingsDelete(id, state.collection));
    }catch(e){
      return emit(CollectionSettingsError(e.toString(), state.collection));
    }
  }

  void setEdit(Collection collection){
    emit(CollectionSettingsSuccess(collection, true));
  }
}
