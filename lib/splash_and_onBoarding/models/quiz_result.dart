// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class QuizResult {
  int correct;
  int skipped;
  int incorrect;
  double completion;
  QuizResult({
    required this.correct,
    required this.skipped,
    required this.incorrect,
    required this.completion,
  });


  QuizResult copyWith({
    int? correct,
    int? skipped,
    int? incorrect,
    double? completion,
  }) {
    return QuizResult(
      correct: correct ?? this.correct,
      skipped: skipped ?? this.skipped,
      incorrect: incorrect ?? this.incorrect,
      completion: completion ?? this.completion,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'correct': correct,
      'skipped': skipped,
      'incorrect': incorrect,
      'completion': completion,
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      correct: map['correct'] as int,
      skipped: map['skipped'] as int,
      incorrect: map['incorrect'] as int,
      completion: map['completion'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizResult.fromJson(String source) => QuizResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Result(correct: $correct, skipped: $skipped, incorrect: $incorrect, completion: $completion)';
  }

  @override
  bool operator ==(covariant QuizResult other) {
    if (identical(this, other)) return true;
  
    return 
      other.correct == correct &&
      other.skipped == skipped &&
      other.incorrect == incorrect &&
      other.completion == completion;
  }

  @override
  int get hashCode {
    return correct.hashCode ^
      skipped.hashCode ^
      incorrect.hashCode ^
      completion.hashCode;
  }
}
