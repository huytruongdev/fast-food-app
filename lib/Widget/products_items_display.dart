import 'package:fast_food_app/Core/Provider/favorite_provider.dart';
import 'package:fast_food_app/Core/Utils/format.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_food_app/Core/Utils/consts.dart';
import 'package:fast_food_app/Core/models/product_model.dart';
import 'package:fast_food_app/Pages/auth/Screen/food_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductsItemsDisplay extends StatelessWidget {
  final FoodModel foodModel;

  const ProductsItemsDisplay({super.key, required this.foodModel});

  static const double CARD_HEIGHT = 170;
  static const double CARD_WIDTH_FACTOR = 0.48;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return SizedBox(
      width: size.width * CARD_WIDTH_FACTOR + 2,
      height: CARD_HEIGHT + 60,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailScreen(products: foodModel),
            ),
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 10,
              child: Container(
                height: CARD_HEIGHT,
                width: size.width * CARD_WIDTH_FACTOR,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      spreadRadius: 10,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

            // ICON FIRE
            Positioned(
              top: 10,
              right: -5,
              child: GestureDetector(
                onTap: () {
                  favoriteProvider.toggleFavorite(foodModel.productId);
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: favoriteProvider.isExist(foodModel.productId)
                      ? Colors.red[100]
                      : Colors.transparent,
                  child: favoriteProvider.isExist(foodModel.productId)
                      ? Image.asset(
                          "assets/food-delivery/icon/fire.png",
                          height: 25,
                        )
                      : Icon(Icons.local_fire_department, color: red),
                ),
              ),
            ),
            // IMAGE
            Positioned(
              top: -10,
              child: Hero(
                tag: foodModel.imageCard,
                child: CachedNetworkImage(
                  imageUrl: foodModel.imageCard,
                  height: 180,
                  width: 160,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const SizedBox(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.fastfood, size: 120, color: Colors.grey),
                ),
              ),
            ),

            // PRODUCT DETAILS
            Positioned(
              bottom: 20,
              child: SizedBox(
                width: size.width * CARD_WIDTH_FACTOR,
                child: Column(
                  children: [
                    const SizedBox(height: 80),

                    // NAME
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        foodModel.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // SPECIAL ITEMS
                    Text(
                      foodModel.specialItems,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        letterSpacing: 0.5,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // PRICE
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: formatVND(foodModel.price.toInt()),
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
