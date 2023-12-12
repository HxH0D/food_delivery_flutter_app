import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_flutter_app/repositories/user_auth_repository.dart';
import 'package:food_delivery_flutter_app/utils/shared_preferences_util.dart';

enum SignInStatus { initial, success, failure }

class SignInCubit extends Cubit<SignInStatus>{
  SignInCubit(): super(SignInStatus.initial);



  UserAuthRepository _authRepository  = UserAuthRepository();

  Future<void> singIn(String email, String password, String userName) async{
    try{
      emit(SignInStatus.initial);
      bool login = await _authRepository.signIn(email, password, userName);
      if (login) {

        emit(SignInStatus.success);
      } else {
        emit(SignInStatus.failure);
      }
    }catch(e){
      emit(SignInStatus.failure);
      print("Error $e");
    }
  }




}