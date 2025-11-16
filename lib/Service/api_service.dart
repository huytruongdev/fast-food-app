import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000";

  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse("$baseUrl/login");

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return {"success": false, "message": "Server error: ${res.statusCode}"};
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }
}
