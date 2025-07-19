part of 'collection_edit_cubit.dart';

@immutable
sealed class CollectionEditState {
  final Collection? collection;

  const CollectionEditState(this.collection);

  @override
  List<Object?> get props => [collection];
}

final class CollectionEditInitial extends CollectionEditState {
  const CollectionEditInitial():super(null);
}

class CollectionEditLoading extends CollectionEditState{
  const CollectionEditLoading(super.collection);
}

class CollectionEditSuccess extends CollectionEditState{
  final Collection collection;

  const CollectionEditSuccess(this.collection): super(collection);
}

class CollectionEditCreated extends CollectionEditState{
  final Collection? collection;

  const CollectionEditCreated(this.collection): super(collection);
}

class CollectionEditDelete extends CollectionEditState{
  final int id;
  const CollectionEditDelete(this.id) : super(null);

  List<Object?> get props => [id];
}

class CollectionEditError extends CollectionEditState{
  final String error;
  const CollectionEditError(this.error, super.collection);

  List<Object?> get props => [super.collection, error];
}
