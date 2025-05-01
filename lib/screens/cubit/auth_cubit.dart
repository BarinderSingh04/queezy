import 'package:bloc/bloc.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/models/auth_model.dart';
import 'package:queezy/screens/service/auth_service.dart';

class AuthCubit extends Cubit<Result<AuthModel>> {
  final AuthService _authService;
  final Map<String, dynamic> _formData = {};

  AuthCubit(this._authService) : super(Result(isLoading: false));

  Future<void> signup() async {
    emit(Result(isLoading: true));

    try {
      final signup = await _authService.signup(
        name: _formData['name'],
        email: _formData['email'],
        password: _formData['password'],
        confirmPassword: _formData['confirmPassword'],
        avatar: _formData['avatar'],
      );
      emit(Result(data: signup));
      clearForm();
    } catch (e) {
      emit(Result.error('Signup failed: ${e.toString()}'));
    }
  }

  Future<void> login() async {
    emit(Result.isLoading());

    try {
      final login = await _authService.login(
        email: _formData['email'],
        password: _formData['password'],
      );
      emit(Result.data(login));
      clearForm();
    } catch (e) {
      emit(Result.error('Login failed: ${e.toString()}'));
    }
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
