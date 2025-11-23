import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../models/category.dart';

class MealsService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1/search.php';
  final String categoriesUrl = 'https://www.themealdb.com/api/json/v1/1/categories.php';

  Future<List<Meal>> searchMeals(String query) async {
    try {
      final url = '$baseUrl?s=$query';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // If meals is null, return empty list
        if (data['meals'] == null) {
          return [];
        }

        // Parse the meals list
        final List<dynamic> mealsJson = data['meals'];
        return mealsJson.map((json) => Meal.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      throw Exception('Error searching meals: $e');
    }
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(categoriesUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // If categories is null, return empty list
        if (data['categories'] == null) {
          return [];
        }

        // Parse the categories list
        final List<dynamic> categoriesJson = data['categories'];
        return categoriesJson.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}

