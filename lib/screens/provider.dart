import 'package:flutter/material.dart';
import 'package:food_delight/models/favorite_meal.dart';

class FavoriteMealsProvider with ChangeNotifier {
  List<FavoriteMeal> _favoriteMeals = [];

  List<FavoriteMeal> get favoriteMeals => _favoriteMeals;

  void addFavoriteMeal(FavoriteMeal meal) {
    _favoriteMeals.add(meal);
    notifyListeners();
  }

  void removeFavoriteMeal(FavoriteMeal meal) {
    _favoriteMeals.remove(meal);
    notifyListeners();
  }
}
