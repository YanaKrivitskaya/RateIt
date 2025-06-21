part of 'collection_view_cubit.dart';

@immutable
sealed class CollectionViewState {
  final Collection? collection;

  const CollectionViewState(this.collection);

  @override
  List<Object?> get props => [collection];
}

final class CollectionViewInitial extends CollectionViewState {
  const CollectionViewInitial():super(null);
}

class CollectionViewLoading extends CollectionViewState{
  const CollectionViewLoading(super.collection);
}

class CollectionViewSuccess extends CollectionViewState{
  final Collection collection;

  const CollectionViewSuccess(this.collection): super(collection);
}

class CollectionViewError extends CollectionViewState{
  final String error;
  const CollectionViewError(this.error, super.collection);

  List<Object?> get props => [super.collection, error];
}
