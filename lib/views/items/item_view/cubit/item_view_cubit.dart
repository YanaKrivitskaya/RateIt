import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/models/collection_item.model.dart';

part 'item_view_state.dart';

class ItemViewCubit extends Cubit<ItemViewState> {
  ItemViewCubit() : super(ItemViewInitial());
}
