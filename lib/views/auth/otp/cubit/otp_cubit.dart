import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../database/api_user_repository.dart';
import '../../../../models/custom_exception.dart';
import '../../../../models/user.model.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final ApiUserRepository _apiUserRepository;

  OtpCubit() :
    _apiUserRepository = ApiUserRepository(),
    super(OtpInitial());

  void verifyOtp(String otp, String email) async{
    emit(OtpStateLoading(otp));
    try{
      var user = await _apiUserRepository.verifyOtp(otp, email);
      return emit(OtpStateSuccess(otp, user));
    } catch(e){
      return emit(OtpStateError(otp, e.toString()));
    }
  }

  void resendOtp(String email)async{
    emit(OtpStateLoading(null));
    try{
      await _apiUserRepository.sendOtp(email);
      return emit(OtpInitial());
    } catch(e){
      return emit (OtpStateError(null, e.toString()));
    }
  }
}
