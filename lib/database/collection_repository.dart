import 'package:flutter/foundation.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:rateit/models/api_models/api_attachments.model.dart';
import 'package:rateit/models/api_models/api_dropdown.model.dart';
import 'package:rateit/models/api_models/api_values.model.dart';
import 'package:rateit/models/attachment.model.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/models/collection_item.model.dart';
import 'package:rateit/models/collection_property.model.dart';
import 'package:rateit/services/api.service.dart';

class CollectionRepository {
  ApiService apiService = ApiService();
  String baseUrl = "collections/";
  String attachmentsUrl = "attachments/";

  Future<List<Collection>?> getCollections() async{
    if (kDebugMode) {
      print("getCollections");
    }
    final response = await apiService.getSecure(baseUrl);

    var collections = response["collections"]?.map<Collection>((map) =>
        Collection.fromMap(map)).toList();
    return collections;
  }

  Future<Collection?> getCollectionBasic(int collectionId) async{
    if (kDebugMode) {
      print("getCollectionBasic");
    }
    final response = await apiService.getSecure("${baseUrl}basic/$collectionId");

    var collection = response["collection"] != null ?
    Collection.fromMap(response["collection"]) : null;
    return collection;
  }

  Future<CollectionProperty?> getPropertyBasic(int collectionId, int propertyId) async{
    if (kDebugMode) {
      print("getPropertyBasic");
    }
    final response = await apiService.getSecure("$baseUrl/$collectionId/properties/$propertyId");

    var property = response["property"] != null ?
    CollectionProperty.fromMap(response["property"]) : null;
    return property;
  }

  Future<CollectionProperty?> getPropertyExpanded(int propertyId) async{
    if (kDebugMode) {
      print("getPropertyExpanded");
    }
    final response = await apiService.getSecure("${baseUrl}properties/$propertyId");

    var property = response["property"] != null ?
    CollectionProperty.fromMap(response["property"]) : null;
    return property;
  }

  Future<Collection?> getCollectionById(int collectionId) async{
    if (kDebugMode) {
      print("getCollectionById");
    }
    final response = await apiService.getSecure("$baseUrl$collectionId");

    var collection = response["collection"] != null ?
      Collection.fromMap(response["collection"]) : null;
    return collection;
  }

  Future<List<CollectionProperty>?> getCollectionProperties(int collectionId) async{
    if (kDebugMode) {
      print("getCollectionProperties");
    }
    final response = await apiService.getSecure("$baseUrl$collectionId/properties");

    var properties = response["properties"]?.map<CollectionProperty>((map) =>
        CollectionProperty.fromMap(map)).toList();
    return properties;
  }

  Future<Collection?> createCollection(Collection collection) async{
    print("createCollection");

    final response = await apiService.postSecure(baseUrl, collection.toJson());

    var collectionResponse = response["collection"] != null ?
    Collection.fromMap(response['collection']) : null;
    return collectionResponse;
  }

  Future<Collection?> updateCollection(Collection collection) async{
    print("updateCollection");

    final response = await apiService.putSecure(baseUrl, collection.toJson());

    var collectionResponse = response["collection"] != null ?
    Collection.fromMap(response['collection']) : null;
    return collectionResponse;
  }

  Future<CollectionProperty?> createProperty(int collectionId, CollectionProperty property) async{
    print("createProperty");

    final response = await apiService.postSecure('$baseUrl$collectionId/properties', property.toJson());

    var propertyResponse = response["property"] != null ?
    CollectionProperty.fromMap(response['property']) : null;
    return propertyResponse;
  }

  Future<CollectionProperty?> updateProperty(int collectionId, CollectionProperty property) async{
    print("updateProperty");

    final response = await apiService.putSecure('$baseUrl$collectionId/properties', property.toJson());

    var propertyResponse = response["property"] != null ?
    CollectionProperty.fromMap(response['property']) : null;
    return propertyResponse;
  }

  Future<void> updateDropdownValues(int collectionId, int propertyId, List<String> values) async{
    print("updateDropdownValues");
    ApiDropdownModel model = ApiDropdownModel(propertyId, List.empty(growable: true));

    for (var value in values) {
      model.data.add(ApiDropdownValue(propertyId, value));
    }

    final response = await apiService.postSecure('$baseUrl$collectionId/properties/dropdown', model.toJson());
    print(response.toString());
  }

  Future<CollectionItem?> createItem(int collectionId, CollectionItem item) async{
    print("createItem");

    final response = await apiService.postSecure("$baseUrl$collectionId/items", item.toJson());

    var itemResponse = response["item"] != null ?
    CollectionItem.fromMap(response['item']) : null;
    return itemResponse;
  }

  Future<CollectionItem?> updateItem(int collectionId, CollectionItem item) async{
    print("updateItem");

    final response = await apiService.putSecure("$baseUrl$collectionId/items", item.toJson());

    var itemResponse = response["item"] != null ?
    CollectionItem.fromMap(response['item']) : null;
    return itemResponse;
  }

  Future<CollectionItem?> createPropertyValues(int collectionId, int itemId, List<CollectionProperty> properties) async{
    print("createPropertyValues");
    ApiCreatePropertyValueModel model = ApiCreatePropertyValueModel(itemId, List.empty(growable: true));

    for (var prop in properties) {
      model.data.add(ApiPropertyValue(itemId: itemId, propertyId:  prop.id!, value: prop.value!));
    }

    final response = await apiService.postSecure('$baseUrl$collectionId/properties/values', model.toJson());

    var itemResponse = response["item"] != null ?
    CollectionItem.fromMap(response['item']) : null;
    return itemResponse;
  }

  Future<void> updatePropertyValues(int collectionId, List<CollectionProperty> properties) async{
    print("updatePropertyValues");
    ApiUpdatePropertyValueModel model = ApiUpdatePropertyValueModel(List.empty(growable: true));

    for (var prop in properties) {
      model.data.add(ApiPropertyValue(id: prop.valueId!, value: prop.value!));
    }

    final response = await apiService.putSecure('$baseUrl$collectionId/properties/values', model.toJson());
    print(response.toString());
  }

  Future<List<Attachment>?> createAttachments(int collectionId, int itemId, List<XFile> attachments) async{
    print("createAttachments");

    List<ApiAttachmentModel> files = List.empty(growable: true);

    for (var att in attachments) {
      files.add(ApiAttachmentModel(await att.readAsBytes(), att.name));
    }

    final response = await apiService.postSecureMultipart('$attachmentsUrl$collectionId/$itemId', files);

    var attResponse = response["attachments"]?.map<Attachment>((map) =>
        Attachment.fromMap(map)).toList();
    return attResponse;
  }

  Future<Attachment?> getCoverAttachment(int itemId) async{
    if (kDebugMode) {
      print("getCoverAttachment");
    }
    final response = await apiService.getSecure("$attachmentsUrl$itemId");

    var attachment = response["attachment"] != null ?
    Attachment.fromMap(response["attachment"]) : null;
    return attachment;
  }

  Future<Uint8List?> getAttachmentById(int collectionId, id) async{
    if (kDebugMode) {
      print("getAttachmentById");
    }
    final response = await apiService.getSecure("$attachmentsUrl$collectionId/$id", isRaw: true);

    return response.bodyBytes;
  }

  Future<CollectionItem?> getItemById(int collectionId, int itemId) async{
    if (kDebugMode) {
      print("getItemById");
    }
    final response = await apiService.getSecure("$baseUrl$collectionId/items/$itemId");

    var item = response["item"] != null ?
    CollectionItem.fromMap(response["item"]) : null;
    return item;
  }

  Future<void> deleteAttachment(int collectionId, id) async{
    if (kDebugMode) {
      print("deleteAttachment");
    }
    await apiService.deleteSecure("$attachmentsUrl$collectionId/$id");
  }

  Future<void> deleteDropdownValue(int dropdownId) async{
    if (kDebugMode) {
      print("deleteDropdownValue");
    }

    await apiService.deleteSecure("${baseUrl}dropdown/$dropdownId");
  }

  Future<void> deleteProperty(propertyId) async{
    if (kDebugMode) {
      print("deleteProperty");
    }

    await apiService.deleteSecure("${baseUrl}properties/$propertyId");
  }

  Future<void> deleteItem(int itemId) async{
    if (kDebugMode) {
      print("deleteItem");
    }

    await apiService.deleteSecure("${baseUrl}items/$itemId");
  }

  Future<void> deleteCollection(collectionId) async{
    if (kDebugMode) {
      print("deleteCollection");
    }

    await apiService.deleteSecure("$baseUrl$collectionId");
  }
}
