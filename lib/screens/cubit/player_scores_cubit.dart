import 'package:bloc/bloc.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/models/player_score.dart';
import 'package:queezy/screens/service/queezy_service.dart';

class PlayerScoresCubit extends Cubit<Result<PlayerScore>> {
  final QueezyService _queezyService;
  PlayerScoresCubit(this._queezyService) : super(Result(isLoading: true));

  Future<void> getScore(int? session_id)async{
    try {
      emit(Result(isLoading: true));
      final response = await _queezyService.getPlayerScore(session_id);
      emit(Result(data: response));
    } catch (e) {
      emit(Result.error(e));
    }
  }
}
