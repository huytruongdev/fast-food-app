import 'package:flutter/material.dart';
import 'package:fast_food_app/Core/models/product_model.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodModel products;
  const FoodDetailScreen({super.key, required this.products});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leadingWidth: 80,
        forceMaterialTransparency: true,
        actions: [
          Spacer(),
          Container(
            height: 40,
            width: 40,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Icon(
              Icons.more_horiz_rounded,
              color: Colors.black,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
