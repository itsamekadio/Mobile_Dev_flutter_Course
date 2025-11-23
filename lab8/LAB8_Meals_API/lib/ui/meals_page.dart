import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meals_provider.dart';

class MealsPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  MealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MealsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals Search'),
        backgroundColor: Colors.orange,
        actions: [
          if (!provider.showingCategories)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _controller.clear();
                provider.loadCategories();
              },
              tooltip: 'Back to Categories',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search for meals...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      provider.searchMeals(_controller.text);
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  provider.searchMeals(value);
                }
              },
            ),
            const SizedBox(height: 20),

            // Loading indicator
            if (provider.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            // Error message
            if (provider.errorMessage != null && !provider.isLoading)
              Expanded(
                child: Center(
                  child: Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            // No results message (only for search, not categories)
            if (!provider.isLoading &&
                provider.errorMessage == null &&
                !provider.showingCategories &&
                provider.meals.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ),

            // Categories list
            if (!provider.isLoading &&
                provider.errorMessage == null &&
                provider.showingCategories &&
                provider.categories.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meal Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: provider.categories.length,
                        itemBuilder: (context, index) {
                          final category = provider.categories[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  category.strCategoryThumb,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.restaurant),
                                    );
                                  },
                                ),
                              ),
                              title: Text(
                                category.strCategory,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                category.strCategoryDescription,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

            // Meals list (search results)
            if (!provider.isLoading &&
                provider.errorMessage == null &&
                !provider.showingCategories &&
                provider.meals.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Search Results',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: provider.meals.length,
                        itemBuilder: (context, index) {
                          final meal = provider.meals[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  meal.strMealThumb,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.restaurant),
                                    );
                                  },
                                ),
                              ),
                              title: Text(
                                meal.strMeal,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
