import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // TODO: set to your actual backend URL
  static const String baseUrl = "http://localhost:3000";

  // ---------- User existence & register ----------
  static Future<bool> checkUserExists({
    required String pen,
    required String email,
    required String mobile,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/check-user"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"pen": pen, "email": email, "mobile": mobile}),
    );
    if (res.statusCode != 200) return false;
    final data = jsonDecode(res.body);
    // expecting { "exists": false }
    return data is Map && data["exists"] == false;
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
      body: jsonEncode({"name": name, "pen": pen, "email": email, "mobile": mobile}),
    );
    return res.statusCode == 200;
  }

  // ---------- Email OTP ----------
  static Future<bool> sendEmailOtp(String email) async {
    final res = await http.post(
      Uri.parse("$baseUrl/send-email-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
    return res.statusCode >= 200 && res.statusCode < 300;
  }

  static Future<bool> verifyEmailOtp(String email, String otp) async {
    final res = await http.post(
      Uri.parse("$baseUrl/verify-email-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );
    if (res.statusCode != 200) return false;
    final data = jsonDecode(res.body);
    return data is Map && (data["verified"] == true || data["status"] == "ok");
  }

  // ---------- Mobile OTP ----------
  static Future<bool> sendMobileOtp(String mobile) async {
    final res = await http.post(
      Uri.parse("$baseUrl/send-mobile-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"mobile": mobile}),
    );
    return res.statusCode >= 200 && res.statusCode < 300;
  }

  static Future<bool> verifyMobileOtp(String mobile, String otp) async {
    final res = await http.post(
      Uri.parse("$baseUrl/verify-mobile-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"mobile": mobile, "otp": otp}),
    );
    if (res.statusCode != 200) return false;
    final data = jsonDecode(res.body);
    return data is Map && (data["verified"] == true || data["status"] == "ok");
  }
}
