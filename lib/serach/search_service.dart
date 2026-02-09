import 'package:dio/dio.dart';
import 'package:newasync/meals/meals_api.dart';

class SearchService {
  Future<List<Meals>> getMealName(String mealName) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/search.php',
        queryParameters: {'s': mealName},
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
    Future<Meals> getRandomMeal() async {
        final dio=Dio();
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/random.php',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );
      final data = response.data['meals'][0];
      return Meals.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

}
