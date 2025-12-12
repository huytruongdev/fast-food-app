import 'package:flutter/material.dart';
import 'package:fast_food_app/Core/Utils/consts.dart';
import 'package:fast_food_app/Pages/auth/Screen/view_all_screen.dart';
import 'package:fast_food_app/Service/category_service.dart';
import 'package:fast_food_app/Core/models/categories_model.dart';
import 'package:fast_food_app/Core/models/product_model.dart';
import 'package:fast_food_app/Service/product_service.dart';
import 'package:fast_food_app/Widget/products_items_display.dart';

class FoodAppHomeScreen extends StatefulWidget {
  const FoodAppHomeScreen({super.key});

  @override
  State<FoodAppHomeScreen> createState() => _FoodAppHomeScreenState();
}

class _FoodAppHomeScreenState extends State<FoodAppHomeScreen> {
  String selectedCategory = "all";
  List<FoodModel> products = [];
  bool loadingProducts = false;
  bool isLoading = false;
  late Future<List<Category>> _categoriesFuture;


  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories();
    _fetchProducts(selectedCategory);
  }

  Future<void> _fetchProducts(String categoryId) async {
    if (mounted) {
      setState(() {
        loadingProducts = true;
        if (selectedCategory != categoryId) {
          selectedCategory = categoryId;
        }
      });
    }
    try {
      List<FoodModel> result;
      if (categoryId == "all") {
        result = await ProductService.getAllProducts();
      } else {
        result = await ProductService.getProductsByCategory(categoryId);
      }
      if (mounted) {
        setState(() {
          products = result;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          products = [];
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          loadingProducts = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarParts(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBanners(),
                SizedBox(height: 25),
                Text(
                  "Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _buildCategoryList(),
          SizedBox(height: 20),
          viewAll(),
          SizedBox(height: 10),
          _buildProducts(),
        ],
      ),
    );
  }

  Widget _buildProducts() {
    if (loadingProducts) {
      return const Center(child: CircularProgressIndicator());
    }
    if (products.isEmpty) {
      return const Center(child: Text("Không có sản phẩm nào theo Thể loại"));
    }
    return SizedBox(
      height: 270, 
      child: ListView.builder(
        itemCount: products.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          const double spacing = 20;
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 20 : spacing,
              right: index == products.length - 1 ? 25 : 0,
            ),
            child: ProductsItemsDisplay(foodModel: products[index]),
          );
        },
      ),
    );
  }

  Widget _buildCategoryList() {
    return FutureBuilder<List<Category>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi tải danh mục: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không tìm thấy danh mục nào'));
        } else {
          final categories = snapshot.data!;
          return SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category.categoryId;

                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 15 : 0,
                    right: 15,
                  ),
                  child: GestureDetector(
                    onTap: () => _fetchProducts(category.categoryId),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? red : grey1,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              category.image,
                              width: 20,
                              height: 20,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.fastfood),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            category.name,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Container appBanners() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: imageBackground2,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.only(top: 25, right: 25, left: 25),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: "The Fastest In Delivery ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "Food",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                  child: Text(
                    "Order Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Image.asset("assets/food-delivery/courier.png"),
        ],
      ),
    );
  }

  Padding viewAll() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Popular Now",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewAllScreen(),
                      // ViewAllScreen(products: products), 
                ),
              );
            },
            child: Row(
              children: [
                Text("View All", style: TextStyle(color: orange)),
                SizedBox(width: 5),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar appbarParts() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      actions: [
        SizedBox(width: 25),
        Container(
          height: 45,
          width: 45,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: grey1,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset("assets/food-delivery/icon/dash.png"),
        ),
        Spacer(),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 20, color: red),
            SizedBox(width: 5),
            Text(
              "Tp. Hồ Chí Minh, Việt Nam",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 5),
            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: orange),
          ],
        ),
        Spacer(),
        Container(
          height: 45,
          width: 45,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: grey1,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset("assets/food-delivery/profile.png"),
        ),
        SizedBox(width: 25),
      ],
    );
  }
}
