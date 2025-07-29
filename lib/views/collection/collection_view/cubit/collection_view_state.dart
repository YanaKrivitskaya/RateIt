part of 'collection_view_cubit.dart';

@immutable
sealed class CollectionViewState {
  final Collection? collection;
  final List<CollectionItem>? filteredItems;
  final OrderOptionsArgs? orderOptions;
  final FilterModel? filterModel;
  final String? searchPattern;

  const CollectionViewState(this.collection, this.filteredItems, this.orderOptions, this.filterModel, this.searchPattern);

  @override
  List<Object?> get props => [collection, filteredItems, orderOptions, filterModel, searchPattern];
}

final class CollectionViewInitial extends CollectionViewState {
  const CollectionViewInitial():super(null, null, null, null, null);
}

class CollectionViewLoading extends CollectionViewState{
  const CollectionViewLoading(super.collection, super.filteredItems, super.orderOptions, super.filterModel, super.searchPattern);
}

class CollectionViewSuccess extends CollectionViewState{
  final Collection collection;
  final List<CollectionItem>? filteredItems;
  final OrderOptionsArgs orderOptions;
  final FilterModel? filterModel;
  final String? searchPattern;

  const CollectionViewSuccess(this.collection, this.filteredItems, this.orderOptions, this.filterModel, this.searchPattern) : super(collection, filteredItems, orderOptions, filterModel, searchPattern);

}

class CollectionViewError extends CollectionViewState{
  final String error;
  const CollectionViewError(this.error, super.collection, super.filteredItems, super.orderOptions, super.filterModel, super.searchPattern);

  List<Object?> get props => [super.collection, super.orderOptions, error, filterModel, super.searchPattern];
}
