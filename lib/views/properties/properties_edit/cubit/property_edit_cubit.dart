import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/properties_repository.dart';
import 'package:rateit/models/property.model.dart';
import 'package:rateit/models/custom_exception.dart';

part 'property_edit_state.dart';

class PropertyEditCubit extends Cubit<PropertyEditState> {
  final PropertiesRepository _propertiesRepository;

  PropertyEditCubit() :
        _propertiesRepository = PropertiesRepository(),
        super(PropertyEditInitial());

  void loadProperty(Property? property) async{
    emit(PropertyEditInitial());

    if(property == null){
      Property newProp = Property(dropdownOptions: List.empty(growable: true));
      emit(PropertyEditSuccess(newProp, false));
    }else{
      try{
        Property? newProp = await _propertiesRepository.getProperty(property.id!);
        if(newProp != null){
          emit(PropertyEditSuccess(newProp, newProp.isDropdown!));
        }else{
          throw BadRequestException("Something went wrong :(");
        }
      }catch(e){
        return emit(PropertyEditError(e.toString(), property));
      }
    }
  }

  void updatePropertyType(String value){
    Property property = state.property!.copyWith(type: value);
    emit(PropertyEditSuccess(property, property.isDropdown ?? false));
  }

  void toggleDropdown(bool value){
    Property property = state.property!.copyWith(isDropdown: value);
    emit(PropertyEditSuccess(property, property.isDropdown ?? false));
  }

  void updateDropdownValues(int? index, String value, bool delete){
    emit(PropertyEditLoading(state.property));

    Property property = state.property!;
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

  void submitProperty(int collectionId, Property property) async{
    emit(PropertyEditLoading(property));

    try{
      Property? newProperty;

      if(property.id != null){
        newProperty = await _propertiesRepository.updateProperty(property);
      }else{
        newProperty = await _propertiesRepository.createProperty(collectionId, property);
      }
      if(newProperty?.id != null){
        await _propertiesRepository.updateDropdownValues(newProperty!.id!, property.isDropdown! ? property.dropdownOptions ?? List.empty() : List.empty());
      }

      emit(PropertyEditCreated(property.copyWith(id: newProperty!.id!)));
    }catch(e){
      return emit(PropertyEditError(e.toString(), property));
    }
  }

  void deleteProperty(int id) async{
    emit(PropertyEditLoading(state.property));

    try{
      await _propertiesRepository.deleteProperty(id);
      emit(PropertyEditDeleted(id));
    }
    catch(e){
      return emit(PropertyEditError(e.toString(), state.property));
    }
  }
}

