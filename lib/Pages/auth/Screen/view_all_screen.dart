import 'package:flutter/material.dart';
import 'package:fast_food_app/Core/models/product_model.dart';
import 'package:fast_food_app/Widget/products_items_display.dart';

class ViewAllScreen extends StatelessWidget {
  final List<FoodModel> products;

  const ViewAllScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('All products'),
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        centerTitle: true,
      ),
      body: products.isEmpty
          ? const Center(child: Text('Không có sản phẩm nào'))
          : GridView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 30,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: ProductsItemsDisplay(foodModel: products[index]),
                );
              },
            ),
    );
  }
}
