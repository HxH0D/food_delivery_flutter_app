import 'package:flutter/material.dart';
import 'package:food_delivery_flutter_app/components/order_card.dart';
import 'package:food_delivery_flutter_app/cubits/order_cubit.dart';
import 'package:food_delivery_flutter_app/models/basket_meals.dart';
import 'package:food_delivery_flutter_app/utils/colors.dart';
import 'package:food_delivery_flutter_app/utils/common.dart';
import 'package:food_delivery_flutter_app/utils/shared_preferences_util.dart';
import 'package:food_delivery_flutter_app/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<OrderCubit>().getFoodsInCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding:
        const EdgeInsets.only(top: 140, left: 25, right: 25, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order derails",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoadedState) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // Tek card gösterilecek
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 100,
                      ),
                      itemCount: getUniqueFoodNames(state.foodList).length,
                      itemBuilder: (context, index) {
                        String uniqueFoodName = getUniqueFoodNames(state.foodList)[index];

                        BasketMeal firstFoodWithUniqueName = state.foodList.firstWhere(
                                (food) => food.yemekAdi == uniqueFoodName,
                            orElse: () => BasketMeal(yemekAdi: "", yemekFiyat: "", yemekResimAdi: "")
                        );

                        return OrderCardWidget(
                          totalPrice: int.parse(firstFoodWithUniqueName.yemekFiyat!) * calculateTotalCount(state.foodList, firstFoodWithUniqueName.yemekAdi!),
                          imageName: firstFoodWithUniqueName.yemekResimAdi!,
                          title: firstFoodWithUniqueName.yemekAdi!,
                          price: int.parse(firstFoodWithUniqueName.yemekFiyat!),
                          counter: calculateTotalCount(state.foodList, firstFoodWithUniqueName.yemekAdi!),
                          onDeleteAll: () {
                           context.read<OrderCubit>().deleteItemFromCart(state.foodList, SharedPreferencesUtil.getUserName(), firstFoodWithUniqueName.yemekAdi!);
                          },

                        );
                      },
                    );
                  } else if (state is OrderErrorState) {
                    return Center(
                      child: Container(),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(), // Yükleme durumu
                    );
                  }
                },
              ),
            ),
            Container(
              width: context.width(),
              height: 210,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Stack(
                  children: [
                    SizedBox(
                        width: context.width(),
                        child: Image.asset(
                          "assets/images/foods-image.png",
                          color: Color(0xFF2A2C38),
                          fit: BoxFit.fitWidth,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                BlocBuilder<OrderCubit, OrderState>(
                                  builder: (context, state) {
                                    if (state is OrderLoadedState) {
                                      int totalPrice = calculateTotalPrice(state.foodList);
                                      return Text(
                                        "$totalPrice ₺",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      );
                                    } else if (state is OrderErrorState) {
                                      return Text(
                                        "0₺",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(), // Yükleme durumu
                                      );
                                    }
                                  },
                                ),

                              ],
                            ),
                          ),
                          Spacer(),
                          CustomAnimatedButton(
                            child: Container(
                              width: context.width(),
                              height: context.height() / 15,
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Text(
                                  "Place My Order",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios_new,
          color: primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
