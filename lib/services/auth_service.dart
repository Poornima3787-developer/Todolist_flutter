import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future signup(String email, String password) async {
    final response = await http.post(
      Uri.parse("http://localhost:3000/login"),
      headers: {'Content-Type': "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return jsonDecode(response.body);
  }
}
