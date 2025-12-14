import 'package:fast_food_app/Core/providers/cart_provider.dart';
import 'package:fast_food_app/pages/auth/screens/user_activities/cart_screen.dart';
import 'package:fast_food_app/pages/auth/screens/food_app_home_screen.dart';
import 'package:fast_food_app/pages/auth/screens/profile_screen.dart';
import 'package:fast_food_app/pages/auth/screens/user_activities/favorite_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fast_food_app/Core/utils/consts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int currentIndex = 0;
  final List<Widget> _pages = [
    FoodAppHomeScreen(),
    FavoriteScreen(),
    ProfileScreen(),
    CartScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initCartData();
  }

  Future<void> _initCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");
    
    if (userId != null && userId.isNotEmpty && mounted) {
      Provider.of<CartProvider>(context, listen: false).loadCart(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItems(Iconsax.home_15, "A", 0),
            SizedBox(width:5),
            _buildNavItems(Iconsax.heart, "B", 1),
            SizedBox(width:50),
            _buildNavItems(Icons.person_outline, "C", 2,),
            SizedBox(width:0),
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildNavItems(Iconsax.shopping_cart, "D", 3),
                Positioned(
                  right: -7,
                  top: 16,
                  child: Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      if (cart.totalQuantity == 0) return const SizedBox();

                      return CircleAvatar(
                        backgroundColor: red,
                        radius: 10,
                        child: Text(
                          "${cart.totalQuantity}",
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 145,
                  top: -20,
                  width: 50,
                  child: CircleAvatar(
                    backgroundColor: red,
                    radius: 35,
                    child: Icon(
                      CupertinoIcons.search,
                      size:35,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItems(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: currentIndex == index ? Colors.red : Colors.grey,
          ),
          SizedBox(height: 3),
          CircleAvatar(
            radius: 3,
            backgroundColor: currentIndex == index ? red : Colors.transparent,
          )
        ],
      ),
    );
  }
}
