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

  Future<CollectionItem?> updatePropertyValues(int collectionId, int itemId, List<CollectionProperty> properties) async{
    print("updatePropertyValues");
    ApiPropertyValueModel model = ApiPropertyValueModel(itemId, List.empty(growable: true));

    for (var prop in properties) {
      model.data.add(ApiPropertyValue(itemId, prop.id!, prop.value!));
    }

    final response = await apiService.postSecure('$baseUrl$collectionId/properties/values', model.toJson());

    var itemResponse = response["item"] != null ?
    CollectionItem.fromMap(response['item']) : null;
    return itemResponse;
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

  Future<Uint8List?> getAttachmentById(int collectionId, id) async{
    if (kDebugMode) {
      print("getAttachmentById");
    }
    final response = await apiService.getSecure("$attachmentsUrl$collectionId/$id", isRaw: true);

    return response.bodyBytes;
  }
}
