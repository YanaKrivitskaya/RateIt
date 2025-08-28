import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:flutter/material.dart';

part 'collection_edit_state.dart';

class CollectionEditCubit extends Cubit<CollectionEditState> {
  final CollectionRepository _collectionRepository;

  CollectionEditCubit() :
      _collectionRepository = CollectionRepository(),
        super(CollectionEditInitial());

  void initCollection() {
    emit(CollectionEditInitial());
    Random random = Random();

    int random1 = random.nextInt(Colors.primaries.length);
    int random2 = random.nextInt(Colors.accents.length);

    Color colorPrimary = Colors.primaries[random1];
    Color colorAccent = Colors.accents[random2];

    Collection collection = Collection(colorPrimary: colorPrimary, colorAccent: colorAccent, icon: Icons.collections);
    emit(CollectionEditSuccess(collection));
  }

  void loadCollection(Collection collection){
    emit(CollectionEditInitial());

    emit(CollectionEditSuccess(collection));
  }

  void setIcon(IconData icon, Collection collection){
    emit(CollectionEditLoading(collection));

    Collection updCollection = collection.copyWith(icon: icon);
    emit(CollectionEditSuccess(updCollection));
  }

  void submitCollection(Collection collection) async{
    emit(CollectionEditLoading(collection));

    try{
      Collection? newCollection;

      if(collection.id != null){
        newCollection = await _collectionRepository.updateCollection(collection);
      }else{
        newCollection = await _collectionRepository.createCollection(collection);
      }

      emit(CollectionEditCreated(newCollection));
    }catch(e){
      return emit(CollectionEditError(e.toString(), collection));
    }
  }

}
