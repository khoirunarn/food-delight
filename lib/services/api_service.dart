import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://www.themealdb.com/api/json/v1/1";

  // Fungsi untuk mencari makanan berdasarkan nama
  static Future<List<dynamic>> searchMealByName(String name) async {
    final response = await http.get(Uri.parse("$_baseUrl/search.php?s=$name"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to search meals by name');
    }
  }

  // Fungsi untuk mendapatkan daftar kategori
  static Future<List<dynamic>> getCategoryList() async {
    final response = await http.get(Uri.parse("$_baseUrl/list.php?c=list"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to fetch category list');
    }
  }

  // Fungsi untuk mendapatkan daftar area
  static Future<List<dynamic>> getAreaList() async {
    final response = await http.get(Uri.parse("$_baseUrl/list.php?a=list"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to fetch area list');
    }
  }

  // Fungsi untuk mendapatkan daftar bahan
  static Future<List<dynamic>> getIngredientList() async {
    final response = await http.get(Uri.parse("$_baseUrl/list.php?i=list"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to fetch ingredient list');
    }
  }

  // Fungsi untuk mencari makanan berdasarkan kategori
  static Future<List<dynamic>> filterMealsByCategory(String category) async {
    final response =
        await http.get(Uri.parse("$_baseUrl/filter.php?c=$category"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to fetch meals by category');
    }
  }

  // Fungsi untuk mencari makanan berdasarkan bahan
  static Future<List<dynamic>> filterMealsByIngredient(
      String ingredient) async {
    final response =
        await http.get(Uri.parse("$_baseUrl/filter.php?i=$ingredient"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to fetch meals by ingredient');
    }
  }

  // Fungsi untuk mendapatkan makanan acak
  static Future<dynamic> getRandomMeal() async {
    final response = await http.get(Uri.parse("$_baseUrl/random.php"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals']?.first;
    } else {
      throw Exception('Failed to fetch random meal');
    }
  }

  // Fungsi untuk mendapatkan detail makanan berdasarkan ID
  static Future<Map<String, dynamic>> getMealDetailsById(String mealId) async {
    final response =
        await http.get(Uri.parse("$_baseUrl/lookup.php?i=$mealId"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'][0];
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  static Future<List<dynamic>> getCategories() async {
    final response = await http.get(Uri.parse("$_baseUrl/categories.php"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['categories'] ?? [];
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

// Fungsi untuk menyaring kategori berdasarkan huruf
  static Future<List<dynamic>> filterCategoriesByLetter(String letter) async {
    final response =
        await http.get(Uri.parse("$_baseUrl/search.php?f=$letter"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to fetch categories by letter');
    }
  }

  static Future<List<dynamic>> searchMeal(String query) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to load meals');
    }
  }
}
