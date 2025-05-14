import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/models/room_model.dart';
import 'package:queezy/screens/service/queezy_service.dart';

class ActiveRoomCubit extends Cubit<Result<JoinRoomModel?>> {
  final QueezyService _queezyService;
  ActiveRoomCubit(this._queezyService) : super(Result.isLoading()) {
    activeRoom();
  }

  Future<void> activeRoom() async {
    try {
      final activeRoom = await _queezyService.getActiveRoom();
      emit(Result.data(activeRoom));
    } catch (e) {
      emit(Result.error(e));
    }
  }
}
