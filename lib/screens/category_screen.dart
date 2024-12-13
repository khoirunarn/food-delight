import 'package:flutter/material.dart';
import 'package:food_delight/screens/favorites_screen.dart';
import '../services/api_service.dart';
import '../screens/detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<dynamic>? meals;
  List<Map<String, String>> favoriteMeals = []; // Menyimpan data favorit
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchMealsByCategory();
  }

  void fetchMealsByCategory() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final mealList = await ApiService.filterMealsByCategory(widget.category);
      setState(() {
        meals = mealList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to load meals by category. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meals in ${widget.category} Category",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // Navigasi ke halaman Favorite
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(favoriteMeals: favoriteMeals),
                ),
              );
            },
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
              : meals == null || meals!.isEmpty
                  ? const Center(
                      child: Text(
                        "No meals found in this category.",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      itemCount: meals!.length,
                      itemBuilder: (context, index) {
                        final meal = meals![index];
                        final isFavorite = favoriteMeals.any((fav) => fav['id'] == meal['idMeal']);

                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 3,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                meal['strMealThumb'] ?? 'https://via.placeholder.com/150',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              meal['strMeal'] ?? "Unknown",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              "Meal ID: ${meal['idMeal']}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.pink : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (isFavorite) {
                                    favoriteMeals.removeWhere((fav) => fav['id'] == meal['idMeal']);
                                  } else {
                                    favoriteMeals.add({
                                      'id': meal['idMeal'],
                                      'name': meal['strMeal'],
                                      'image': meal['strMealThumb'],
                                    });
                                  }
                                });
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MealDetailScreen(mealId: meal['idMeal']),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
