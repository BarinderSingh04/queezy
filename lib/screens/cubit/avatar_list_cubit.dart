import 'package:bloc/bloc.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/models/avatar_model.dart';
import 'package:queezy/screens/service/queezy_service.dart';

class AvatarListCubit extends Cubit<Result<List<AvatarModel>>> {
  final QueezyService _queezyService;

  AvatarListCubit(this._queezyService) : super(Result(isLoading: false));

  Future<void> getAvatarList() async {
    try {
      emit(Result.isLoading());
      final response = await _queezyService.getAvatarList();
      emit(Result.data(response));
    } on Exception catch (e) {
      emit(Result.error(e));
    }
  }
}
