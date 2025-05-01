part of 'quiz_state_cubit.dart';

class QuizState {
  List<Answer> answers;
  QuizState({required this.answers});

  int get correctAnswers {
    return answers.where((answer) => answer.givenAnswer == answer.correctAnswer).length;
  }

  int get points {
    return correctAnswers * 10;
  }

  int get incorrectAnswers {
    return answers
        .where((answer) => answer.givenAnswer != answer.correctAnswer && answer.givenAnswer != null)
        .length;
  }

  double get completion {
    return (correctAnswers / answers.length) * 100;
  }

  int get skipped {
    return answers.where((answer) => answer.givenAnswer == null).length;
  }

  String label(double number) {
    if (number == 1) {
      return "Skipped";
    } else if (number == 2.5) {
      return "Incorrect";
    } else {
      return "Correct";
    }
  }

  List<FlSpot> get chatData => List.generate(answers.length, (index) {
    return FlSpot(
      index + 1,
      answers[index].isSkipped
          ? 1
          : answers[index].isCorrectAnswer
          ? 4
          : 2.5,
    );
  });
}

class Answer {
  final int index;
  final String? givenAnswer;
  final String correctAnswer;
  final String question;

  Answer({
    required this.index,
    required this.givenAnswer,
    required this.correctAnswer,
    required this.question,
  });

  bool get isCorrectAnswer {
    return givenAnswer == correctAnswer;
  }

  bool get isIncorrectAnswer {
    return givenAnswer != correctAnswer && givenAnswer != null;
  }

  bool get isSkipped {
    return givenAnswer == null;
  }
}

