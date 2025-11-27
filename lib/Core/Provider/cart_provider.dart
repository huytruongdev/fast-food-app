import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fast_food_app/Core/models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final String baseUrl = "http://10.0.2.2:3000";

  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(
    0,
    (sum, item) => sum + ((item.productData['price'] ?? 0) * item.quantity),
  );

  void reset() {
    _items.clear();
    notifyListeners();
  }

  Future<void> loadCart(String userId) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/carts/$userId"));

      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);

        _items = data.map((e) => CartItem.fromJson(e)).toList();
        notifyListeners();
      } else {
        debugPrint("❌ loadCart failed: ${res.reasonPhrase}");
      }
    } catch (e) {
      debugPrint("❌ Error loadCart: $e");
    }
  }

  Future<void> addCart(
    String userId,
    String productId,
    Map<String, dynamic> productData,
    int change,
  ) async {
    try {
      // Tìm item trong cart
      final index = _items.indexWhere((item) => item.productId == productId);

      if (index != -1) {
        final newQuantity = _items[index].quantity + change;

        if (newQuantity <= 0) {
          await removeItem(_items[index].cartId, userId);
        } else {
          final res = await http.put(
            Uri.parse("$baseUrl/carts/update/${_items[index].cartId}"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"quantity": newQuantity}),
          );

          if (res.statusCode == 200) {
            await loadCart(userId);
          }
        }
      } else {
        final body = jsonEncode({
          "userId": userId,
          "productId": productId,
          "productData": productData,
          "quantity": change > 0 ? change : 1,
        });

        final res = await http.post(
          Uri.parse("$baseUrl/carts/add"),
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        if (res.statusCode == 200) {
          await loadCart(userId);
        }
      }
    } catch (e) {
      debugPrint("Error addCart: $e");
    }
  }

  Future<void> updateQuantity(String id, int quantity, String userId) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/carts/update/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"quantity": quantity}),
      );

      if (res.statusCode == 200) {
        await loadCart(userId);
      }
    } catch (e) {
      debugPrint("Error updateQuantity: $e");
    }
  }

  Future<void> removeItem(String id, String userId) async {
    try {
      await http.delete(Uri.parse("$baseUrl/carts/delete/$id"));
      _items.removeWhere((item) => item.cartId == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error remove item: $e");
    }
  }
}
