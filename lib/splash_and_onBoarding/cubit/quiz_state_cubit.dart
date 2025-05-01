import 'package:bloc/bloc.dart';
import 'package:fl_chart/fl_chart.dart';

part 'quiz_state.dart';

class QuizStateCubit extends Cubit<QuizState> {
  QuizStateCubit() : super(QuizState(answers: []));

  void attempt({
    required int index,
    required String? givenAnswer,
    required String correctAnswer,
    required String question,
  }) {
    if (state.answers.any((e) => e.index == index)) return;
    emit(
      QuizState(
        answers: [
          ...state.answers,
          Answer(
            index: index,
            givenAnswer: givenAnswer,
            correctAnswer: correctAnswer,
            question: question,
          ),
        ],
      ),
    );
  }
}
