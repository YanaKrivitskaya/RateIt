
import 'package:logging/logging.dart';
import 'package:rateit/models/api_models/api_values.model.dart';
import 'package:rateit/models/item.model.dart';
import 'package:rateit/models/property.model.dart';
import 'package:rateit/services/api.service.dart';

class ItemsRepository {
  ApiService apiService = ApiService();
  String baseUrl = "items/";
  final log = Logger('ItemsRepository');

  Future<Item?> createItem(int collectionId, Item item) async{
    var url = "$baseUrl$collectionId";
    log.info('createItem');

    final response = await apiService.postSecure(url, item.toJson());

    var itemResponse = response["item"] != null ?
    Item.fromMap(response['item']) : null;
    return itemResponse;
  }

  Future<Item?> updateItem(Item item) async{
    var url = baseUrl;
    log.info('updateItem');

    final response = await apiService.putSecure(url, item.toJson());

    var itemResponse = response["item"] != null ?
    Item.fromMap(response['item']) : null;
    return itemResponse;
  }

  Future<Item?> createPropertyValues(int itemId, List<Property> properties) async{
    var url = "$baseUrl$itemId/values";
    log.info('createPropertyValues');
    ApiCreatePropertyValueModel model = ApiCreatePropertyValueModel(List.empty(growable: true));

    for (var prop in properties) {
      model.data.add(ApiPropertyValue(itemId: itemId, propertyId:  prop.id!, value: prop.value!));
    }

    final response = await apiService.postSecure(url, model.toJson());

    var itemResponse = response["item"] != null ?
    Item.fromMap(response['item']) : null;
    return itemResponse;
  }

  Future<void> updatePropertyValues(int itemId, List<Property> properties) async{
    var url = "$baseUrl$itemId/values";
    log.info('updatePropertyValues');
    ApiUpdatePropertyValueModel model = ApiUpdatePropertyValueModel(List.empty(growable: true));

    for (var prop in properties) {
      model.data.add(ApiPropertyValue(id: prop.valueId!, value: prop.value!));
    }

    await apiService.putSecure(url, model.toJson());
  }

  Future<Item?> getItemById(int itemId) async{
    var url = "$baseUrl$itemId";
    log.info('getItemById');
    final response = await apiService.getSecure(url);

    var item = response["item"] != null ?
    Item.fromMap(response["item"]) : null;
    return item;
  }

  Future<void> deleteItem(int itemId) async{
    var url = "$baseUrl$itemId";
    log.info('deleteItem');

    await apiService.deleteSecure(url);
  }

}