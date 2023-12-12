import 'package:flutter/material.dart';
import 'package:food_delivery_flutter_app/cubits/detail_cubit.dart';
import 'package:food_delivery_flutter_app/models/food.dart';
import 'package:food_delivery_flutter_app/utils/colors.dart';
import 'package:food_delivery_flutter_app/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailScreen extends StatefulWidget {
  Yemekler food;

  DetailScreen({super.key, required this.food});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int counter = 1;

  @override
  void initState() {
    print("Çalıştı");
    //context.read<HomeCubit>().getAllFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.network(
                "http://kasimadalan.pe.hu/yemekler/resimler/${widget.food.yemekResimAdi}",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            width: context.width(),
            height: context.height() / 1.75,
            child: Column(
              children: [
                Text(
                  "${widget.food.yemekAdi}",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: context.height() / 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.food.yemekFiyat} ₺",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      width: 120,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomAnimatedButton(
                            onPressed: () {
                              if (counter > 1) {
                                setState(() {
                                  counter--;
                                });
                              }
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "$counter",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          CustomAnimatedButton(
                            onPressed: () {
                              setState(() {
                                counter++;
                              });
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ).paddingAll(4),
                    )
                  ],
                ),
                Spacer(),
                BlocListener<DetailCubit, DetailState>(
                  listener: (context, state) {
                    if (state is DetailAddToState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ürün sepete eklendi'),
                          duration: Duration(
                              seconds: 2), // Snackbar'ın görüntülenme süresi
                        ),
                      );

                    }
                  },
                  child: CustomAnimatedButton(
                    onPressed: () {
                      print(counter);
                      context.read<DetailCubit>().addToCart(widget.food, counter);
                    },
                    child: Container(
                      width: context.width(),
                      height: context.height() / 15,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                          child: Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      )),
                    ),
                  ),
                ),
              ],
            ).paddingAll(24),
          ),
        ],
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
