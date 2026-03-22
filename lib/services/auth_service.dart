import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = "http://10.13.103.240:3000";

  Future<Map<String, dynamic>> signup(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}/signup"),
        headers: {'Content-Type': "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      ) .timeout(Duration(seconds: 5));
       print("Status Code: ${response.statusCode}");
    print("Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Signup failed"};
      }
    } catch (e) {
     print("❌ ERROR: $e"); // 👈 ADD THIS
  return {"error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}/login"),
        headers: {'Content-Type': "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Invalid credentials"};
      }
    } catch (e) {
      return {"error": "Server error"};
    }
  }
}
