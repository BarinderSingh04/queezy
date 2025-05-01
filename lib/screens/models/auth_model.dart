class AuthModel {
  int? success;
  String? token;
  String? refreshToken;
  Data? data;

  AuthModel({this.success, this.token, this.refreshToken, this.data});

  AuthModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    token = json['token'];
    refreshToken = json['refresh_token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['token'] = this.token;
    data['refresh_token'] = this.refreshToken;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? avatar;
  String? createdAt;

  Data({this.id, this.name, this.email, this.avatar, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
