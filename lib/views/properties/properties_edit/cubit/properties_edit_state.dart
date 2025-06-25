part of 'properties_edit_cubit.dart';

@immutable
sealed class PropertiesEditState {
  final CollectionProperty? property;

  const PropertiesEditState(this.property);

  @override
  List<Object?> get props => [property];
}

final class PropertiesEditInitial extends PropertiesEditState {
  const PropertiesEditInitial():super(null);
}

class PropertiesEditLoading extends PropertiesEditState{
  const PropertiesEditLoading(super.property);
}

class PropertiesEditSuccess extends PropertiesEditState{
  final CollectionProperty property;
  final bool isDropdown;

  const PropertiesEditSuccess(this.property, this.isDropdown): super(property);
}

class PropertiesEditCreated extends PropertiesEditState{
  final CollectionProperty? property;

  const PropertiesEditCreated(this.property): super(property);
}

class PropertiesEditError extends PropertiesEditState{
  final String error;
  const PropertiesEditError(this.error, super.property);

  List<Object?> get props => [super.property, error];
}
