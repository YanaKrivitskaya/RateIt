import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rateit/database/api_user_repository.dart';
import 'package:rateit/models/user.model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ApiUserRepository _apiUserRepository;

  ProfileCubit() :
        _apiUserRepository = ApiUserRepository(),
        super(ProfileInitial());


  void getProfile() async{
    emit(ProfileStateLoading(null));
    try{
      var user = await _apiUserRepository.getUser();
      emit(ProfileStateSuccess(user));
    }catch(e){
      emit(ProfileStateError(null, e.toString()));
    }

  }
}
