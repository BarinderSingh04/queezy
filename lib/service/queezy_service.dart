import 'package:queezy/service/dio_instance.dart';
import 'package:queezy/splash_and_onBoarding/models/queezy_model.dart';

class QueezyService {

  QueezyService();

  Future<List<QueezyModel>> getQuizData({String? difficulity, String? category}) async{
    try {
      final response = await DioSingleton.instance.dio.get("amount=10&category=$category&difficulty=$difficulity&type=multiple");
      final body = response.data;
      final List<dynamic> jsonResponse = body["results"];
      return jsonResponse.map((e) => QueezyModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}