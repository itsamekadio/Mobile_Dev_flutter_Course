import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../models/category.dart';
import '../services/meals_service.dart';

class MealsProvider with ChangeNotifier {
  final MealsService _service = MealsService();

  bool isLoading = false;
  List<Meal> meals = [];
  List<Category> categories = [];
  String? errorMessage;
  bool showingCategories = true;

  MealsProvider() {
    // Load categories when provider is created
    loadCategories();
  }

  Future<void> loadCategories() async {
    errorMessage = null;
    isLoading = true;
    showingCategories = true;
    notifyListeners();

    try {
      categories = await _service.fetchCategories();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      categories = [];
      notifyListeners();
    }
  }

  Future<void> searchMeals(String query) async {
    // Reset error message
    errorMessage = null;
    showingCategories = false;
    
    // Set loading state
    isLoading = true;
    notifyListeners();

    try {
      meals = await _service.searchMeals(query);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      meals = [];
      notifyListeners();
    }
  }
}
