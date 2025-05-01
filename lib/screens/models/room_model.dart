class RoomModel {
  String? code;
  List<Player>? players;

  RoomModel({
    this.code,
    this.players,
  });

  RoomModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['players'] != null) {
      players = List<Player>.from(json['players'].map((x) => Player.fromJson(x)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['players'] = players?.map((x) => x.toJson()).toList();
    return data;
  }
}

class Player {
  num? playerId;
  String? name;
  String? avatar;
  bool? isHost;

  Player({this.playerId, this.name, this.avatar, this.isHost});

  Player.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    name = json['name'];
    avatar = json['avatar'];
    isHost = json['isHost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['playerId'] = playerId;
    data['name'] = name;
    data['avatar'] = avatar;
    data['isHost'] = isHost;
    return data;
  }
}