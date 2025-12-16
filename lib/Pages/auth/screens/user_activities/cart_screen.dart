import 'package:fast_food_app/Core/providers/cart_provider.dart';
import 'package:fast_food_app/pages/auth/screens/user_activities/checkout_screen.dart'; // Đảm bảo import đúng đường dẫn file Checkout
import 'package:fast_food_app/widgets/cart_bar.dart';
import 'package:fast_food_app/widgets/cart_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString("userId") ?? "";

    if (_userId.isNotEmpty && mounted) {
      await Provider.of<CartProvider>(context, listen: false).loadCart(_userId);
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Your Cart")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Your Cart", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text("Giỏ hàng đang trống", style: TextStyle(fontSize: 16, color: Colors.grey)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) => CartItemTile(
                      item: cart.items[index],
                      userId: _userId,
                      cartProvider: cart,
                    ),
                  ),
                ),
                
                CartBar(
                  totalPrice: cart.totalPrice,
                  totalQuantity: cart.totalQuantity,
                  isPlacingOrder: false,
                  onOrderPress: () {
                    if (_userId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Vui lòng đăng nhập lại")),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(userId: _userId),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}