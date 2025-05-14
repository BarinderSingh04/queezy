import 'package:dio/dio.dart';
import 'package:queezy/screens/models/avatar_model.dart';
import 'package:queezy/screens/models/player_score.dart';
import 'package:queezy/screens/models/room_model.dart';
import 'package:queezy/service/dio_exceptions.dart';
import 'package:queezy/service/dio_instance.dart';
import 'package:queezy/screens/models/queezy_model.dart';

class QueezyService {
  QueezyService();

  Future<GameSession> createGame({
    String? difficulity,
    num? category,
    String? type,
    String? roomcode,
    bool singlePlayer = false,
  }) async {
    try {
      final response = await DioSingleton.instance.dio.post(
        "create_game",
        data: {"roomCode": roomcode, "singlePlayer": singlePlayer},
      );
      final body = response.data;
      return GameSession.fromJson(body);
    } on DioException catch (e) {
      print("signup error: $e");
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PlayerScore>> getPlayerScore(int? sessionId) async {
    try {
      final response = await DioSingleton.instance.dio.get("game_scores/$sessionId");
      final body = response.data;
      final jsonResponse = body["data"] as List<dynamic>;
      return jsonResponse.map((e) => PlayerScore.fromJson(e)).toList();
    } on DioException catch (e) {
      print("signup error: $e");
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<RoomModel> createRoom({String? type, String? difficulty, num? category}) async {
    try {
      final response = await DioSingleton.instance.dio.post(
        "create_room",
        data: {"type": type, "difficulty": difficulty, "categoryId": category},
      );
      final body = response.data;
      return RoomModel.fromJson(body['data']);
    } on DioException catch (e) {
      print("signup error: $e");
      throw DioExceptions.fromDioError(e);
    } on Exception {
      rethrow;
    }
  }

  Future<List<AvatarModel>> getAvatarList() async {
    try {
      final response = await DioSingleton.instance.dio.get("avatars");
      final data = response.data?["data"];
      if (data == null) throw "No data found";
      final jsonResponse = data as List<dynamic>;
      return jsonResponse.map((e) => AvatarModel.fromJson(e)).toList();
    } on DioException catch (e) {
      print("signup error: $e");
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<JoinRoomModel> joinRoom({required String roomCode}) async {
    try {
      final response = await DioSingleton.instance.dio.post(
        "join_room",
        data: {"roomCode": roomCode},
      );
      final body = response.data;
      return JoinRoomModel.fromJson(body['data']);
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    } on Exception {
      rethrow;
    }
  }

  Future<JoinRoomModel?> getActiveRoom() async {
    try {
      final response = await DioSingleton.instance.dio.get("active_room");
      final body = response.data;
      return JoinRoomModel.fromJson(body['data']);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) return null;
      throw DioExceptions.fromDioError(e);
    } on Exception {
      rethrow;
    }
  }

  Future<List<LeaderBoardModel>> getLeaderBoard() async {
    try {
      final response = await DioSingleton.instance.dio.get("leaderboard");
      final data = response.data?["data"];
      if (data == null) throw "No data found";
      final jsonResponse = data as List<dynamic>;
      return jsonResponse.map((e) => LeaderBoardModel.fromJson(e)).toList();
    } on DioException catch (e) {
      print("signup error: $e");
      throw DioExceptions.fromDioError(e);
    } on Exception {
      rethrow;
    }
  }

  Future<GameDetail> gameDetails(int? sessionId, int? playerId) async {
    try {
      final response = await DioSingleton.instance.dio.get(
        "game_details/$sessionId/player/$playerId",
      );
      final data = response.data?["data"];
      if (data == null) throw "No data found";
      return GameDetail.fromJson(data);
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    } on Exception {
      rethrow;
    }
  }
}
