import 'package:dio/dio.dart';

import '../common/common.dart';
import '../di/service_locator.dart';
import 'token_service.dart';

class DioSingleton {
  static  DioSingleton? _dioSingleton;
  final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiZW1haWwiOiJiZWFudEBnbWFpbC5jb20iLCJpYXQiOjE3NDYwMDg4MTIsImV4cCI6MTc0NjA5NTIxMn0.y4xVTtZ6gfU8FTyhk1lCARkQn2nIijUHZQbGvbvvQLU";
   DioSingleton._internal(){
    dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: Duration(minutes: 1),
        sendTimeout: Duration(minutes: 1),
        receiveTimeout: Duration(minutes: 1),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );
    dio.interceptors.add(getIt<TokenService>().interceptor);
    dio.interceptors.add(LogInterceptor());
   }
  late Dio dio;

  static DioSingleton get instance{
    if(_dioSingleton == null){
      _dioSingleton = DioSingleton._internal();
    } 
    return _dioSingleton!;
  }

  
}


