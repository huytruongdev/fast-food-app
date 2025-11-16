import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_food_app/Core/Utils/consts.dart';
import 'package:fast_food_app/Core/models/product_model.dart';
import 'package:fast_food_app/Pages/auth/Screen/food_detail_screen.dart';


class ProductsItemsDisplay extends StatefulWidget {
  final FoodModel foodModel;
  const ProductsItemsDisplay({super.key, required this.foodModel});

  @override
  State<ProductsItemsDisplay> createState() => _ProductsItemsDisplayState();
}

class _ProductsItemsDisplayState extends State<ProductsItemsDisplay> {
  static const double CARD_HEIGHT = 200;
  static const double CARD_WIDTH_FACTOR = 0.48;
  // static const double IMAGE_HEIGHT = 100;
  // static const double IMAGE_WIDTH = 200;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * CARD_WIDTH_FACTOR + 2,
      height: CARD_HEIGHT + 60,
      // color: const Color.fromARGB(255, 223, 226, 228),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailScreen(products: widget.foodModel),
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
            Positioned(
              top: 10,
              right: 5,
              child: GestureDetector(
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.red[100],
                  child: Image.asset(
                    "assets/food-delivery/icon/fire.png",
                    height: 30,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -10,
              child: Hero(
                tag: widget.foodModel.imageCard,
                child: CachedNetworkImage(
                  imageUrl: widget.foodModel.imageCard,
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
            Positioned(
              bottom: 20,
              child: SizedBox(
                width: size.width * CARD_WIDTH_FACTOR,
                child: Column(
                  children: [
                    const SizedBox(height: 80), // chừa khoảng cho hình trồi lên
                    // TÊN
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        widget.foodModel.name,
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
                      widget.foodModel.specialItems,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        letterSpacing: 0.5,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // GIÁ
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: "${widget.foodModel.price}",
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "đ",
                            style: TextStyle(fontSize: 14, color: red),
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
