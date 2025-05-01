import 'package:bloc/bloc.dart';
import 'package:queezy/splash_and_onBoarding/models/create_quiz.dart';

class CreateQuizCubit extends Cubit<CreateQuiz> {
  CreateQuizCubit() : super(CreateQuiz());

  void update(CreateQuiz Function(CreateQuiz qz) up) {
    emit(up(state));
  }

  void set(CreateQuiz quiz) {
    emit(quiz);
  }

  void reset() {
    emit(CreateQuiz());
  }
}
