import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newasync/category/category_provider.dart';
import 'package:newasync/meals/meals_screen.dart';

class DetailScreen extends ConsumerWidget {
  final String category;
  const DetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(categoryProvider.notifier).fetchMeals(category);

    final data = ref.watch(categoryProvider);
    return Scaffold(
      backgroundColor: Colors.blueGrey,

      body: Expanded(
        child: data.when(
          data: (meals) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MealsScreen(mealId: meals[index].idMeal),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image section
                        Expanded(
                          flex: 3,
                          child: Hero(
                            tag: 'meal_detail_${meals[index].idMeal}',
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              child: Image.network(
                                meals[index].strMealThumb,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: Text(
                                meals[index].strMeal,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Switzer',
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          error: (error, stack) => Center(child: Text(error.toString())),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
