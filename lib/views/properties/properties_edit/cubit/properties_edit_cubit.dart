import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/collection_repository.dart';
import 'package:rateit/models/collection_property.model.dart';

part 'properties_edit_state.dart';

class PropertiesEditCubit extends Cubit<PropertiesEditState> {
  final CollectionRepository _collectionRepository;

  PropertiesEditCubit() :
        _collectionRepository = CollectionRepository(),
        super(PropertiesEditInitial());

  void loadProperty(CollectionProperty? property){
    emit(PropertiesEditInitial());

    if(property == null){
      CollectionProperty newProp = CollectionProperty(dropdownOptions: List.empty(growable: true));
      emit(PropertiesEditSuccess(newProp, false));
    }else{
      emit(PropertiesEditSuccess(property, property.isDropdown ?? false));
    }
  }

  void toggleDropdown(bool value){
    CollectionProperty property = state.property!.copyWith(isDropdown: value);
    emit(PropertiesEditSuccess(property, property.isDropdown ?? false));
  }

  void updateDropdownValues(int? index, String value, bool delete){
    emit(PropertiesEditLoading(state.property));

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
    emit(PropertiesEditSuccess(property, property.isDropdown ?? false));
  }

  void submitProperty(int collectionId, CollectionProperty property) async{
    emit(PropertiesEditLoading(property));

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

      emit(PropertiesEditCreated(newProperty));
    }catch(e){
      return emit(PropertiesEditError(e.toString(), property));
    }
  }
}

