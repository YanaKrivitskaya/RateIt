part of 'item_view_cubit.dart';

@immutable
sealed class ItemViewState {
  final CollectionItem? item;

  const ItemViewState(this.item);

  @override
  List<Object?> get props => [item];
}

final class ItemViewInitial extends ItemViewState {
  const ItemViewInitial():super(null);
}

class ItemViewLoading extends ItemViewState{
  const ItemViewLoading(super.item);
}

class ItemViewSuccess extends ItemViewState{
  final CollectionItem item;

  const ItemViewSuccess(this.item): super(item);
}

class ItemViewError extends ItemViewState{
  final String error;
  const ItemViewError(this.error, super.item);

  List<Object?> get props => [super.item, error];
}
