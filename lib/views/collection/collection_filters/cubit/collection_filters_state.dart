part of 'collection_filters_cubit.dart';

@immutable
sealed class CollectionFiltersState {
  final int? collectionId;
  final FilterModel? filterModel;

  const CollectionFiltersState(this.collectionId, this.filterModel);

  @override
  List<Object?> get props => [collectionId, filterModel];
}

final class CollectionFiltersInitial extends CollectionFiltersState {
  const CollectionFiltersInitial():super(null, null);
}

class CollectionFiltersLoading extends CollectionFiltersState{
  const CollectionFiltersLoading(super.collection, super.properties);
}

class CollectionFiltersSuccess extends CollectionFiltersState{
  final int? collectionId;
  final FilterModel? filterModel;

  const CollectionFiltersSuccess(this.collectionId, this.filterModel): super(collectionId, filterModel);
}

/*class CollectionFiltersApplied extends CollectionFiltersState{
  final Collection collection;
  final List<CollectionProperty>? properties;

  const CollectionFiltersApplied(this.collection, this.properties): super(collection, properties);
}*/

class CollectionFiltersError extends CollectionFiltersState{
  final String error;
  const CollectionFiltersError(this.error, super.collectionId, super.filterModel);

  List<Object?> get props => [super.collectionId, super.filterModel, error];
}

