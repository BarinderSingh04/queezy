class PlayerScore {
  int? playerId;
  String? name;
  String? avatar;
  int? total;
  String? correct;
  String? incorrect;
  String? skipped;
  num? accuracy;
  List<Attemps>? attemps;

  PlayerScore({
    this.playerId,
    this.name,
    this.avatar,
    this.total,
    this.correct,
    this.incorrect,
    this.skipped,
    this.attemps,
  });

  PlayerScore.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    name = json['name'];
    avatar = json['avatar'];
    total = json['total'];
    correct = json['correct'];
    incorrect = json['incorrect'];
    skipped = json['skipped'];
    accuracy = json["accuracy"];
    if (json['attemps'] != null) {
      attemps = <Attemps>[];
      json['attemps'].forEach((v) {
        attemps!.add(new Attemps.fromJson(v));
      });
    }
  }
}

class Attemps {
  int? playerId;
  String? questionText;
  String? selectedAnswer;
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
    correct = json['correct'];
    skipped = json['skipped'];
    incorrect = json['incorrect'];
  }
}
