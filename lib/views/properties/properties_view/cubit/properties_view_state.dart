part of 'properties_view_cubit.dart';

@immutable
sealed class PropertiesViewState {
  final List<Property>? properties;
  final bool hasEdits;

  const PropertiesViewState(this.properties, this.hasEdits);

  List<Object?> get props => [properties, hasEdits];
}

final class PropertiesViewInitial extends PropertiesViewState {
  const PropertiesViewInitial():super(null, false);
}

class PropertiesViewLoading extends PropertiesViewState{
  const PropertiesViewLoading(super.properties, super.hasEdits);
}

class PropertiesViewSuccess extends PropertiesViewState{
  final List<Property> properties;
  final bool hasEdits;

  const PropertiesViewSuccess(this.properties, this.hasEdits)
      : super(properties, hasEdits);
}

class PropertiesViewError extends PropertiesViewState{
  final String error;
  const PropertiesViewError(this.error, super.properties, super.hasEdits);

  @override
  List<Object?> get props => [super.properties, error, super.hasEdits];
}
