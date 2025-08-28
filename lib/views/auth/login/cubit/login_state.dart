part of 'login_cubit.dart';

@immutable
abstract class LoginState {
  final String? email;

  const LoginState(this.email);

  List<Object?> get props => [email];
}

class LoginInitial extends LoginState {
  const LoginInitial(): super(null);
}

class LoginStateSuccess extends LoginState{
  final String email;

  const LoginStateSuccess(this.email) : super(email);
}

class LoginStateError extends LoginState{
  final String error;

  const LoginStateError(super.email, this.error);

  @override
  List<Object?> get props => [email, error];
}

class LoginStateLoading extends LoginState{
  const LoginStateLoading(super.email);
}
