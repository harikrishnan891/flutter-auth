// BEGIN KITE PATCH (ApiService)
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static Map<String, String> _json() => {'Content-Type': 'application/json'};

  // Register
  static Future<Map<String, dynamic>> register({
    required String name,
    required String pen,
    required String email,
    required String mobile,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _json(),
      body: jsonEncode({'name': name, 'pen': pen, 'email': email, 'mobile': mobile}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Register failed: ${res.body}');
  }

  // Email OTP
  static Future<void> sendEmailOtp(String email) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/send-email-otp'),
      headers: _json(),
      body: jsonEncode({'email': email}),
    );
    if (res.statusCode >= 400) throw Exception('Send email OTP failed: ${res.body}');
  }

  static Future<void> verifyEmailOtp(String email, String otp) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/verify-email-otp'),
      headers: _json(),
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    if (res.statusCode >= 400) throw Exception('Verify email OTP failed: ${res.body}');
  }

  // Mobile OTP
  static Future<void> sendMobileOtp(String mobile) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/send-mobile-otp'),
      headers: _json(),
      body: jsonEncode({'mobile': mobile}),
    );
    if (res.statusCode >= 400) throw Exception('Send mobile OTP failed: ${res.body}');
  }

  static Future<void> verifyMobileOtp(String mobile, String otp) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/verify-mobile-otp'),
      headers: _json(),
      body: jsonEncode({'mobile': mobile, 'otp': otp}),
    );
    if (res.statusCode >= 400) throw Exception('Verify mobile OTP failed: ${res.body}');
  }

  // Applications
  static Future<List<dynamic>> listApps() async {
    final res = await http.get(Uri.parse('$baseUrl/apps/list'), headers: _json());
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('List apps failed: ${res.body}');
  }

  static Future<void> linkApp(int userId, int appId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/apps/link'),
      headers: _json(),
      body: jsonEncode({'user_id': userId, 'app_id': appId}),
    );
    if (res.statusCode >= 400) throw Exception('Link app failed: ${res.body}');
  }

  static Future<Map<String, dynamic>> getTotp(int userId, int appId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/apps/totp?user_id=$userId&app_id=$appId'),
      headers: _json(),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Get TOTP failed: ${res.body}');
  }
}
// END KITE PATCH
