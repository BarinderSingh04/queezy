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
        data: {
          "email": email,
          "password": password,
          "name": name,
          "avatar": avatar,
          "confirmPassword": confirmPassword,
        },
      );
      final body = response.data;
      final auth = AuthModel.fromJson(body);
      _tokenService.setToken(TokenModel.fromMap(body));
      await _localStorageService.saveUser(auth.data!);
      return auth;
    } on DioException catch (e) {
      print("signup error: $e");
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<AuthModel> login({required String email, required String password}) async {
    try {
      final response = await DioSingleton.instance.dio.post(
        'login',
        data: {"password": password.trim(), "email": email.trim()},
      );
      final body = response.data;
      final content = body;
      final auth = AuthModel.fromJson(content);
      _tokenService.setToken(TokenModel.fromMap(content));
      await _localStorageService.saveUser(auth.data!);
      return auth;
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<User> user() async {
    try {
      final response = await DioSingleton.instance.dio.get('me');
      final body = response.data;
      return User.fromJson(body["data"]);
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  User? localUser() {
    return _localStorageService.getUser();
  }

  void logoutUser() {
    _localStorageService.clearSession();
    _tokenService.clearToken();
  }

  Future<User> updateProfile({String? name, String? email, String? avatar}) async {
    try {
      final response = await DioSingleton.instance.dio.post(
        'update_profile',
        data: {"name": name, "email": email, "avatar": avatar},
      );
      final body = response.data;
      final user = User.fromJson(body["data"]);
      await _localStorageService.saveUser(user);
      return user;
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
