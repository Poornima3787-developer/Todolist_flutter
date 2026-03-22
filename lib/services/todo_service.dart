import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TodoService {
  final String baseUrl = "http://10.13.103.240:3000";
  final storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<List<dynamic>> getTodos() async {
    try {
      String? token = await getToken();
      final response = await http.get(
        Uri.parse("${baseUrl}/todos"),
        headers: {
          "Content-Type": 'application/json',
          "Authorization": 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addTodo(String title) async {
    try {
      String? token = await getToken();
      await http.post(
        Uri.parse("$baseUrl/todos"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"title": title, "completed": 0, "total": 1}),
      );
    } catch (e) {
      print("Add Error");
    }
  }

  Future<void> updateTodo(String id, String title) async {
    try {
      String? token = await getToken();
      await http.put(
        Uri.parse("$baseUrl/todos/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"title": title}),
      );
    } catch (e) {
      print("Update error");
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      String? token = await getToken();
      await http.delete(
        Uri.parse("$baseUrl/todos/$id"),
        headers: {"Authorization": "Bearer $token"},
      );
    } catch (e) {
      print("Delete Error");
    }
  }
}
