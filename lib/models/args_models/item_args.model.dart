import 'package:rateit/models/collection_item.model.dart';

class ItemEditArgs {
  final int collectionId;
  final CollectionItem? item;

  ItemEditArgs({required this.collectionId, this.item});
}

class ItemViewArgs {
  final int collectionId;
  final int itemId;

  ItemViewArgs({required this.collectionId, required this.itemId});
}