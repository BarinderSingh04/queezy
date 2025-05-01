import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/service/queezy_service.dart';
import 'package:queezy/screens/models/queezy_model.dart';

class QueezyListCubit extends Cubit<Result<Queezy>> {
  final QueezyService _queezyService;
  QueezyListCubit(this._queezyService) : super(Result(isLoading: true));

  Future<void> getquestion({String? difficulity, num? category,String? type, String? roomcode}) async {
    try {
      emit(Result(isLoading: true));
      final response = await _queezyService.getQuizData(difficulity: difficulity,category: category,type: type,roomcode: roomcode);
      emit(Result(data: response));
    }on DioException catch (e) {
      emit(Result(error: e.toString()));
    }
  }
}
