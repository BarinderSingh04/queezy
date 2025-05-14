import 'package:queezy/common/common.dart';
import 'package:queezy/screens/models/player_score.dart';

class RoomModel {
  String? code;
  Player? player;
  String? type;
  int? categoryId;
  String? difficulty;

  RoomModel({
    this.code,
    this.player,
    required this.type,
    required this.categoryId,
    required this.difficulty,
  });

  RoomModel.fromJson(Map<String, dynamic> json) {
    code = json['roomCode'];
    player = json['player'] != null ? Player.fromJson(json['player']) : null;
    type = json['type'];
    categoryId = json['categoryId'];
    difficulty = json['difficulty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomCode'] = code;
    if (player != null) {
      data['player'] = player!.toJson();
    }
    data['type'] = type;
    data['categoryId'] = categoryId;
    data['difficulty'] = difficulty;
    return data;
  }

  RoomModel copyWith({
    String? code,
    Player? player,
    String? type,
    int? categoryId,
    String? difficulty,
  }) {
    return RoomModel(
      code: code ?? this.code,
      player: player ?? this.player,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

extension PlayerExtension on Player {
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['playerId'] = playerId;
    data['name'] = name;
    data['avatar'] = avatar;
    data['isHost'] = isHost;
    return data;
  }
}

class Player {
  num? playerId;
  num? userId;
  String? name;
  String? avatar;
  bool? isHost;

  Player({this.playerId, this.name, this.avatar, this.isHost});

  String get avatarUrl => "$baseUrl$avatar";

  Player.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    userId = json['userId'];
    name = json['name'];
    avatar = json['avatar'];
    isHost = json['isHost'];
  }
}

class JoinRoomModel extends RoomModel {
  final List<Player> players;

  JoinRoomModel({
    required this.players,
    required super.type,
    required super.categoryId,
    required super.difficulty,
    super.code,
    super.player,
  });

  factory JoinRoomModel.fromJson(Map<String, dynamic> json) {
    return JoinRoomModel(
      players: List<Player>.from(json['players'].map((x) => Player.fromJson(x))),
      code: json['roomCode'],
      type: json['type'],
      player: Player.fromJson(json['player']),
      categoryId: json['categoryId'],
      difficulty: json['difficulty'],
    );
  }
}

class LeaderBoardModel extends Player {
  num? totalScore;
  num? gamesPlayed;

  LeaderBoardModel({super.playerId, super.name, super.avatar, this.totalScore, this.gamesPlayed});

  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    return LeaderBoardModel(
      playerId: json['playerId'],
      name: json['name'],
      avatar: json['avatar'],
      gamesPlayed: json['gamesPlayed'],
      totalScore: num.tryParse(json['totalScore']),
    );
  }
}

class GameDetail {
  final num? correct;
  final num? incorrect;
  final num? skipped;
  final num? total;
  final RoomModel? room;
  final List<Attemps> attempts;

  GameDetail({
    required this.room,
    required this.attempts,
    this.correct,
    this.incorrect,
    this.skipped,
    this.total,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    return GameDetail(
      correct: json['correct'],
      incorrect: json['incorrect'],
      skipped: json['skipped'],
      total: json['total'],
      room: json['room'] != null ? RoomModel.fromJson(json['room']) : null,
      attempts: List<Attemps>.from(json['attempts'].map((x) => Attemps.fromJson(x))),
    );
  }
}
