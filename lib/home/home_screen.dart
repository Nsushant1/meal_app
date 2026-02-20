import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newasync/category/detail_screen.dart';
import 'package:newasync/home/meal_provider.dart';
import 'package:newasync/serach/search_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(mealProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Let's Make\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontFamily: 'Switzer',
                      ),
                    ),
                    TextSpan(
                      text: "Delicious Meals",
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Switzer',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
                decoration: InputDecoration(
                  hintText: "What are you craving today?",
                  hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                  prefixIcon: Icon(Icons.search, color: Colors.blue, size: 24),
                  fillColor: Colors.white,
                  filled: true,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              SizedBox(height: 24),

              Expanded(
                child: data.when(
                  data: (meal) => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: meal.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DetailScreen(
                                  category: meal[index].strCategory,
                                );
                              },
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
                              Expanded(
                                flex: 3,
                                child: Hero(
                                  tag: 'meal_${meal[index].strCategory}',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      meal[index].strCategoryThumb,
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
                                      meal[index].strCategory,
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
                  error: (error, stack) =>
                      Center(child: Text(error.toString())),
                  loading: () => Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
