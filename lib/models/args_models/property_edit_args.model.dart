import 'package:rateit/models/property.model.dart';

class PropertyEditArgs {
  final int collectionId;
  final Property? property;

  PropertyEditArgs({required this.collectionId, this.property});
}