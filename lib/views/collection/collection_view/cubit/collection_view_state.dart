part of 'collection_view_cubit.dart';

@immutable
sealed class CollectionViewState {
  final Collection? collection;
  final List<CollectionItem>? filteredItems;
  final OrderOptionsArgs? orderOptions;

  const CollectionViewState(this.collection, this.filteredItems, this.orderOptions);

  @override
  List<Object?> get props => [collection, filteredItems, orderOptions];
}

final class CollectionViewInitial extends CollectionViewState {
  const CollectionViewInitial():super(null, null, null);
}

class CollectionViewLoading extends CollectionViewState{
  const CollectionViewLoading(super.collection, super.filteredItems, super.orderOptions);
}

class CollectionViewSuccess extends CollectionViewState{
  final Collection collection;
  final List<CollectionItem>? filteredItems;
  final OrderOptionsArgs orderOptions;

  const CollectionViewSuccess(this.collection, this.filteredItems, this.orderOptions) : super(collection, filteredItems, orderOptions);
}

class CollectionViewError extends CollectionViewState{
  final String error;
  const CollectionViewError(this.error, super.collection, super.filteredItems, super.orderOptions);

  List<Object?> get props => [super.collection, super.orderOptions, error];
}
