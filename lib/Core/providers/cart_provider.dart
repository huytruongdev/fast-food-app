import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fast_food_app/Core/models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final String baseUrl = "http://10.0.2.2:3000"; 

  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  // Tính tổng tiền
  double get totalPrice => _items.fold(
    0,
    (sum, item) => sum + ((item.productData['price'] ?? 0) * item.quantity),
  );

  // Tính tổng số lượng
  int get totalQuantity {
    int total = 0;
    for (var item in _items) {
      total += item.quantity;
    }
    return total;
  }

  void reset() {
    _items.clear();
    notifyListeners();
  }

  // --- 1. LOAD CART ---
  Future<void> loadCart(String userId) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/carts/$userId"));
      
      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        debugPrint(data.toString());
        _items = data.map((e) => CartItem.fromJson(e)).toList();
        notifyListeners();
      } else {
        debugPrint("❌ loadCart failed: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error loadCart: $e");
    }
  }

  Future<void> clearCart(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/carts/clear/$userId"),
      );

      if (response.statusCode == 200) {
        reset();
        debugPrint("✅ Cart cleared successfully");
      } else {
        debugPrint("❌ Failed to clear cart: ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ Error clearing cart: $e");
    }
  }

  // --- 3. ADD / UPDATE ITEM ---
  Future<void> addCart(
    String userId,
    String productId,
    Map<String, dynamic> productData,
    int change,
  ) async {
    try {
      final index = _items.indexWhere((item) => item.productId == productId);

      if (index != -1) {
        // --- TRƯỜNG HỢP 1: SẢN PHẨM ĐÃ CÓ -> UPDATE SỐ LƯỢNG ---
        final currentQty = _items[index].quantity;
        final newQuantity = currentQty + change;

        if (newQuantity <= 0) {
          // Nếu giảm về 0 -> Gọi API Xóa
          await removeItem(productId, userId); 
        } else {
          // Gọi API Update
          final res = await http.put(
            Uri.parse("$baseUrl/carts/update"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "userId": userId,
              "productId": productId,
              "quantity": newQuantity
            }),
          );

          if (res.statusCode == 200) {
            // Update UI ngay lập tức (Optimistic Update) hoặc load lại
            _items[index].quantity = newQuantity; 
            notifyListeners();
            // await loadCart(userId); // Nếu muốn chắc ăn thì load lại
          }
        }
      } else {
        // --- TRƯỜNG HỢP 2: SẢN PHẨM MỚI -> ADD ---
        if (change <= 0) return;

        final res = await http.post(
          Uri.parse("$baseUrl/carts/add"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "userId": userId,
            "productId": productId,
            "quantity": change
          }),
        );

        if (res.statusCode == 200 || res.statusCode == 201) {
          await loadCart(userId);
        }
      }
    } catch (e) {
      debugPrint("❌ Error addCart: $e");
    }
  }

  // --- 4. REMOVE ITEM (XÓA 1 MÓN) ---
  Future<void> removeItem(String productId, String userId) async {
    try {
      final res = await http.delete(
        Uri.parse("$baseUrl/carts/remove"), 
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "productId": productId
        }),
      );

      if (res.statusCode == 200) {
        _items.removeWhere((item) => item.productId == productId);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ Error remove item: $e");
    }
  }
}