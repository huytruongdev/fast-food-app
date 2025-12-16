import 'dart:async';
import 'package:fast_food_app/Core/Utils/format.dart';
import 'package:fast_food_app/pages/auth/screens/view_all_screen.dart';
import 'package:flutter/material.dart';
import 'package:fast_food_app/Core/utils/consts.dart';
import 'package:fast_food_app/service/category_service.dart';
import 'package:fast_food_app/Core/models/categories_model.dart';
import 'package:fast_food_app/Core/models/product_model.dart';
import 'package:fast_food_app/service/product_service.dart';
import 'package:fast_food_app/widgets/products_items_display.dart';

class FoodAppHomeScreen extends StatefulWidget {
  const FoodAppHomeScreen({super.key});

  @override
  State<FoodAppHomeScreen> createState() => _FoodAppHomeScreenState();
}

class _FoodAppHomeScreenState extends State<FoodAppHomeScreen> {
  String selectedCategory = "all";
  List<FoodModel> bannerProducts = [];
  List<FoodModel> products = [];
  bool loadingProducts = false;
  bool isLoading = false;
  late Future<List<Category>> _categoriesFuture;
  int _currentIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchBannerProducts();
    _categoriesFuture = fetchCategories();
    _fetchProducts(selectedCategory);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (bannerProducts.isNotEmpty) {
        int nextPage = _currentIndex + 1;

        if (nextPage >= bannerProducts.length) {
          nextPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      }
    });
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
    products.take(6).toList();
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
                SizedBox(height: 20),
                viewAll(),
              ],
            ),
          ),
          _buildCategoryList(),
          SizedBox(height: 10),
          _buildProducts(),
        ],
      ),
    );
  }

  Future<void> _fetchBannerProducts() async {
    try {
      List<FoodModel> allProducts = await ProductService.getAllProducts();
      if (mounted) {
        setState(() {
          bannerProducts = allProducts.take(6).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          bannerProducts = [];
        });
      }
    }
  }

  Widget _buildProducts() {
    if (loadingProducts) {
      return const Center(child: CircularProgressIndicator());
    }
    if (products.isEmpty) {
      return const Center(child: Text("Không có sản phẩm nào"));
    }
    return SizedBox(
      height: 250,
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

  // Trong _FoodAppHomeScreenState
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
          final originalCategories = snapshot.data!;
          final allCategory = Category(
            categoryId: "all",
            name: "All",
            image: "assets/images/all_icon.png",
          );

          final categories = [allCategory, ...originalCategories];

          return SizedBox(
            height: 60,
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
                        vertical: 0,
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
                            child: category.categoryId == "all"
                                ? Icon(
                                    Icons.apps,
                                    size: 20,
                                    color: isSelected ? red : Colors.black,
                                  ) // Icon mặc định cho "All"
                                : Image.network(
                                    category.image,
                                    width: 20,
                                    height: 20,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.fastfood),
                                  ),
                          ),
                          const SizedBox(width: 10),
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
    if (bannerProducts.isEmpty) {
      return Container(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: imageBackground2,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: bannerProducts.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final food = bannerProducts[index];
                return _bannerItem(food);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              bannerProducts.length,
              (index) => _dotIndicator(index),
            ),
          ),
          SizedBox(height: 10),
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
          height: 50,
          width: 50,
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: grey1,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset("assets/images/flag_icon.png"),
        ),
        SizedBox(width: 25),
      ],
    );
  }

  Widget _dotIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentIndex == index ? 14 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentIndex == index ? Colors.orange : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _bannerItem(FoodModel food) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              food.imageCard,
              width: 160,
              height: 160,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    food.specialItems,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        formatVND(food.price.toInt()),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      Text(
                        food.rate.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
