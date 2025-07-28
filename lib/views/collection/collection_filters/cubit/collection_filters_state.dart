part of 'collection_filters_cubit.dart';

@immutable
sealed class CollectionFiltersState {
  final Collection collection;
  final List<CollectionProperty>? properties;

  const CollectionFiltersState(this.collection, this.properties);

  @override
  List<Object?> get props => [collection, properties];
}

final class CollectionFiltersInitial extends CollectionFiltersState {
  final Collection collection;

  const CollectionFiltersInitial(this.collection):super(collection, null);
}

class CollectionFiltersLoading extends CollectionFiltersState{
  const CollectionFiltersLoading(super.collection, super.properties);
}

class CollectionFiltersSuccess extends CollectionFiltersState{
  final Collection collection;
  final List<CollectionProperty>? properties;

  const CollectionFiltersSuccess(this.collection, this.properties): super(collection, properties);
}

class CollectionFiltersApplied extends CollectionFiltersState{
  final Collection collection;
  final List<CollectionProperty>? properties;

  const CollectionFiltersApplied(this.collection, this.properties): super(collection, properties);
}

class CollectionFiltersError extends CollectionFiltersState{
  final String error;
  const CollectionFiltersError(this.error, super.collection, super.properties);

  List<Object?> get props => [super.collection, super.properties, error];
}

