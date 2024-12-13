import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({Key? key, required this.mealId}) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Map<String, dynamic>? mealDetails;
  bool isLoading = true;
  String errorMessage = "";
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  /// Mengambil detail makanan berdasarkan ID
  void fetchMealDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final details = await ApiService.getMealDetailsById(widget.mealId);
      setState(() {
        mealDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to load meal details. Please try again.";
      });
    }
  }

  void _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (isFavorite) {
      // Tambahkan mealId ke daftar favorit
      favorites.add(widget.mealId);
    } else {
      // Hapus mealId dari daftar favorit
      favorites.remove(widget.mealId);
    }

    // Update SharedPreferences
    await prefs.setStringList('favorites', favorites);

    // Memberitahukan kepada halaman FavoritesScreen bahwa data favorit telah berubah
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mealDetails?['strMeal'] ?? "Meal Details",
          style: const TextStyle(fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 137, 210),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : mealDetails == null
                  ? const Center(
                      child: Text(
                        "No details available for this meal.",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              mealDetails!['strMealThumb'],
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mealDetails!['strMeal'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Category: ${mealDetails!['strCategory'] ?? 'Unknown'}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Area: ${mealDetails!['strArea'] ?? 'Unknown'}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Instructions:",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mealDetails!['strInstructions'] ??
                                "No instructions available.",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          // Add to favorites section
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ElevatedButton(
                              onPressed: _toggleFavorite,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isFavorite ? Colors.red : Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                isFavorite
                                    ? 'Remove from Favorites'
                                    : 'Add to Favorites',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
