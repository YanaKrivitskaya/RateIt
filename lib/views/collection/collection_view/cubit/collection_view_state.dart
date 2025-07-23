part of 'collection_view_cubit.dart';

@immutable
sealed class CollectionViewState {
  final Collection? collection;
  final OrderOptionsArgs? orderOptions;

  const CollectionViewState(this.collection, this.orderOptions);

  @override
  List<Object?> get props => [collection, orderOptions];
}

final class CollectionViewInitial extends CollectionViewState {
  const CollectionViewInitial():super(null, null);
}

class CollectionViewLoading extends CollectionViewState{
  const CollectionViewLoading(super.collection, super.orderOptions);
}

class CollectionViewSuccess extends CollectionViewState{
  final Collection collection;
  final OrderOptionsArgs? orderOptions;

  const CollectionViewSuccess(this.collection, this.orderOptions): super(collection, orderOptions);
}

class CollectionViewError extends CollectionViewState{
  final String error;
  const CollectionViewError(this.error, super.collection, super.orderOptions);

  List<Object?> get props => [super.collection, super.orderOptions, error];
}
