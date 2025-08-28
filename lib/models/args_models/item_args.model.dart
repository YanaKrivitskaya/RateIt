import 'package:rateit/models/item.model.dart';

class ItemEditArgs {
  final int collectionId;
  final Item? item;

  ItemEditArgs({required this.collectionId, this.item});
}

class ItemViewArgs {
  final int collectionId;
  final int itemId;

  ItemViewArgs({required this.collectionId, required this.itemId});
}