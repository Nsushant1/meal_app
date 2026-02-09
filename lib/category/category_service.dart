import 'package:dio/dio.dart';
import 'package:newasync/category/category_api.dart';

class CategoryService {
  Future<List<Meal>> getMeals(String category) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/filter.php',
        queryParameters: {'c': category},
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );
      final data = response.data['meals'] as List;
      return data.map((e) => Meal.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
