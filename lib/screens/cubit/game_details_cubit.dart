import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/models/room_model.dart';
import 'package:queezy/screens/service/queezy_service.dart';

class GameDetailsCubit extends Cubit<Result<GameDetail>> {
  final QueezyService _queezyService;
  GameDetailsCubit(this._queezyService) : super(Result.isLoading());

  Future<void> getGameDetails(int? sessionId, int? playerId) async {
    try {
      final data = await _queezyService.gameDetails(sessionId, playerId);
      emit(Result.data(data));
    } catch (e) {
      emit(Result.error(e));
    }
  }
}
