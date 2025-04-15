// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import '../common/common.dart';
// class TokenService {
//   static TokenService? _tokenService;
  
//   TokenService._internal(){
//     _dio = Dio()..options = BaseOptions(baseUrl: baseUrl);
//     _fresh = Fresh<TokenModel>(
//       httpClient: _dio,
//       tokenStorage: SecureTokenStorage(),
//       tokenHeader: (token) => {'authorization': 'Bearer ${token.accessToken}'},
//       refreshToken: _refreshToken,
//       shouldRefresh: (response) {
//         return response?.statusCode == 401;
//       },
//     );
//   }
//   static TokenService get instance{
//     if(_tokenService == null){
//       _tokenService = TokenService._internal();
//     } 
//     return _tokenService!;
//   }
//   late Fresh<TokenModel> _fresh;
//   late Dio _dio;
  
 
//   Fresh<TokenModel> get interceptor => _fresh;
 
//   Future<TokenModel> _refreshToken(TokenModel? token, Dio httpClient) async {
//     try {
//       final result = await httpClient.post(
//         "users/refresh-token",
//         data: {"refreshToken": token?.refreshToken},
//       );
//       return TokenModel.fromMap(result.data["data"]);
//     } catch (e) {
//       rethrow;
//     }
//   }
 
//   clearToken() {
//     _fresh.clearToken();
//   }
 
//   void setToken(TokenModel tokenModel) async {
//    await  _fresh.setToken(tokenModel);
//   }

//   Future<TokenModel?>  getToken() async {
//     final token = await _fresh.token;
//     return token;
//   }
// }
 

// class SecureTokenStorage implements TokenStorage<TokenModel> {
//   final storage = FlutterSecureStorage();

//   @override
//   Future<void> delete() async {
//     await storage.delete(key: "accessToken");
//   }

//   @override
//   Future<TokenModel?> read() async {
//     final token = await storage.read(key: "accessToken");
//     if (token != null) {
//       return TokenModel.fromMap(jsonDecode(token));
//     }
//     return null;
//   }

//   @override
//   Future<void> write(TokenModel token) async {
//     await storage.write(key: "accessToken", value: jsonEncode(token.toJson()));
//   }
// }

// class TokenModel {
//   String? accessToken;
//   String? refreshToken;

//   TokenModel({this.accessToken, this.refreshToken});

//   factory TokenModel.fromMap(Map<String, dynamic> json) {
//     return TokenModel(
//         accessToken: json["accessToken"], refreshToken: json["refreshToken"]);
//   }

//   Map<String, dynamic> toJson() {
//     return {"accessToken": accessToken, "refreshToken": refreshToken};
//   }
// }
