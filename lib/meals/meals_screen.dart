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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: data.when(
          data: (recepie) {
            final meal = recepie[0];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Image.network(
                        meal.strMealThumb,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(
                              label: Text(meal.strCategory),
                              backgroundColor: Colors.orangeAccent,
                              labelStyle: TextStyle(
                                fontFamily: 'Switzer',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Chip(
                              backgroundColor: Colors.white,
                              label: Text(meal.strArea),
                              labelStyle: TextStyle(
                                fontFamily: 'Switzer',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 12),

                        ...meal.ingredients.map((ingredient) {
                          return Row(
                            children: [
                              Icon(
                                Icons.arrow_right,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${ingredient.measure} ${ingredient.name}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Switzer",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),

                        SizedBox(height: 24),
                        Text(
                          'Instructions',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: "Switzer",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          meal.strInstructions,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: "Switzer",
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_arrow, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Watch Video',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Switzer',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stack) => Center(
            child: Text(
              'Error: ${error.toString()}',
              style: TextStyle(color: Colors.red),
            ),
          ),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
