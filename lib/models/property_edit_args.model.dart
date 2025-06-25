import 'package:rateit/models/collection_property.model.dart';

class PropertyEditArgs {
  final int collectionId;
  final CollectionProperty? property;

  PropertyEditArgs({required this.collectionId, this.property});
}