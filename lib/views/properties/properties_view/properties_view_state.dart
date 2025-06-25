part of 'properties_view_cubit.dart';

@immutable
sealed class PropertiesViewState {
  final List<CollectionProperty>? properties;

  const PropertiesViewState(this.properties);

  @override
  List<Object?> get props => [properties];
}

final class PropertiesViewInitial extends PropertiesViewState {
  const PropertiesViewInitial():super(null);
}

class PropertiesViewLoading extends PropertiesViewState{
  const PropertiesViewLoading(super.properties);
}

class PropertiesViewSuccess extends PropertiesViewState{
  final List<CollectionProperty> properties;

  const PropertiesViewSuccess(this.properties)
      : super(properties);
}

class PropertiesViewError extends PropertiesViewState{
  final String error;
  const PropertiesViewError(this.error, super.properties);

  @override
  List<Object?> get props => [super.properties, error];
}
