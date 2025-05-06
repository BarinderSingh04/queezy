import 'package:bloc/bloc.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/models/player_score.dart';
import 'package:queezy/screens/service/queezy_service.dart';
import 'package:queezy/service/socket_service.dart';

class PlayerScoresCubit extends Cubit<Result<List<PlayerScore>>> {
  final QueezyService _queezyService;
  final SocketService _socketService;
  PlayerScoresCubit(this._queezyService, this._socketService) : super(Result(isLoading: true)) {
    _socketService.on("score-updated", (data) {
      final jsonResponse = data as List<dynamic>;
      emit(Result(data: jsonResponse.map((e) => PlayerScore.fromJson(e)).toList()));
    });
  }

  Future<void> getScore(int? session_id) async {
    try {
      emit(Result(isLoading: true));
      final response = await _queezyService.getPlayerScore(session_id);
      emit(Result(data: response));
    } catch (e) {
      emit(Result.error(e));
    }
  }
}
