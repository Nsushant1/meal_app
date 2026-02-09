// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newasync/category/category_api.dart';
import 'package:newasync/category/category_service.dart';

final categoryProvider = AsyncNotifierProvider<CategoryNotifier, List<Meal>>(
  CategoryNotifier.new,
);

class CategoryNotifier extends AsyncNotifier<List<Meal>> {
  @override
  FutureOr<List<Meal>> build() {
    return [];
  }

  Future<void> fetchMeals(String category) async {
    try {
      final meals = await CategoryService().getMeals(category);
      state = AsyncData(meals);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
