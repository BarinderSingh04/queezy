import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/models/room_model.dart';
import 'package:queezy/screens/service/queezy_service.dart';

class LeaderBoardCubit extends Cubit<Result<List<LeaderBoardModel>>> {
  final QueezyService _queezyService;
  LeaderBoardCubit(this._queezyService) : super(Result.isLoading());

  Future<void> fetch() async {
    try {
      final result = await _queezyService.getLeaderBoard();
      emit(Result.data(result));
    } catch (e) {
      emit(Result.error(e));
    }
  }
}
