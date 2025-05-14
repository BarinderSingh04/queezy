import '../../common/common.dart';

class PlayerScore {
  int? playerId;
  String? name;
  String? avatar;
  int? total;
  num? correct;
  num? incorrect;
  num? skipped;
  num? accuracy;

  PlayerScore({
    this.playerId,
    this.name,
    this.avatar,
    this.total,
    this.correct,
    this.incorrect,
    this.skipped,
  });

  String get path => "$baseUrl$avatar";

  PlayerScore.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    name = json['name'];
    avatar = json['avatar'];
    total = json['total'];
    correct = num.tryParse(json['correct']);
    incorrect = num.tryParse(json['incorrect']);
    skipped = num.tryParse(json['skipped']);
    accuracy = json["accuracy"];
  }
}

class Attemps {
  int? playerId;
  String? questionText;
  String? selectedAnswer;
  String? correctAnswer;
  String? difficulty;
  int? categoryId;
  int? correct;
  int? skipped;
  int? incorrect;

  Attemps({
    this.playerId,
    this.questionText,
    this.selectedAnswer,
    this.correct,
    this.skipped,
    this.incorrect,
  });

  Attemps.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    questionText = json['questionText'];
    selectedAnswer = json['selectedAnswer'];
    categoryId = json['categoryId'];
    difficulty = json['difficulty'];
    correctAnswer = json['correctAnswer'];
    correct = json['correct'];
    skipped = json['skipped'];
    incorrect = json['incorrect'];
  }
}
