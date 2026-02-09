import 'package:dio/dio.dart';
import 'package:newasync/meals/meals_api.dart';

class MealsService {
  Future<List<Meals>> getReceipe(String mealId) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/lookup.php',
        queryParameters: {'i': mealId},
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );
      final data = response.data['meals'] as List;
      return data.map((e) => Meals.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
