part of 'item_edit_cubit.dart';

@immutable
sealed class ItemEditState {
  final Item? item;
  final List<AttachmentViewModel>? files;

  const ItemEditState(this.item, this.files);

  List<Object?> get props => [item, files];
}

final class ItemEditInitial extends ItemEditState {
  const ItemEditInitial():super(null, null);
}

class ItemEditLoading extends ItemEditState{
  const ItemEditLoading(super.item, super.files);
}

class ItemEditSuccess extends ItemEditState{
  final Item item;

  const ItemEditSuccess(this.item,final List<AttachmentViewModel>? files): super(item, files);
}

class ItemEditCreated extends ItemEditState{
  final Item item;
  final List<AttachmentViewModel>? files;

  const ItemEditCreated(this.item, this.files): super(item, files);
}

class ItemEditError extends ItemEditState{
  final String error;
  const ItemEditError(this.error, super.item, super.files);

  List<Object?> get props => [super.item, error, super.files];
}


