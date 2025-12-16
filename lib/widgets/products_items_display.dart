// import 'package:fast_food_app/Core/providers/favorite_provider.dart';
// import 'package:fast_food_app/Core/utils/format.dart';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:fast_food_app/Core/utils/consts.dart';
// import 'package:fast_food_app/Core/models/product_model.dart';
// import 'package:fast_food_app/pages/auth/screens/food_detail_screen.dart';
// import 'package:provider/provider.dart';

// class ProductsItemsDisplay extends StatelessWidget {
//   final FoodModel foodModel;

//   const ProductsItemsDisplay({super.key, required this.foodModel});

//   static const double CARD_HEIGHT = 150;
//   static const double CARD_WIDTH_FACTOR = 0.48;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     final favoriteProvider = Provider.of<FavoriteProvider>(context);

//     return SizedBox(
//       width: size.width * CARD_WIDTH_FACTOR + 2,
//       height: CARD_HEIGHT + 60,
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => FoodDetailScreen(products: foodModel),
//             ),
//           );
//         },
//         child: Stack(
//           clipBehavior: Clip.none,
//           alignment: Alignment.center,
//           children: [
//             Positioned(
//               bottom: 10,
//               child: Container(
//                 height: CARD_HEIGHT,
//                 width: size.width * CARD_WIDTH_FACTOR,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withAlpha(40),
//                       spreadRadius: 10,
//                       blurRadius: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // ICON FIRE
//             Positioned(
//               top: 10,
//               right: -5,
//               child: GestureDetector(
//                 onTap: () {
//                   favoriteProvider.toggleFavorite(foodModel.productId);
//                 },
//                 child: CircleAvatar(
//                   radius: 15,
//                   backgroundColor: favoriteProvider.isExist(foodModel.productId)
//                       ? Colors.red[100]
//                       : Colors.transparent,
//                   child: favoriteProvider.isExist(foodModel.productId)
//                       ? Image.asset(
//                           "assets/food-delivery/icon/fire.png",
//                           height: 25,
//                         )
//                       : Icon(Icons.local_fire_department, color: red),
//                 ),
//               ),
//             ),
//             // IMAGE
//             Positioned(
//               top: -10,
//               child: Hero(
//                 tag: foodModel.imageCard,
//                 child: CachedNetworkImage(
//                   imageUrl: foodModel.imageCard,
//                   height: 160,
//                   width: 160,
//                   fit: BoxFit.contain,
//                   placeholder: (context, url) => const SizedBox(
//                     height: 150,
//                     child: Center(
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   ),
//                   errorWidget: (context, url, error) =>
//                       const Icon(Icons.fastfood, size: 120, color: Colors.grey),
//                 ),
//               ),
//             ),

//             // PRODUCT DETAILS
//             Positioned(
//               bottom: 20,
//               child: SizedBox(
//                 width: size.width * CARD_WIDTH_FACTOR,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 80),

//                     // NAME
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Text(
//                         foodModel.name,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),

//                     // SPECIAL ITEMS
//                     Text(
//                       foodModel.specialItems,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         letterSpacing: 0.5,
//                         fontSize: 15,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 10),

//                     // PRICE
//                     RichText(
//                       text: TextSpan(
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                         children: [
//                           TextSpan(
//                             text: formatVND(foodModel.price.toInt()),
//                             style: const TextStyle(
//                               fontSize: 25,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async'; // ⭐️ CẦN IMPORT NÀY
import 'package:fast_food_app/Core/Utils/consts.dart';
import 'package:fast_food_app/Core/Utils/format.dart';
import 'package:fast_food_app/Core/models/product_model.dart';
import 'package:fast_food_app/Core/providers/favorite_provider.dart';
import 'package:fast_food_app/Pages/auth/screens/food_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class ProductsItemsDisplay extends StatefulWidget {
  final FoodModel foodModel;

  const ProductsItemsDisplay({super.key, required this.foodModel});

  static const double CARD_HEIGHT = 150;
  static const double CARD_WIDTH_FACTOR = 0.48;

  @override
  State<ProductsItemsDisplay> createState() => _ProductsItemsDisplayState();
}

class _ProductsItemsDisplayState extends State<ProductsItemsDisplay> {
  Timer? _saleTimer;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    if (widget.foodModel.isSaleActive) {
      _timeRemaining = widget.foodModel.saleEndTime!.difference(DateTime.now());

      _saleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _timeRemaining = widget.foodModel.saleEndTime!.difference(
              DateTime.now(),
            );

            if (_timeRemaining.isNegative) {
              _timeRemaining = Duration.zero;
              _saleTimer?.cancel();
            }
          });
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds < 0) return "00:00:00";

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inDays > 0) {
      return "${duration.inDays}d ${hours}h";
    }
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _saleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.foodModel;
    Size size = MediaQuery.of(context).size;
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    final bool activeSale = food.isSaleActive && _timeRemaining > Duration.zero;

    const double CARD_HEIGHT = ProductsItemsDisplay.CARD_HEIGHT;
    const double CARD_WIDTH_FACTOR = ProductsItemsDisplay.CARD_WIDTH_FACTOR;

    return SizedBox(
      width: size.width * CARD_WIDTH_FACTOR + 2,
      height: CARD_HEIGHT + 60,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailScreen(products: food),
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
                child: null,
              ),
            ),
            Positioned(
              top: -10,
              child: Hero(
                tag: food.imageCard,
                child: CachedNetworkImage(
                  imageUrl: food.imageCard,
                  height: 160,
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

            if (activeSale)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(173, 223, 4, 4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "-${food.salePercentage!.toInt()}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

            Positioned(
              top: 10,
              right: -5,
              child: GestureDetector(
                onTap: () {
                  favoriteProvider.toggleFavorite(food.productId);
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: favoriteProvider.isExist(food.productId)
                      ? Colors.red[100]
                      : Colors.transparent,
                  child: favoriteProvider.isExist(food.productId)
                      ? Image.asset(
                          "assets/food-delivery/icon/fire.png",
                          height: 25,
                        )
                      : Icon(Icons.local_fire_department, color: red),
                ),
              ),
            ),

            // PRODUCT DETAILS & PRICE/TIMER
            Positioned(
              bottom: 20,
              child: SizedBox(
                width: size.width * CARD_WIDTH_FACTOR,
                child: Column(
                  children: [
                    const SizedBox(height: 80),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        food.name,
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
                      food.specialItems,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        letterSpacing: 0.5,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: activeSale
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (activeSale)
                                Text(
                                  formatVND(food.price.toInt()),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              Text(
                                formatVND(
                                  activeSale
                                      ? food.finalPrice.toInt()
                                      : food.price.toInt(),
                                ),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: activeSale ? red : Colors.black,
                                ),
                              ),
                            ],
                          ),

                          if (activeSale)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                _formatDuration(_timeRemaining),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
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
