import 'package:flutter/material.dart';
// import 'package:fast_food_app/Pages/auth/Screen/food_app_home_screen.dart';
import 'package:fast_food_app/Pages/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const LoginScreen(),
      // home: const FoodAppHomeScreen(),
    );
  }
}


