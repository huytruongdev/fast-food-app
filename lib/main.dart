import 'package:fast_food_app/Core/providers/cart_provider.dart';
import 'package:fast_food_app/Core/providers/order_provider.dart';
import 'package:fast_food_app/Core/providers/products_pagination_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_food_app/Core/providers/favorite_provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fast_food_app/pages/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    Phoenix(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductPaginationProvider()),
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, 
      ),
      home: const LoginScreen(),
    );
  }
}
