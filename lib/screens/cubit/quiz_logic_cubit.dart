import 'package:bloc/bloc.dart';
import 'package:queezy/screens/models/quiz_result.dart';

class QuizLogicCubit extends Cubit<QuizResult> {
  QuizLogicCubit() : super(QuizResult(answere: []));

  void getResult({
    int? index,
    String? answereGiven,
    String? correctAnswer,
    String? question,
    String? category,
  }) {
    final extistingIndex =  state.answere.indexWhere((e) => e.index == index);

    if (index == extistingIndex &&  state.answere.any((e) => e.answereGiven != null))
      return;
    else
      state.answere.add(
        Answere(
          index: index,
          answereGiven: answereGiven,
          correctAnswer: correctAnswer,
          question: question,
          category: category,
        ),
      );
    emit(QuizResult(answere: state.answere));
  }
}
