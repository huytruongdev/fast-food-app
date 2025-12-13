import 'dart:convert';

import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final String baseUrl = "http://10.0.2.2:3000";

  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/orders"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(orderData),
      );

      return res.statusCode == 201;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders/user/$userId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Lỗi lấy đơn hàng: $e");
      return [];
    }
  }
}
