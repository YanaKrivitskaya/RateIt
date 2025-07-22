part of 'collection_settings_cubit.dart';

@immutable
sealed class CollectionSettingsState {
  final Collection collection;

  const CollectionSettingsState(this.collection);

  @override
  List<Object?> get props => [collection];
}

class CollectionSettingsLoading extends CollectionSettingsState{
  const CollectionSettingsLoading(super.collection);
}

class CollectionSettingsSuccess extends CollectionSettingsState{
  final Collection collection;
  final bool hasEdit;

  const CollectionSettingsSuccess(this.collection, this.hasEdit): super(collection);
}

class CollectionSettingsDelete extends CollectionSettingsState{
  final int id;
  const CollectionSettingsDelete(this.id, super.collection);

  List<Object?> get props => [id];
}

class CollectionSettingsError extends CollectionSettingsState{
  final String error;
  const CollectionSettingsError(this.error, super.collection);

  List<Object?> get props => [super.collection, error];
}
