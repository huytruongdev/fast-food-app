import 'package:fast_food_app/Core/Provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_food_app/Core/Provider/favorite_provider.dart';
import 'package:fast_food_app/Pages/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
