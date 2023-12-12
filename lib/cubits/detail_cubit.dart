import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_flutter_app/cubits/home_cubit.dart';
import 'package:food_delivery_flutter_app/models/food.dart';
import 'package:food_delivery_flutter_app/repositories/food_api_repository.dart';

class DetailState{

}

class DetailInitialState extends DetailState {}

class DetailAddToState extends DetailState{
  final bool isAdded;

  DetailAddToState(this.isAdded);
}

class DetailErrorState extends DetailState {
  final String errorMessage;

  DetailErrorState(this.errorMessage);
}




class DetailCubit extends Cubit<DetailState>{
  DetailCubit() : super(DetailInitialState());

  final FoodAPIRepository _apiRepository = FoodAPIRepository();


  // Sepete yemek ekleyen fonksiyon
  Future<void> addToCart(Yemekler food, int foodQuantity) async {
    try {
      var add = await _apiRepository.addToCart(food, foodQuantity);
      emit(DetailAddToState(add));
    } catch (e) {
      // Hata durumunu yansıt
      emit(DetailErrorState("Error occurred: $e"));
    }
  }


}