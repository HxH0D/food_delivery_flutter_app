import 'package:food_delivery_flutter_app/models/food.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_flutter_app/repositories/food_api_repository.dart';

// State'leri temsil eden sınıflar
abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<Yemekler> yemekListesi;

  HomeLoadedState(this.yemekListesi);
}

class HomeErrorState extends HomeState {
  final String errorMessage;

  HomeErrorState(this.errorMessage);
}

class HomeAddToCartState extends HomeState {
  final bool isAdded;

  HomeAddToCartState(this.isAdded);
}

class HomeCartLengthState extends HomeState {
  final int cartLength;

  HomeCartLengthState(this.cartLength);
}

// Cubit sınıfı
class HomeCubit extends Cubit<HomeState> {
  final FoodAPIRepository _apiRepository = FoodAPIRepository();

  HomeCubit() : super(HomeInitialState());

  // Tüm yemekleri getiren fonksiyon
  Future<void> getAllFoods() async {
    try {
      emit(HomeLoadingState()); // Yükleme durumunu yansıt

      List<Yemekler> foods = await _apiRepository.getAllFoods();
      emit(HomeLoadedState(foods)); // Veri geldiğinde yüklenmiş durumu yansıt
    } catch (e) {
      // Hata durumunu yansıt
      emit(HomeErrorState("Error occurred: $e"));
    }
  }
  Future<void> getSearchFoods(String? selectedOption) async {
    try {
      emit(HomeLoadingState()); // Yükleme durumunu yansıt

      List<Yemekler> allFoods = await _apiRepository.getAllFoods();
      List<Yemekler> filteredFoods = [];

      if (selectedOption == 'A-Z') {
        filteredFoods = allFoods..sort((a, b) => a.yemekAdi!.compareTo(b.yemekAdi!));
      } else if (selectedOption == 'Z-A') {
        filteredFoods = allFoods..sort((a, b) => b.yemekAdi!.compareTo(a.yemekAdi!));
      } else if (selectedOption == 'Price Ascending') {
        filteredFoods = List.from(allFoods)..sort((a, b) => int.parse(a.yemekFiyat!) - int.parse(b.yemekFiyat!));
      } else if (selectedOption == 'Price Descending') {
        filteredFoods = List.from(allFoods)..sort((a, b) => int.parse(b.yemekFiyat!) - int.parse(a.yemekFiyat!));
      }else{
        filteredFoods = allFoods
            .where((food) =>
            food.yemekAdi!.toLowerCase().startsWith(selectedOption!.toLowerCase()))
            .toList();
      }

      emit(HomeLoadedState(filteredFoods)); // Arama sonucunu yansıt
    } catch (e) {
      // Hata durumunu yansıt
      emit(HomeErrorState("Error occurred: $e"));
    }
  }


  // Sepete yemek ekleyen fonksiyon
  Future<void> addToCart(Yemekler food, int foodQuantity) async {
    try {
      var add = await _apiRepository.addToCart(food, foodQuantity);
      emit(HomeAddToCartState(add));
    } catch (e) {
      // Hata durumunu yansıt
      emit(HomeErrorState("Error occurred: $e"));
    }
  }




}
