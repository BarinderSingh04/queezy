import 'package:queezy/screens/models/player_score.dart';
import 'package:queezy/service/dio_instance.dart';
import 'package:queezy/screens/models/queezy_model.dart';

class QueezyService {
  QueezyService();

  Future<Queezy> getQuizData({
    String? difficulity,
    num? category,
    String? type,
    String? roomcode,
  }) async {
    try {
      final response = await DioSingleton.instance.dio.post(
        "create_game",
        data: {
          "categoryId": category,
          "difficulty": difficulity,
          "type": type,
          "roomCode": roomcode,
        },
      );
      final body = response.data;
      
      return Queezy.fromJson(body);
    } catch (e) {
      rethrow;
    }
  }


  Future<PlayerScore> getPlayerScore(int? sessionId)async{
    try {
      final response =  await DioSingleton.instance.dio.get("game_scores/$sessionId");
      final body =  response.data;
      return PlayerScore.fromMap(body['data']);
    } catch (e) {
      rethrow;
    }
  }
}
