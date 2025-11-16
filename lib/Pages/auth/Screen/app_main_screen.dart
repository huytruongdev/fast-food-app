import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fast_food_app/Pages/auth/Screen/food_app_home_screen.dart';
import 'package:fast_food_app/Pages/auth/Screen/profile_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fast_food_app/Core/Utils/consts.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int currentInex = 0;
  final List<Widget> _pages = [
    FoodAppHomeScreen(),
    Scaffold(),
    ProfileScreen(),
    Scaffold(),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentInex],
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
                  child: CircleAvatar(
                    backgroundColor: red,
                    radius: 10,
                    child: Text(
                      "0",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
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

  Widget _buildNavItems(IconData icon, String lable, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentInex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: currentInex == index ? Colors.red : Colors.grey,
          ),
          SizedBox(height: 3),
          CircleAvatar(
            radius: 3,
            backgroundColor: currentInex == index? red : Colors.transparent,
          )
        ],
      ),
    );
  }
}
