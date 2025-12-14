import 'package:fast_food_app/Core/providers/cart_provider.dart';
import 'package:fast_food_app/Core/providers/favorite_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:3000";

  Future<String?> login(String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/login");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("userId", data["userID"]);

          return null;
        }

        return data["message"] ?? "Login failed";
      }

      return "Server error: ${response.statusCode}";
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String?> signup(String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/signup");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) return null;
        return data["message"] ?? "Signup failed";
      }
      return "Server error: ${response.statusCode}";
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Provider.of<CartProvider>(context, listen: false).reset();
    Provider.of<FavoriteProvider>(context, listen: false).reset();

    Phoenix.rebirth(context);

  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

}
