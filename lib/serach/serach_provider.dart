// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newasync/meals/meals_api.dart';
import 'package:newasync/serach/search_service.dart';

final searchProvider = AsyncNotifierProvider<SearchNotifier, List<Meals>>(
  SearchNotifier.new,
);

class SearchNotifier extends AsyncNotifier<List<Meals>> {
  @override
  FutureOr<List<Meals>> build() {
    return [];
  }

  Future<void> searchMeals(String mealName) async {
    try {
      final mealdata = await SearchService().getMealName(mealName);
      state = AsyncData(mealdata.cast<Meals>());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

}
