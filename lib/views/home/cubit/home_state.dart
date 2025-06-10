part of 'home_cubit.dart';

@immutable
abstract class HomeState {
  final List<Collection>? collections;

  const HomeState(this.collections);
}

class HomeInitial extends HomeState {
  const HomeInitial():super(null);
}

class HomeStateLoading extends HomeState {
  final List<Collection>? collections;

  const HomeStateLoading(this.collections) :super(collections);
}

class HomeStateSuccess extends HomeState {
  final List<Collection> collections;

  const HomeStateSuccess(this.collections) :super(collections);

  List<Object> get props => [collections];
}

class HomeStateError extends HomeState {
  final List<Collection>? collections;
  final String error;

  const HomeStateError(this.collections, this.error) : super(collections);

  List<Object?> get props => [collections, error];
}
