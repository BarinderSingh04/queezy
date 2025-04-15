import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/service/queezy_service.dart';
import 'package:queezy/splash_and_onBoarding/models/queezy_model.dart';

class QueezyListCubit extends Cubit<Result<List<QueezyModel>>> {
  final QueezyService _queezyService;
  QueezyListCubit(this._queezyService) : super(Result(isLoading: true));

  Future<void> getquestion({String? difficulity, String? category}) async {
    try {
      emit(Result(isLoading: true));
      final response = await _queezyService.getQuizData(difficulity: difficulity,category: category);
      emit(Result(data: response));
    }on DioException catch (e) {
      emit(Result(error: e.toString()));
    }
  }
}
