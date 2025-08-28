import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/models/property.model.dart';
import 'package:rateit/services/api.service.dart';

class CollectionRepository {
  ApiService apiService = ApiService();
  String baseUrl = "collections/";

  final log = Logger('CollectionRepository');

  Future<List<Collection>?> getCollections() async{
    log.info('getCollections');
    final response = await apiService.getSecure(baseUrl);

    var collections = response["collections"]?.map<Collection>((map) =>
        Collection.fromMap(map)).toList();
    return collections;
  }

  Future<Collection?> getCollectionBasic(int collectionId) async{
    var url = "${baseUrl}basic/$collectionId";
    log.info('getCollectionBasic');
    final response = await apiService.getSecure(url);

    var collection = response["collection"] != null ?
    Collection.fromMap(response["collection"]) : null;
    return collection;
  }

  Future<Collection?> getCollectionById(int collectionId) async{
    var url = "$baseUrl$collectionId";
    log.info('getCollectionById');
    final response = await apiService.getSecure(url);

    var collection = response["collection"] != null ?
      Collection.fromMap(response["collection"]) : null;
    return collection;
  }

  Future<List<Property>?> getCollectionProperties(int collectionId) async{
    var url = "$baseUrl$collectionId/properties";
    log.info('getCollectionProperties');
    final response = await apiService.getSecure(url);

    var properties = response["properties"]?.map<Property>((map) =>
        Property.fromMap(map)).toList();
    return properties;
  }

  Future<Collection?> createCollection(Collection collection) async{
    log.info('createCollection');

    final response = await apiService.postSecure(baseUrl, collection.toJson());

    var collectionResponse = response["collection"] != null ?
    Collection.fromMap(response['collection']) : null;
    return collectionResponse;
  }

  Future<Collection?> updateCollection(Collection collection) async{
    log.info('updateCollection');

    final response = await apiService.putSecure(baseUrl, collection.toJson());

    var collectionResponse = response["collection"] != null ?
    Collection.fromMap(response['collection']) : null;
    return collectionResponse;
  }

  Future<void> deleteCollection(collectionId) async{
    log.info('deleteCollection');

    await apiService.deleteSecure("$baseUrl$collectionId");
  }
}
