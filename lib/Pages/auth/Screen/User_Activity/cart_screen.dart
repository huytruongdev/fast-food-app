import 'dart:convert';
import 'package:fast_food_app/Core/Utils/consts.dart';
import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fast_food_app/Core/Provider/cart_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String userId = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndCart();
  }

  Future<void> _loadUserIdAndCart() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString("userId") ?? "";

    setState(() {
      userId = savedUserId;
    });

    if (userId.isNotEmpty) {
      await Provider.of<CartProvider>(context, listen: false).loadCart(userId);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Your Cart")),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // var discountPrice = cart.totalPrice * 0.1;
    // var grandTotal = (cart.totalPrice - discountPrice + 2.99).toStringAsFixed(
    //   2,
    // );
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: cart.items.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      return Dismissible(
                        key: Key(item.cartId),
                        onDismissed: (_) =>
                            cart.removeItem(item.cartId, userId),
                        background: Container(color: Colors.red),

                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),

                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),

                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.productData['imageCard'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),

                            title: Text(
                              item.productData['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            subtitle: Text(
                              "${item.productData['price']} đ",
                              style: const TextStyle(fontSize: 14),
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    int newQuantity = item.quantity - 1;
                                    if (newQuantity > 0) {
                                      cart.addCart(
                                        userId,
                                        item.productId,
                                        item.productData,
                                        -1,
                                      );
                                    } else {
                                      cart.removeItem(item.cartId, userId);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: const BoxDecoration(
                                      border: Border.fromBorderSide(
                                        BorderSide(),
                                      ),
                                      borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(8),
                                      ),
                                    ),
                                    child: const Icon(Icons.remove, size: 15),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      "${item.quantity}",
                                      style: const TextStyle(
                                        fontSize: 14.5,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cart.addCart(
                                      userId,
                                      item.productId,
                                      item.productData,
                                      1,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: const BoxDecoration(
                                      border: Border.fromBorderSide(
                                        BorderSide(),
                                      ),
                                      borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(8),
                                      ),
                                    ),
                                    child: const Icon(Icons.add, size: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ${cart.totalPrice.toStringAsFixed(0)} đ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: red,
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          backgroundColor: red,
                        ),
                        onPressed: ()  {
                          _handleOrderPlacement(cart);
                        },
                        child: Row(
                          children: [
                            Text(
                              "Order",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                "(${cart.totalQuantity})",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
    );
  }
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Hàm xử lý việc đặt hàng
  Future<void> _handleOrderPlacement(CartProvider cart) async {
    if (cart.items.isEmpty) {
      _showSnackBar("Giỏ hàng trống! Vui lòng thêm sản phẩm.", isError: true);
      return;
    }
    String itemDescription = cart.items
        .map((item) => "${item.quantity} x ${item.productData['name']}")
        .join(", ");

    final pickupLatLng = LatLng(
      10.762622,
      106.660172,
    );
    final deliveryLatLng = LatLng(
      10.794165,
      106.688849,
    ); 
    const pickupAddress = "Cửa hàng mặc định - Địa chỉ lấy hàng";
    const deliveryAddress = "Địa chỉ giao hàng của người dùng (cần nhập)";

    final prefs = await SharedPreferences.getInstance();
    final currentUserId = prefs.getString("userId");

    if (currentUserId == null || currentUserId.isEmpty) {
      _showSnackBar(
        "Không tìm thấy ID người dùng. Vui lòng đăng nhập lại.",
        isError: true,
      );
      return;
    }
    
    int totalQuantity = cart.totalQuantity;
    int totalPrice = cart.totalPrice.toInt(); 

    final order = OrderModel(
      userId: currentUserId,
      item: itemDescription,
      quantity: totalQuantity,
      price: totalPrice,
      pickupLocation: pickupLatLng,
      deliveryLocation: deliveryLatLng,
      pickupAddress: pickupAddress,
      deliveryAddress: deliveryAddress,
    );

    try {
      final body = jsonEncode(order.toJson());

      debugPrint(body);
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/orders"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      debugPrint(response.toString());

    } catch (e) {
      _showSnackBar(
        "Lỗi kết nối: Không thể kết nối đến server.",
        isError: true,
      );
      print("Lỗi đặt hàng: $e");
    }
  }
}
