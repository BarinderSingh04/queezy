import 'package:dio/dio.dart';
import 'package:queezy/screens/models/auth_model.dart';
import 'package:queezy/service/dio_exceptions.dart';
import 'package:queezy/service/dio_instance.dart';
import 'package:queezy/service/local_storage_service.dart';

import '../../service/token_service.dart';

class AuthService {
  final LocalStorageService _localStorageService;
  final TokenService _tokenService;
  AuthService(this._localStorageService, this._tokenService);

  Future<AuthModel> signup({
    required String? email,
    required String? password,
    required String? confirmPassword,
    required String? name,
    required String? avatar,
  }) async {
    try {
      final response = await DioSingleton.instance.dio.post(
        "register",
        data: {"email": email},
      );
      final body = response.data;
      return AuthModel.fromJson(body['data']);
    } on DioException catch (e) {
      print("signup error: $e");
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioSingleton.instance.dio.post(
        'login',
        data: {"password": password.trim(), "email": email.trim()},
      );
      final body = response.data;
      final content = body;
      final user = AuthModel.fromJson(content);
      _tokenService.setToken(TokenModel.fromMap(content));
      await _localStorageService.saveUser(user);
      return AuthModel.fromJson(body["data"]);
    } on DioException catch (e) {
      print("login error: $e");
      throw DioExceptions.fromDioError(e);
    }
  }

  void logoutUser() {
    _localStorageService.clearSession();
    _tokenService.clearToken();
  }
}
