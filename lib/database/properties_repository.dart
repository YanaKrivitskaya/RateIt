import 'package:logging/logging.dart';
import 'package:rateit/models/api_models/api_dropdown.model.dart';
import 'package:rateit/models/property.model.dart';
import 'package:rateit/services/api.service.dart';

class PropertiesRepository {
  ApiService apiService = ApiService();
  String baseUrl = "properties/";
  final log = Logger('PropertiesRepository');

  Future<Property?> getProperty(int propertyId) async{
    var url = "$baseUrl$propertyId";
    log.info('getProperty');
    final response = await apiService.getSecure(url);

    var property = response["property"] != null ?
    Property.fromMap(response["property"]) : null;
    return property;
  }

  Future<Property?> createProperty(int collectionId, Property property) async{
    var url = "$baseUrl$collectionId";
    log.info('createProperty');

    final response = await apiService.postSecure(url, property.toJson());

    var propertyResponse = response["property"] != null ?
    Property.fromMap(response['property']) : null;
    return propertyResponse;
  }

  Future<Property?> updateProperty(Property property) async{
    var url = baseUrl;
    log.info('updateProperty');

    final response = await apiService.putSecure(url, property.toJson());

    var propertyResponse = response["property"] != null ?
    Property.fromMap(response['property']) : null;
    return propertyResponse;
  }

  Future<void> updateDropdownValues(int propertyId, List<String> values) async{
    var url = "$baseUrl$propertyId/dropdown";
    log.info('updateDropdownValues');
    ApiDropdownModel model = ApiDropdownModel(List.empty(growable: true));

    for (var value in values) {
      model.data.add(ApiDropdownValue(propertyId, value));
    }

    await apiService.postSecure(url, model.toJson());
  }

  Future<List<String>?> getPropertyValuesDistinct(int propertyId) async{
    var url = "$baseUrl$propertyId/values";
    log.info('getPropertyValuesDistinct');

    final response = await apiService.getSecure(url);

    var valuesResponse = response['values'] != null ? List<String>.from(response['values']?.map((d) => d['value'].toString())) : null;
    return valuesResponse;
  }

  /*Future<void> deleteDropdownValue(int dropdownId) async{
    var url = "${baseUrl}dropdown/$dropdownId";
    if (kDebugMode) {
      print("deleteDropdownValue called $url");
    }

    await apiService.deleteSecure(url);
  }*/

  Future<void> deleteProperty(propertyId) async{
    var url = "$baseUrl$propertyId";
    log.info('deleteProperty');

    await apiService.deleteSecure(url);
  }
}