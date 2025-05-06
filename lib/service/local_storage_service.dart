import 'dart:convert';

import '../screens/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _pref ;
  LocalStorageService(this._pref);

  Future<bool> clearSession() async{
    return _pref.clear();
  }

  Future<void> saveUser(User user) async{
    await _pref.setString("user", jsonEncode(user.toJson()));
  }

  User? getUser() {
    final userJson = _pref.getString("user");
    if(userJson != null){
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }
}
