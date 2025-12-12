import 'dart:convert';
import 'package:fast_food_app/Core/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductPaginationProvider extends ChangeNotifier {
  List<FoodModel> products = [];
  bool isLoading = false;
  bool hasMore = true;
  int page = 1;
  final int limit = 10;

  Future<void> loadProducts() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    final String baseUrl = "http://10.0.2.2:3000";
    final url = Uri.parse("$baseUrl/products/paginate?page=$page&limit=$limit");

    final res = await http.get(url);
    final body = jsonDecode(res.body);

    List<dynamic> list = body["data"];
    final newProducts = list.map((e) => FoodModel.fromJson(e)).toList();

    products.addAll(newProducts);

    if (page >= body["totalPages"]) {
      hasMore = false;
    } else {
      page++;
    }

    isLoading = false;
    notifyListeners();
  }
}
