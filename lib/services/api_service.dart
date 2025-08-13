import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000"; // Node.js API base

  static Future<bool> checkUserExists({
    required String pen,
    required String email,
    required String mobile,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/check-user"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "pen": pen,
        "email": email,
        "mobile": mobile,
      }),
    );
    return res.statusCode == 200 && jsonDecode(res.body)['exists'] == false;
  }

  static Future<bool> sendOTP({
    required bool isEmail,
    required String value,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/send-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "type": isEmail ? "email" : "mobile",
        "value": value,
      }),
    );
    return res.statusCode == 200;
  }

  static Future<bool> verifyOTP({
    required bool isEmail,
    required String value,
    required String otp,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "type": isEmail ? "email" : "mobile",
        "value": value,
        "otp": otp,
      }),
    );
    return res.statusCode == 200 && jsonDecode(res.body)['verified'] == true;
  }

  static Future<bool> registerUser({
    required String name,
    required String pen,
    required String email,
    required String mobile,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "pen": pen,
        "email": email,
        "mobile": mobile,
      }),
    );
    return res.statusCode == 200;
  }
}
