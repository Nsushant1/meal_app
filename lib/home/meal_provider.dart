import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newasync/home/api_model.dart';
import 'package:newasync/home/api_service.dart';

final mealProvider = AsyncNotifierProvider<MealNotifier, List<ApiModel>>(
  MealNotifier.new,
);

class MealNotifier extends AsyncNotifier<List<ApiModel>> {
  @override
  FutureOr<List<ApiModel>> build() {
    return ApiService().getMeal();
  }
}
