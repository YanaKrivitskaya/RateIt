part of 'otp_cubit.dart';

@immutable
abstract class OtpState {
  final String? otp;

  const OtpState(this.otp);

  List<Object?> get props => [otp];
}

class OtpInitial extends OtpState {
  const OtpInitial():super(null);
}

class OtpStateLoading extends OtpState {
  final String? otp;

  const OtpStateLoading(this.otp) :super(otp);
}

class OtpStateSuccess extends OtpState {
  final String otp;
  final User user;

  const OtpStateSuccess(this.otp, this.user) : super(otp);

  List<Object> get props => [otp, user];
}

class OtpStateError extends OtpState {
  final String? otp;
  final String error;

  const OtpStateError(this.otp, this.error) : super(otp);

  List<Object?> get props => [otp, error];
}