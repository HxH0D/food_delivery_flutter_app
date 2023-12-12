import 'package:food_delivery_flutter_app/models/basket_meals.dart';

String unicodeToTurkish(String text) {
  text = text.replaceAll("\\u00e7", "ç");
  text = text.replaceAll("\\u00c7", "Ç");
  text = text.replaceAll("\\u011f", "ğ");
  text = text.replaceAll("\\u011e", "Ğ");
  text = text.replaceAll("\\u0131", "ı");
  text = text.replaceAll("\\u0130", "İ");
  text = text.replaceAll("\\u00f6", "ö");
  text = text.replaceAll("\\u00d6", "Ö");
  text = text.replaceAll("\\u015f", "ş");
  text = text.replaceAll("\\u015e", "Ş");
  text = text.replaceAll("\\u00fc", "ü");
  text = text.replaceAll("\\u00dc", "Ü");
  return text;
}



int calculateTotalCount(List<BasketMeal> foodList, String targetFoodName) {
  int totalCount = 0;
  for (int i = 0; i < foodList.length; i++) {
    if (foodList[i].yemekAdi == targetFoodName) {
      totalCount++;
    }
  }
  return totalCount;
}

int calculateTotalPrice(List<BasketMeal> foodList) {
  int totalPrice = 0;
  for (int i = 0; i < foodList.length; i++) {
    int itemPrice = int.parse(foodList[i].yemekFiyat!);
    totalPrice += itemPrice;
  }
  return totalPrice;
}


List<String> getUniqueFoodNames(List<BasketMeal> foodList) {
  Set<String> uniqueNames = Set<String>();
  for (int i = 0; i < foodList.length; i++) {
    uniqueNames.add(foodList[i].yemekAdi!);
  }
  return uniqueNames.toList();
}

