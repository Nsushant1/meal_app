import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newasync/meals/meals_provder.dart';

class MealsScreen extends ConsumerWidget {
  final String mealId;
  const MealsScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(mealsProvider.notifier).fetchReceipe(mealId);

    final data = ref.watch(mealsProvider);
    final meal = data.maybeWhen(
      data: (recipe) => recipe.isNotEmpty ? recipe[0] : null,
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          meal?.strMeal ?? 'Meal Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Switzer'),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
      ),
      body: data.when(
        data: (recipe) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  meal!.strMealThumb,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Chip(
                            label: Text(meal.strCategory),
                            backgroundColor: Colors.blue.shade50,
                            labelStyle: TextStyle(color: Colors.blue.shade700),
                          ),
                          SizedBox(width: 8),
                          Chip(
                            label: Text(meal.strArea),
                            backgroundColor: Colors.green.shade50,
                            labelStyle: TextStyle(color: Colors.green.shade700),
                          ),
                        ],
                      ),

                      SizedBox(height: 24),

                      Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Switzer',
                        ),
                      ),
                      SizedBox(height: 12),

                      ...meal.ingredients.map((ingredient) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_right),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${ingredient.measure} ${ingredient.name}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Switzer",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      SizedBox(height: 24),
                      Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Switzer',
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        meal.strInstructions,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontFamily: "Switzer",
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},

                          child: Text(
                            'Watch Video',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: ${error.toString()}',
            style: TextStyle(color: Colors.red),
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
