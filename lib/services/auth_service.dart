import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = "http://localhost:3000";

  Future signup(String email, String password) async {
    final response = await http.post(
      Uri.parse("${baseUrl}/signup"),
      headers: {'Content-Type': "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return jsonDecode(response.body);
  }

  Future login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${baseUrl}/login"),
      headers: {'Content-Type': "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return jsonDecode(response.body);
  }
}
