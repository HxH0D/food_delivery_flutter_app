import 'package:flutter/material.dart';
import 'package:food_delivery_flutter_app/utils/colors.dart';
import 'package:food_delivery_flutter_app/utils/widgets.dart';

class CustomCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onTap;
  final VoidCallback? onAddPressed;
  final bool favorite;

  const CustomCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    this.onFavoritePressed,
    this.onTap,
    this.onAddPressed,
    required this.favorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.40,
        height: MediaQuery.of(context).size.height / 4,
        padding: const EdgeInsets.symmetric(horizontal: 12.00, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFF130B1C),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomAnimatedButton(
              child: Container(
                width: 18,
                height: 18,
                child: Center(
                  child: Icon(
                      favorite ? Icons.favorite_outlined : Icons.favorite_border,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              onPressed: onFavoritePressed,
            ),
            const SizedBox(height: 4),
            Container(
              height: MediaQuery.of(context).size.height / 10,
              child: Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₺ ${price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                CustomAnimatedButton(
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  onPressed: onAddPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
