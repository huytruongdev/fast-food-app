import 'dart:convert';

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
}
