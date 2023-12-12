import 'package:flutter/material.dart';
import 'package:food_delivery_flutter_app/screens/sign_up_screen.dart';
import 'package:food_delivery_flutter_app/utils/shared_preferences_util.dart';

void logOut(BuildContext context){
  SharedPreferencesUtil.setLogin(false);
  SharedPreferencesUtil.setEmail("");
  SharedPreferencesUtil.setUserName("");
  SharedPreferencesUtil.clearAllFavoriteMeals();
  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => SignUpScreen()),
        (route) => false,
  );
}