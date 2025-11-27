import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_food_app/Core/Provider/cart_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Your Cart")),
      body: cart.items.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      return Dismissible(
                        key: Key(item.cartId),
                        onDismissed: (_) =>
                            cart.removeItem(item.cartId, userId),
                        background: Container(color: Colors.red),
                        child: ListTile(
                          leading: Image.network(
                            item.productData['imageCard'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            item.productData['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text("${item.productData['price']} đ"),
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(8),
                                    ),
                                  ),
                                  child: Icon(Icons.remove, size: 15),
                                ),
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                    horizontal: BorderSide(),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "${item.quantity}",
                                    style: TextStyle(
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(8),
                                    ),
                                  ),
                                  child: Icon(Icons.add, size: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}