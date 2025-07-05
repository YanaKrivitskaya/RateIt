part of 'property_edit_cubit.dart';

@immutable
sealed class PropertyEditState {
  final CollectionProperty? property;

  const PropertyEditState(this.property);

  @override
  List<Object?> get props => [property];
}

final class PropertyEditInitial extends PropertyEditState {
  const PropertyEditInitial():super(null);
}

class PropertyEditLoading extends PropertyEditState{
  const PropertyEditLoading(super.property);
}

class PropertyEditSuccess extends PropertyEditState{
  final CollectionProperty property;
  final bool isDropdown;

  const PropertyEditSuccess(this.property, this.isDropdown): super(property);
}

class PropertyEditCreated extends PropertyEditState{
  final CollectionProperty? property;

  const PropertyEditCreated(this.property): super(property);
}

class PropertyEditError extends PropertyEditState{
  final String error;
  const PropertyEditError(this.error, super.property);

  List<Object?> get props => [super.property, error];
}
