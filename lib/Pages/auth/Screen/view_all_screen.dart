import 'package:fast_food_app/Core/Provider/products_pagination_provider.dart';
import 'package:fast_food_app/Widget/products_items_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAllScreen extends StatefulWidget {
  const ViewAllScreen({super.key});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductPaginationProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductPaginationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("All Products"),backgroundColor: Colors.white,),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!provider.isLoading &&
              provider.hasMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            provider.loadProducts();
          }
          return true;
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: provider.products.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 30,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            if (index == provider.products.length) {
              return provider.hasMore
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox();
            }

            final item = provider.products[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ProductsItemsDisplay(foodModel: item),
            );
          },
        ),
      ),
    );
  }
}


