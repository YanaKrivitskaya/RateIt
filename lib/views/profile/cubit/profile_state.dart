part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {
  final User? user;

  const ProfileState(this.user);
}

class ProfileInitial extends ProfileState {
  const ProfileInitial():super(null);
}

class ProfileStateLoading extends ProfileState {
  @override
  final User? user;

  const ProfileStateLoading(this.user) :super(user);
}

class ProfileStateSuccess extends ProfileState {
  @override
  final User user;

  const ProfileStateSuccess(this.user) :super(user);

  List<Object> get props => [user];
}

class ProfileStateError extends ProfileState {
  @override
  final User? user;
  final String error;

  const ProfileStateError(this.user, this.error) : super(user);

  List<Object?> get props => [user, error];
}

