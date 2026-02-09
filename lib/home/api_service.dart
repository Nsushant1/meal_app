import 'package:dio/dio.dart';
import 'package:newasync/home/api_model.dart';

class ApiService {
  Future<List<ApiModel>> getMeal() async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/categories.php',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );
      final data = response.data['categories'] as List;
      return data.map((e) => ApiModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
