import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_flutter_app/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      var userCredential =  await FirebaseAuth.instance.signInWithCredential(credential);

      String email = userCredential.user!.email ?? '';
      String defaultUsername = email.split('@').first;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': userCredential.user!.email,
        'username': defaultUsername,
      });

      return userCredential;
    } catch (e) {
      print(e);
      return null;

    }
  }

  Future<bool> signIn(String email, String password, String userName) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'password': password,
        'username': userName,
      });
      print("Kullanıcı Oluşturuldu ${userCredential.user!.uid}");
      return true;
    } catch (error) {
      print("Hata Oluştu $error");
      return false;
    }
  }

  Future<UserModel?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Kullanıcı verilerini Firestore'dan al
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          // Firestore'dan kullanıcı verilerini al ve UserModel'e dönüştür
          UserModel userModel = UserModel(
            userName: userDoc['username'],
            email: userDoc['email'],
            password: userDoc['password'],
          );

          print("Giriş başarılı: ${userModel.userName}");
          // Kullanıcı verilerini döndür
          return userModel;
        } else {
          // Kullanıcı belirtilen verilerle bulunamadı
          print("Kullanıcı bulunamadı.");
          return null;
        }
      } else {
        // Kullanıcı girişi başarısız oldu
        print("Giriş başarısız.");
        return null;
      }
    } catch (error) {
      print("Hata Oluştu: $error");
      return null;
    }
  }



}
