import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/collection_property.model.dart';

part 'property_edit_state.dart';

class PropertyEditCubit extends Cubit<PropertyEditState> {
  final CollectionRepository _collectionRepository;

  PropertyEditCubit() :
        _collectionRepository = CollectionRepository(),
        super(PropertyEditInitial());

  void loadProperty(CollectionProperty? property){
    emit(PropertyEditInitial());

    if(property == null){
      CollectionProperty newProp = CollectionProperty(dropdownOptions: List.empty(growable: true));
      emit(PropertyEditSuccess(newProp, false));
    }else{
      emit(PropertyEditSuccess(property, property.isDropdown ?? false));
    }
  }

  void toggleDropdown(bool value){
    CollectionProperty property = state.property!.copyWith(isDropdown: value);
    emit(PropertyEditSuccess(property, property.isDropdown ?? false));
  }

  void updateDropdownValues(int? index, String value, bool delete){
    emit(PropertyEditLoading(state.property));

    CollectionProperty property = state.property!;
    List<String> values = property.dropdownOptions ?? List.empty(growable: true);

    if(index != null){
      if(delete){
        values.removeAt(index);
      }else{
        values[index] = value;
      }
    }else{
      values.add(value);
    }
    property.copyWith(dropdownOptions: values);
    emit(PropertyEditSuccess(property, property.isDropdown ?? false));
  }

  void submitProperty(int collectionId, CollectionProperty property) async{
    emit(PropertyEditLoading(property));

    try{
      CollectionProperty? newProperty;

      if(property.id != null){
        newProperty = await _collectionRepository.updateProperty(collectionId, property);
      }else{
        newProperty = await _collectionRepository.createProperty(collectionId, property);
      }
      if(newProperty?.id != null){
        await _collectionRepository.updateDropdownValues(collectionId, newProperty!.id!, property.isDropdown! ? property.dropdownOptions ?? List.empty() : List.empty());
      }

      emit(PropertyEditCreated(newProperty));
    }catch(e){
      return emit(PropertyEditError(e.toString(), property));
    }
  }

  void deleteProperty(int id) async{
    emit(PropertyEditLoading(state.property));

    try{
      await _collectionRepository.deleteProperty(id);
      emit(PropertyEditDeleted(id));
    }
    catch(e){
      return emit(PropertyEditError(e.toString(), state.property));
    }
  }
}

