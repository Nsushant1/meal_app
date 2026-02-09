// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newasync/meals/meals_api.dart';
import 'package:newasync/meals/meals_service.dart';

final mealsProvider = AsyncNotifierProvider<MealsNotifier, List<Meals>>(
  MealsNotifier.new,
);

class MealsNotifier extends AsyncNotifier<List<Meals>> {
  @override
  FutureOr<List<Meals>> build() {
    return [];
  }

  Future<void> fetchReceipe(String mealId) async {
    try {
      final recepie = await MealsService().getReceipe(mealId);
      state = AsyncData(recepie.cast<Meals>());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
