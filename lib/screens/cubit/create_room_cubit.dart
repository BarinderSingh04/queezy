import 'package:bloc/bloc.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/models/room_model.dart';
import 'package:queezy/screens/service/queezy_service.dart';

class CreateRoomCubit extends Cubit<Result<RoomModel>> {
  final QueezyService _queezyService;
  CreateRoomCubit(this._queezyService) : super(Result(isLoading: false));

  Future<void> createRoom({
    required int categoryId,
    required String type,
    required String difficulty,
  }) async {
    emit(Result.isLoading());
    try {
      final response = await _queezyService.createRoom(
        type: type,
        difficulty: difficulty,
        category: categoryId,
      );
      emit(Result.data(response));
    } catch (e) {
      emit(Result.error(e.toString()));
    }
  }
}
