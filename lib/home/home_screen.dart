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
        appBar: AppBar(
          title: Text(
            "Lets Make Meal",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Switzer',
            ),
          ),
          centerTitle: true,
        ),

        backgroundColor: Colors.white70,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
                decoration: InputDecoration(
                  hintText: "Search for meals...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Expanded(
              child: data.when(
                data: (meal) => GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: meal.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.black,
                          child: GestureDetector(
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
                            child: Image.network(
                              meal[index].strCategoryThumb,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          meal[index].strCategory,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Switzer',
                          ),
                        ),
                      ],
                    );
                  },
                ),
                error: (error, stack) => Center(child: Text(error.toString())),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
