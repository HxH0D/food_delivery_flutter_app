import 'dart:convert';

import 'package:food_delivery_flutter_app/models/basket_meals.dart';
import 'package:food_delivery_flutter_app/models/food.dart';
import 'package:food_delivery_flutter_app/utils/common.dart';
import 'package:food_delivery_flutter_app/utils/shared_preferences_util.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class FoodAPIRepository {
  Future<List<Yemekler>> getAllFoods() async {
    try {
      var response = await Dio()
          .get('http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php');

      if (response.statusCode == 200) {
        Food food = Food.fromJson(
            json.decode(unicodeToTurkish(response.data.toString())));
        return food.yemekler ?? [];
      } else {
        throw Exception('Failed to load foods');
      }
    } catch (error) {
      throw Exception('Network error: $error');
    }
  }

  Future<List<BasketMeal>> getFoodsInCart() async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php";
    try {
      var data = {"kullanici_adi": SharedPreferencesUtil.getUserName()};
      var response = await Dio().post(url, data: FormData.fromMap(data));

      if (response.statusCode == 200) {
        var basketMeals = BasketMeals.fromJson(jsonDecode(response.data));
        print("Foods in cart fetched: ${response.data.toString()}");
        return basketMeals.sepetYemekler ?? [];
      } else {
        throw Exception('Failed to load foods');
      }
    } catch (error) {
      throw Exception('Network error: $error');
    }
  }

  Future<bool> addToCart(Yemekler food, int foodQuantity) async {
    try {
      final mealData = {
        'yemek_adi': food.yemekAdi,
        'yemek_resim_adi': food.yemekResimAdi,
        'yemek_fiyat': int.parse(food.yemekFiyat!),
        'yemek_siparis_adet': 1,
        'kullanici_adi': SharedPreferencesUtil.getUserName(),
      };

      Dio dio = Dio();

      for (int i = 0; i < foodQuantity; i++) {
        Response response = await dio.post(
          'http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php',
          data: FormData.fromMap(mealData),
        );

        if (response.statusCode != 200) {
          print('Error occurred, response code: ${response.statusCode}');
          return false;
        }
      }

      print('Food added to cart successfully');
      return true;
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<void> deleteItemsByName(List<BasketMeal> foodList, String kullaniciAdi, String foodName) async {
    Dio dio = Dio();
    List<int> idsList = [];

    for (var food in foodList) {
      if (food.yemekAdi == foodName) {
        idsList.add(int.parse(food.sepetYemekId!));
      }
    }

    for (int id in idsList) {
      try {
        final mealData = {
          'sepet_yemek_id': id,
          'kullanici_adi': kullaniciAdi,
        };
        Response response = await dio.post(
          'http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php',
          data: FormData.fromMap(mealData)
        );
        print('Deleted item with id $id. Response: ${response.data}');
      } catch (e) {
        print('Error deleting item with id $id: $e');
        throw Exception('Error deleting item with id $id: $e');
      }
    }
  }
}
