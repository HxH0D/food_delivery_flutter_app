import 'package:food_delivery_flutter_app/models/basket_meals.dart';
import 'package:food_delivery_flutter_app/models/food.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_flutter_app/repositories/food_api_repository.dart';

// State'leri temsil eden sınıflar
abstract class OrderState {}

class OrderInitialState extends OrderState {}

class OrderLoadingState extends OrderState {}

class OrderLoadedState extends OrderState {
  final List<BasketMeal> foodList;

  OrderLoadedState(this.foodList);
}

class OrderErrorState extends OrderState {
  final String errorMessage;

  OrderErrorState(this.errorMessage);
}

// Cubit sınıfı
class OrderCubit extends Cubit<OrderState> {
  final FoodAPIRepository _apiRepository = FoodAPIRepository();

  OrderCubit() : super(OrderInitialState());

  // Tüm yemekleri getiren fonksiyon
  Future<void> getFoodsInCart() async {
    try {
      emit(OrderLoadingState());

      List<BasketMeal> foods = await _apiRepository.getFoodsInCart();
      emit(OrderLoadedState(foods));
    } catch (e) {
      // Hata durumunu yansıt
      emit(OrderErrorState("Error occurred: $e"));
    }
  }

  Future<void> deleteItemFromCart(List<BasketMeal> foodList, String kullaniciAdi, String foodName) async {
    try {
      if (state is OrderLoadedState) {
        await _apiRepository.deleteItemsByName(foodList, kullaniciAdi, foodName);
        getFoodsInCart();
      }
    } catch (e) {
      emit(OrderErrorState("Error occurred while deleting item: $e"));
    }
  }



}
