import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteItems = [];
  List<String> get favoriteItems => _favoriteItems;

  final String baseUrl = "http://10.0.2.2:3000";

  String? userId;

  FavoriteProvider() {
    _loadUserID();
  }

  Future<void> _loadUserID() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");

    if (userId != null) {
      await loadFavorites();
    }
  }

  // Reset khi logout
  void reset() {
    _favoriteItems = [];
    notifyListeners();
  }

  bool isExist(String productId) {
    return _favoriteItems.contains(productId);
  }

  Future<void> toggleFavorite(String productId) async {
    if (userId == null) return;

    if (_favoriteItems.contains(productId)) {
      _favoriteItems.remove(productId);
      await _removeFavorite(productId);
    } else {
      _favoriteItems.add(productId);
      await _addFavorite(productId);
    }

    notifyListeners();
  }

  Future<void> _addFavorite(String productId) async {
    try {
      final url = Uri.parse("$baseUrl/favorites");
      await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId, "productId": productId}),
      );
    } catch (e) {
      debugPrint("Error adding favorite: $e");
    }
  }

  Future<void> _removeFavorite(String productId) async {
    try {
      final url = Uri.parse("$baseUrl/favorites/$userId/$productId");

      await http.delete(url);
    } catch (e) {
      debugPrint("Error removing favorite: $e");
    }
  }

  Future<void> loadFavorites() async {
    if (userId == null) return;

    try {
      final url = Uri.parse("$baseUrl/favorites/$userId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _favoriteItems = data.cast<String>();
      }
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    }

    notifyListeners();
  }
}
