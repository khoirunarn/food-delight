import 'package:shared_preferences/shared_preferences.dart';

class RegisterModel {
  static Future<void> saveUserData({
    required String name,
    required String email,
    required String password,
    required String city,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('city', city);
  }

  // Fungsi untuk mengambil data pengguna dari SharedPreferences
  static Future<Map<String, String?>> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
      'password': prefs.getString('password'),
      'city': prefs.getString('city'),
    };
  }

  // Fungsi untuk menghapus data pengguna dari SharedPreferences
  static Future<void> deleteUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('city');
  }
}
