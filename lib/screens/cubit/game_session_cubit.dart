import 'package:bloc/bloc.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/service/queezy_service.dart';
import 'package:queezy/screens/models/queezy_model.dart';
import 'package:queezy/service/local_storage_service.dart';
import 'package:queezy/service/socket_service.dart';

class GameSessionCubit extends Cubit<Result<GameSession>> {
  final QueezyService _queezyService;
  final SocketService _socketService;
  final LocalStorageService _localStorageService;

  GameSessionCubit(this._queezyService, this._socketService, this._localStorageService)
    : super(Result(isLoading: false)) {
    _socketService.on("game-started", (data) {
      final gameSession = GameSession.fromJson(data);
      emit(Result(data: gameSession));
    });
    _socketService.on("game_ended", (data) {
      print(data);
    });
  }

  Future<void> create({String? roomcode, bool singlePlayer = false}) async {
    try {
      emit(Result(isLoading: true));
      final response = await _queezyService.createGame(
        roomcode: roomcode,
        singlePlayer: singlePlayer,
      );
      emit(Result(data: response));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }

  void submitAnswer({
    required String? givenAnswer,
    required String correctAnswer,
    required String question,
  }) {
    if (state.data != null) {
      final gameSession = state.data!;
      final userId = _localStorageService.getUser()?.id;
      final sessionId = gameSession.sessionId;
      final playerId =
          gameSession.players?.firstWhere((player) => player.userId == userId).playerId;

      _socketService.emit("submit_answer", {
        "sessionId": sessionId,
        "playerId": playerId,
        "question": question,
        "answer": givenAnswer,
        "correctAnswer": correctAnswer,
      });
    }
  }

  @override
  Future<void> close() {
    _socketService.off("game-started");
    _socketService.off("game-ended");
    return super.close();
  }
}
