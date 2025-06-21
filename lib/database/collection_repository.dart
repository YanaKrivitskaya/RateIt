import 'package:flutter/foundation.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/models/collection_property.model.dart';
import 'package:rateit/services/api.service.dart';

class CollectionRepository {
  ApiService apiService = ApiService();
  String baseUrl = "collections/";

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
}
