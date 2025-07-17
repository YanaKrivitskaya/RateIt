part of 'item_view_cubit.dart';

@immutable
sealed class ItemViewState {
  final CollectionItem? item;
  final bool hasEdit;

  const ItemViewState(this.item, this.hasEdit);

  @override
  List<Object?> get props => [item, hasEdit];
}

final class ItemViewInitial extends ItemViewState {
  const ItemViewInitial():super(null, false);
}

class ItemViewLoading extends ItemViewState{
  const ItemViewLoading(super.item, super.hasEdit);
}

class ItemViewSuccess extends ItemViewState{
  final CollectionItem item;
  final bool hasEdit;

  const ItemViewSuccess(this.item, this.hasEdit): super(item, hasEdit);
}

class ItemViewError extends ItemViewState{
  final String error;

  const ItemViewError(this.error, super.item, super.hasEdit);

  List<Object?> get props => [super.item, super.hasEdit, error];
}
