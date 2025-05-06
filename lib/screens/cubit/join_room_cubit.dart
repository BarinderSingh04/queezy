import 'package:bloc/bloc.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/models/room_model.dart';
import 'package:queezy/screens/service/queezy_service.dart';

class JoinRoomCubit extends Cubit<Result<JoinRoomModel>> {
  final QueezyService _queezyService;
  JoinRoomCubit(this._queezyService) : super(Result(isLoading: false));

  Future<void> join({required String roomCode}) async {
    emit(Result.isLoading());
    try {
      final response = await _queezyService.joinRoom(roomCode: roomCode);
      emit(Result.data(response));
    } catch (e) {
      emit(Result.error(e.toString()));
    }
  }
}
