class Meal {
  final String id;
  final String name;
  final String image;
  final String category;
  final String instructions;

  Meal({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.instructions,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      image: json['strMealThumb'],
      category: json['strCategory'] ?? '',
      instructions: json['strInstructions'] ?? '',
    );
  }
}
