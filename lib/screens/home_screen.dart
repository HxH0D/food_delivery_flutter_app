import 'package:flutter/material.dart';
import 'package:food_delivery_flutter_app/components/custom_card.dart';
import 'package:food_delivery_flutter_app/cubits/home_cubit.dart';
import 'package:food_delivery_flutter_app/models/food.dart';
import 'package:food_delivery_flutter_app/screens/detail_screen.dart';
import 'package:food_delivery_flutter_app/utils/colors.dart';
import 'package:food_delivery_flutter_app/utils/constans.dart';
import 'package:food_delivery_flutter_app/utils/shared_preferences_util.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedOption;

  var searcController = TextEditingController();
  bool search = false;

  @override
  void initState() {
    selectedOption = null;
    print("Çalıştı");
    context.read<HomeCubit>().getAllFoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeAddToCartState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ürün sepete eklendi'),
                duration:
                    Duration(milliseconds: 500), // Snackbar'ın görüntülenme süresi
              ),
            );
            context.read<HomeCubit>().getAllFoods();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.height() / 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Food Delivery \nApp",
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "User: ${SharedPreferencesUtil.getUserName()}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 100,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          logOut(context);
                        },
                        child: Text("Log Out"),
                      ),
                    ),
                  ],
                )

              ],
            ),

            SizedBox(
              height: context.height() / 40,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: context.width() / 1.15,
                height: context.height() / 16,
                child: TextField(
                  controller: searcController,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = null;
                    });
                    context.read<HomeCubit>().getSearchFoods(value);
                  },
                  cursorColor: primaryColor,
                  style: TextStyle(color: textColor1),
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: textColor1),
                    filled: true,
                    fillColor: secondaryColor,
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF222222), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: context.height() / 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Products",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                search
                    ? Container()
                    : DropdownButton<String>(
                        dropdownColor: secondaryColor,
                        hint: Text(
                          "Sort",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        value: selectedOption,
                        items: [
                          DropdownMenuItem(
                            child: Text('A-Z'),
                            value: 'A-Z',
                          ),
                          DropdownMenuItem(
                            child: Text('Z-A'),
                            value: 'Z-A',
                          ),
                          DropdownMenuItem(
                            child: Text('Price Ascending'),
                            value: 'Price Ascending',
                          ),
                          DropdownMenuItem(
                            child: Text('Price Descending'),
                            value: 'Price Descending',
                          ),
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            selectedOption = newValue as String?;
                            if (newValue == 'A-Z') {
                              context
                                  .read<HomeCubit>()
                                  .getSearchFoods(newValue);
                            } else if (newValue == 'Z-A') {
                              context
                                  .read<HomeCubit>()
                                  .getSearchFoods(newValue);
                            } else if (newValue == 'Price Ascending') {
                              context
                                  .read<HomeCubit>()
                                  .getSearchFoods(newValue);
                            } else if (newValue == 'Price Descending') {
                              context
                                  .read<HomeCubit>()
                                  .getSearchFoods(newValue);
                            }
                          });
                        },
                      )
              ],
            ),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoadedState) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // İki card yan yana
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        mainAxisExtent: 225,
                      ),
                      itemCount: state.yemekListesi.length,
                      itemBuilder: (context, index) {
                        Yemekler yemek = state.yemekListesi[index];
                        return CustomCard(
                          imageUrl:
                              "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemekResimAdi}",
                          title: yemek.yemekAdi!,
                          description: "Açıklama",
                          price: double.parse(yemek.yemekFiyat!),
                          favorite: false,
                          onFavoritePressed: () {
                            SharedPreferencesUtil.isMealFavorite(yemek.yemekAdi!)
                                .then((isFavorite) {
                              if (isFavorite) {
                                SharedPreferencesUtil.removeFavoriteMeal(yemek);
                              } else {
                                SharedPreferencesUtil.addFavoriteMeal(yemek);
                              }
                            });

                            // Buraya favori işlevini ekleyin
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    food: yemek,
                                  ),
                                ));
                            // Buraya kartın genel tıklama işlevini ekleyin
                          },
                          onAddPressed: () {
                            FocusScope.of(context).unfocus();
                            searcController.clear();
                            context.read<HomeCubit>().addToCart(yemek, 1);
                          },
                        );
                      },
                    );
                  } else if (state is HomeErrorState) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(), // Yükleme durumu
                    );
                  }
                },
              ),
            ),
          ],
        ).paddingOnly(
            top: context.width() / 21,
            left: context.width() / 21,
            right: context.width() / 21),
      ),
    );
  }
}
