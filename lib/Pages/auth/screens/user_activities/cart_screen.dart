import 'dart:convert';
import 'package:fast_food_app/Core/models/order_item_model.dart';
import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:fast_food_app/Core/providers/cart_provider.dart';
import 'package:fast_food_app/pages/auth/screens/user_activities/order_detail_screen.dart';
import 'package:fast_food_app/widgets/cart_bar.dart';
import 'package:fast_food_app/widgets/cart_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;
  bool _isPlacingOrder = false;
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
          ? const Center(child: Text("Giỏ hàng đang trống", style: TextStyle(fontSize: 16, color: Colors.grey)))
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
                  isPlacingOrder: _isPlacingOrder,
                  onOrderPress: () => _handleOrderPlacement(cart),
                ),
              ],
            ),
    );
  }

  Future<void> _handleOrderPlacement(CartProvider cart) async {
    if (_userId.isEmpty) {
      _showMsg("Vui lòng đăng nhập lại", isError: true);
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      // 1. Tạo Object OrderModel
      final order = _createOrderObject(cart);

      final body = jsonEncode(order.toJson());
      
      debugPrint("Request Body: $body");

      // 3. Gửi API
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/orders"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // _showMsg("Đặt hàng thành công!");
        final responseData = jsonDecode(response.body);

        final createdOrder = OrderModel.fromJson(responseData);

        cart.clearCart(_userId);
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: createdOrder),
            ),
          );
        }
      } else {
        _showMsg("Lỗi Server: ${response.statusCode}", isError: true);
      }
    } catch (e) {
      debugPrint("Error placing order: $e");
      _showMsg("Không thể kết nối tới server", isError: true);
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  OrderModel _createOrderObject(CartProvider cart) {
    // TODO
    final pickup = LatLng(10.800669, 106.661126); // lấy ở
    final delivery = LatLng(10.7965184,106.6557884);

    List<OrderItem> orderItems = cart.items.map((item) {
      return OrderItem(
        productId: item.productId,
        name: item.productData['name'],
        quantity: item.quantity,
        price: item.productData['price'],
      );
    }).toList();

    return OrderModel(
      userId: _userId,
      items: orderItems,
      totalQuantity: cart.totalQuantity,
      price: cart.totalPrice.toInt(),
      pickupLocation: pickup,
      deliveryLocation: delivery,
      pickupAddress: "Cửa hàng (CN Cầu vượt Cộng Hoà)",
      deliveryAddress: "Trường Cao Đẳng Lý Tự Trọng",
    );
  }

  void _showMsg(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}