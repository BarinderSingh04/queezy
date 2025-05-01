

import 'package:queezy/screens/models/room_model.dart';

class PlayerScore extends Player {
  final num? total;
  final String? correct;
  final String? incorrect;
  final String? skipped;
  final num? accuracy;

  PlayerScore({
    this.total,
    this.correct,
    this.incorrect,
    this.skipped,
    this.accuracy,
    super.avatar,
    super.isHost,
    super.name,
    super.playerId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total': total,
      'correct': correct,
      'incorrect': incorrect,
      'skipped': skipped,
      'accuracy': accuracy,
    };
  }

  factory PlayerScore.fromMap(Map<String, dynamic> map) {
    return PlayerScore(
      total: map['total'] != null ? map['total'] as num : null,
      correct: map['correct'] != null ? map['correct'] as String : null,
      incorrect: map['incorrect'] != null ? map['incorrect'] as String : null,
      skipped: map['skipped'] != null ? map['skipped'] as String : null,
      accuracy: map['accuracy'] != null ? map['accuracy'] as num : null,
      playerId: map['playerId'],
      name: map['name'],
      avatar: map['avatar'],
      isHost: map['isHost'],
    );
  }
}
