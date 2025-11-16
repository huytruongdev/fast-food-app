import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fast_food_app/Core/models/categories_model.dart';

Future<List<Category>> fetchCategories() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:3000/categories'));
  if (response.statusCode == 200) {
    List jsonData = json.decode(response.body);
    return jsonData.map((c) => Category.fromJson(c)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}
