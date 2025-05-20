import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/api_user_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../models/user.model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiUserRepository _apiUserRepository;

  AuthCubit() :
        _apiUserRepository = ApiUserRepository(),
        super(Uninitialized());

  void checkAuthentication() async{
    try{
      final user = await _apiUserRepository.getAccessToken();
      if (user.id != null) {
        return emit(Authenticated(user));
      } else {
        return emit(Unauthenticated());
      }
    } catch(_){
      return emit(Unauthenticated());
    }
  }

  void login(User user){
    return emit(Authenticated(user));
  }

  void logout() async{
    await _apiUserRepository.signOut();
    return emit(Unauthenticated());
  }
}
