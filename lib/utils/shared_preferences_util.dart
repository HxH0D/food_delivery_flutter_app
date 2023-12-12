import 'dart:convert';
import 'dart:ffi';

import 'package:food_delivery_flutter_app/models/food.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static late SharedPreferences _preferences;

  static const String _keyUserName = 'userName';
  static const String _keyPassword = 'password';
  static const String _keyEmail = 'email';
  static const String _login = 'login';

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setLogin(bool login) async {
    await _preferences.setBool(_login, login);
  }

  static bool getLogin() {
    return _preferences.getBool(_login) ?? false;
  }

  static Future<void> setUserName(String userName) async {
    await _preferences.setString(_keyUserName, userName);
  }

  static String getUserName() {
    return _preferences.getString(_keyUserName) ?? '';
  }

  static Future<void> setPassword(String password) async {
    await _preferences.setString(_keyPassword, password);
  }

  static String getPassword() {
    return _preferences.getString(_keyPassword) ?? '';
  }

  static Future<void> setEmail(String email) async {
    await _preferences.setString(_keyEmail, email);
  }

  static String getEmail() {
    return _preferences.getString(_keyEmail) ?? '';
  }

  static const _keyFavoriteMeals = 'favorite_meals';

  // Favori yemekler listesini kaydetmek için
  static Future<bool> saveFavoriteMeals(List<Yemekler> meals) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> serializedMeals = meals.map((meal) => meal.toJson()).toList();
    final List<String> serializedStringMeals = serializedMeals.map((meal) => jsonEncode(meal)).toList();
    return await prefs.setStringList(_keyFavoriteMeals, serializedStringMeals);
  }

  static Future<void> addFavoriteMeal(Yemekler meal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> serializedMeals = prefs.getStringList(_keyFavoriteMeals) ?? [];

    serializedMeals.add(jsonEncode(meal.toJson()));
    await prefs.setStringList(_keyFavoriteMeals, serializedMeals);
  }

// Favori yemekler listesini almak için
  static Future<List<Yemekler>> getFavoriteMeals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? serializedMeals = prefs.getStringList(_keyFavoriteMeals);

    if (serializedMeals == null) {
      return [];
    }

    List<Yemekler> meals = serializedMeals.map((meal) => Yemekler.fromJson(jsonDecode(meal))).toList();
    return meals;
  }

  static Future<bool> removeFavoriteMeal(Yemekler meal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> serializedMeals = prefs.getStringList(_keyFavoriteMeals) ?? [];

    // Favori yemekleri string olarak sakladığınızı varsayalım
    String mealString = jsonEncode(meal.toJson());

    if (serializedMeals.contains(mealString)) {
      serializedMeals.remove(mealString);
      await prefs.setStringList(_keyFavoriteMeals, serializedMeals);
      return true; // Başarılı bir şekilde silindiğini bildir
    }

    return false; // Silinmek istenen öğe listede bulunamadı
  }

  static Future<bool> clearAllFavoriteMeals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_keyFavoriteMeals);
  }

  static Future<bool> isMealFavorite(String mealName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> serializedMeals = prefs.getStringList(_keyFavoriteMeals) ?? [];

    for (String mealString in serializedMeals) {
      Map<String, dynamic> mealJson = jsonDecode(mealString);
      if (mealJson['yemek_adi'] == mealName) {
        return true;
      }
    }

    return false;
  }
}
