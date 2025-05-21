import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/api_user_repository.dart';
import 'package:rateit/helpers/validation_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final ApiUserRepository _apiUserRepository;

  LoginCubit() :
      _apiUserRepository = ApiUserRepository(),
      super(LoginInitial());

  void sendOtpToEmail(String email) async{
    emit(LoginStateLoading(email));
    
    bool emailValid = Validator.isValidEmail(email);
    if(!emailValid) {
      return emit(LoginStateError(email, "Email has incorrect format"));
    } else {
      try{
        await _apiUserRepository.sendOtp(email);
        return emit(LoginStateSuccess(email));
      } catch(e){
        return emit(LoginStateError(email, e.toString()));
      }}
  }
}
