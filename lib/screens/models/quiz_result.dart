
class Answere {
  int? index;
  String? category;
  String? answereGiven;
  String? correctAnswer;
  String? question;

  Answere({
    this.index,
    this.answereGiven,
    this.correctAnswer,
    this.question,
   this.category
  });

  bool get isCorrect{
    return answereGiven == correctAnswer;
  }

  bool get isSkipped{
    return answereGiven == null;
  }

  bool get isIncorrect{
    return answereGiven != correctAnswer && answereGiven != null;
  }

  
}



class QuizResult {
  List<Answere> answere;
  QuizResult({
    required this.answere,
  });

  int get correctAnswere {
    return answere.where((e) => e.isCorrect).length;
  }

  int get points{
    return correctAnswere * 10;
  }

  int get incorect{
    return 10 - (correctAnswere + skipped);
  }

  int get skipped{
    return answere.where((e) => e.isSkipped).length;
  }

  double get completion{
    return (correctAnswere / answere.length) * 100;
  }

  String? get category {
    return answere.firstWhere((e) => e.category != null, orElse: () => Answere()).category;
  }


}
