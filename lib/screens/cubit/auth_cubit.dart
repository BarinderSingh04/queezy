import 'package:bloc/bloc.dart';

import '../models/auth_model.dart';
import '../service/auth_service.dart';

class AuthCubit extends Cubit<AuthenticationState> {
  final AuthService _authService;
  final Map<String, dynamic> _formData = {};

  AuthCubit(this._authService) : super(AuthenticationInitial()) {
    final user = _authService.localUser();
    if (user != null) {
      emit(AuthenticatedState(AuthModel(data: user)));
    } else {
      emit(UnAuthenticatedState());
    }
  }

  Future<void> signup() async {
    emit(AuthenticationLoading());
    try {
      final signup = await _authService.signup(
        name: _formData['name'],
        email: _formData['email'],
        password: _formData['password'],
        confirmPassword: _formData['confirmPassword'],
        avatar: _formData['avatar'],
      );
      emit(AuthenticatedState(signup));
    } catch (e) {
      emit(AuthenticationFailure('Signup failed: ${e.toString()}'));
    } finally {
      clearForm();
    }
  }

  Future<void> login() async {
    emit(AuthenticationLoading());
    try {
      final login = await _authService.login(
        email: _formData['email'],
        password: _formData['password'],
      );
      emit(AuthenticatedState(login));
    } catch (e) {
      emit(AuthenticationFailure('Login failed: ${e.toString()}'));
    } finally {
      clearForm();
    }
  }

  Future<void> updateProfile() async {
    emit(AuthenticationLoading());
    try {
      final user = await _authService.updateProfile(
        name: _formData['name'],
        email: _formData['email'],
        avatar: _formData['avatar'],
      );
      emit(AuthenticatedState(AuthModel(data: user)));
    } catch (e) {
      emit(AuthenticationFailure('Update failed: ${e.toString()}'));
    } finally {
      clearForm();
    }
  }

  Future<void> logout() async {
    _authService.logoutUser();
    emit(UnAuthenticatedState());
  }

  void updateForm(String key, dynamic value) {
    _formData[key] = value;
  }

  void clearForm() {
    _formData.clear();
  }

  bool isValidForm() {
    return _formData['email'] != null && _formData['password'] != null;
  }
}

sealed class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationUpdateProfile extends AuthenticationState {
  final AuthModel authModel;
  AuthenticationUpdateProfile(this.authModel);
}

class UnAuthenticatedState extends AuthenticationState {}

class AuthenticatedState extends AuthenticationState {
  final AuthModel authModel;
  AuthenticatedState(this.authModel);
}

class AuthenticationFailure extends AuthenticationState {
  final String error;
  AuthenticationFailure(this.error);
}
