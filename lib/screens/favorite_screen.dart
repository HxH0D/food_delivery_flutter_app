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

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String? selectedOption;

  @override
  void initState() {
    selectedOption = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: context.height() / 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Favorites",
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.height() / 40,
          ),
          SizedBox(
            height: context.height() / 40,
          ),
          const Text(
            "Favorite Products",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Yemekler>>(
              future: SharedPreferencesUtil.getFavoriteMeals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata oluştu: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(
                    'Favori yemek yok',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white),
                  ));
                } else {
                  List<Yemekler> favoriteMeals = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // İki card yan yana
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      mainAxisExtent: 225,
                    ),
                    itemBuilder: (context, index) {
                      if (index < favoriteMeals.length) {
                        Yemekler yemek = favoriteMeals[index];
                        return CustomCard(
                          imageUrl:
                              "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemekResimAdi}",
                          title: yemek.yemekAdi!,
                          description: "Açıklama",
                          price: double.parse(yemek.yemekFiyat!),
                          onFavoritePressed: () {},
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
                          favorite: true,
                          onAddPressed: () {
                            FocusScope.of(context).unfocus();
                            context.read<HomeCubit>().addToCart(yemek, 1);
                          },
                        );
                      }
                    },
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
    );
  }
}
