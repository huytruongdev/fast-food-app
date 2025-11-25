import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fast_food_app/Core/models/product_model.dart';

class ProductService {
  static const String serverUrl = "http://10.0.2.2:3000";

  static Future<List<FoodModel>> getAllProducts() async {
    final url = Uri.parse("$serverUrl/products");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((json) => FoodModel.fromJson(json)).toList();
    } else {
      throw Exception("Lỗi tải tất cả sản phẩm: ${res.statusCode}");
    }
  }

  static Future<List<FoodModel>> getProductsByCategory(
    String categoryId,
  ) async {

    final url = Uri.parse("$serverUrl/products/categories/$categoryId");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((json) => FoodModel.fromJson(json)).toList();
    } else {
      throw Exception(
        "Lỗi tải sản phẩm theo danh mục ($categoryId): ${res.statusCode}",
      );
    }
  }
}
