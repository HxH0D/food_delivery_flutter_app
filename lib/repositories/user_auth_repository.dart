import 'package:food_delivery_flutter_app/models/user_model.dart';
import 'package:food_delivery_flutter_app/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
class UserAuthRepository {

  final FirebaseServices _firebaseService = FirebaseServices();

  Future<bool> signIn(String email, String password, String userName) async{
    return await _firebaseService.signIn(email, password, userName);
  }

  Future<UserModel?> signUp(String email, String password) async{
    return await _firebaseService.signUp(email, password);
  }

  Future<UserCredential?> signUpWithGoogle()async{
    return await _firebaseService.signUpWithGoogle();
  }





}