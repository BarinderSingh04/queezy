import 'package:queezy/screens/models/room_model.dart';

class GameSession {
  int? sessionId;
  List<Questions>? questions;
  List<Player>? players;

  GameSession({this.sessionId, this.questions, this.players});

  GameSession.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    if (json['questions'] != null) {
      questions = (json['questions'] as List).map((q) => Questions.fromJson(q)).toList();
    }
    if (json['players'] != null) {
      players = (json['players'] as List).map((p) => Player.fromJson(p)).toList();
    }
  }
}

class Questions {
  String? type;
  String? difficulty;
  String? category;
  String? question;
  String? correctAnswer;
  List<String>? incorrectAnswers;
  List<String>? option;

  Questions({
    this.type,
    this.difficulty,
    this.category,
    this.question,
    this.correctAnswer,
    this.incorrectAnswers,
    this.option,
  });

  Questions.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    difficulty = json['difficulty'];
    category = json['category'];
    question = json['question'];
    correctAnswer = json['correct_answer'];
    incorrectAnswers = json['incorrect_answers'].cast<String>();
    final incorrectOptions = json['incorrect_answers'].cast<String>() ?? [];
    final options = <String>[...incorrectOptions, correctAnswer!];
    options.shuffle();
    option = options;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['difficulty'] = this.difficulty;
    data['category'] = this.category;
    data['question'] = this.question;
    data['correct_answer'] = this.correctAnswer;
    data['incorrect_answers'] = this.incorrectAnswers;

    return data;
  }
}
