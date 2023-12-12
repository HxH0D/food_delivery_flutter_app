import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_flutter_app/repositories/user_auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_flutter_app/utils/shared_preferences_util.dart';
enum SignUpStatus { initial, success, failure, noAccountFound, }

class SignUpCubit extends Cubit<SignUpStatus> {
  SignUpCubit() : super(SignUpStatus.initial);

  UserAuthRepository _authRepository = UserAuthRepository();


  Future<void> singUp(String email, String password) async{
    try{
      emit(SignUpStatus.initial);
      var user = await _authRepository.signUp(email, password);
      if (user != null) {
        print(user);
        SharedPreferencesUtil.setUserName(user.userName);
        SharedPreferencesUtil.setEmail(user.email);
        SharedPreferencesUtil.setLogin(true);
        emit(SignUpStatus.success);
      } else {
        emit(SignUpStatus.failure);
      }
    }catch(e){
      emit(SignUpStatus.failure);
      print("Error $e");
    }

  }

  Future<void> signUpWithGoogle() async{
    try{
      emit(SignUpStatus.initial);
      var userCredential = await _authRepository.signUpWithGoogle();
      if (userCredential != null) {
        String defaultUsername = userCredential.user!.email!.split('@').first;
        SharedPreferencesUtil.setUserName(defaultUsername);
        SharedPreferencesUtil.setEmail(userCredential.user!.email!);
        SharedPreferencesUtil.setLogin(true);
        emit(SignUpStatus.success);
      } else {
        emit(SignUpStatus.failure);
      }
    }catch(e){
      emit(SignUpStatus.failure);
      print("Error $e");
    }
  }

}