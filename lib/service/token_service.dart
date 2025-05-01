import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_dio/fresh_dio.dart';

import '../common/common.dart';

class TokenService {
 

  TokenService() {
    _dio = Dio()..options = BaseOptions(baseUrl: baseUrl);
    _fresh = Fresh<TokenModel>(
      httpClient: _dio,
      tokenStorage: SecureTokenStorage(),
      tokenHeader: (token) => {'authorization': 'Bearer ${token.token}'},
      refreshToken: _refreshToken,
      shouldRefresh: (response) {
        return response?.statusCode == 401;
      },
    );
  }
 

  late Fresh<TokenModel> _fresh;
  late Dio _dio;

  Fresh<TokenModel> get interceptor => _fresh;

  Future<TokenModel> _refreshToken(TokenModel? token, Dio httpClient) async {
    try {
      final result = await httpClient.post(
        "users/refresh-token",
        data: {"refresh_token": token?.refresh_token},
      );
      return TokenModel.fromMap(result.data["data"]);
    } catch (e) {
      rethrow;
    }
  }

  clearToken() {
    _fresh.clearToken();
  }

  void setToken(TokenModel tokenModel) async {
    await _fresh.setToken(tokenModel);
  }

  Future<TokenModel?> getToken() async {
    final token = await _fresh.token;
    return token;
  }
}

class SecureTokenStorage implements TokenStorage<TokenModel> {
  final storage = FlutterSecureStorage();

  @override
  Future<void> delete() async {
    await storage.delete(key: "token");
  }

  @override
  Future<TokenModel?> read() async {
    final token = await storage.read(key: "token");
    if (token != null) {
      return TokenModel.fromMap(jsonDecode(token));
    }
    return null;
  }

  @override
  Future<void> write(TokenModel token) async {
    await storage.write(key: "token", value: jsonEncode(token.toJson()));
  }
}

class TokenModel {
  String? token;
  String? refresh_token;

  TokenModel({this.token, this.refresh_token});

  factory TokenModel.fromMap(Map<String, dynamic> json) {
    return TokenModel(
      token: json["token"],
      refresh_token: json["refresh_token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"token": token, "refresh_token": refresh_token};
  }
}
