// import 'package:rika_ecomm_app/model/products.dart';

import 'package:flutter/material.dart';

class Result<T> {
  bool isLoading;
  T? data;
  Object? error;
  bool isRefreshing;

  Result({this.isLoading = false, this.error, this.data, this.isRefreshing = false});

  factory Result.isLoading() => Result(isLoading: true);
  factory Result.data(T data) => Result(data: data);
  factory Result.error(Object? error) => Result(error: error);
  factory Result.isRefreshing() => Result(isRefreshing: true);
}

extension ResultX<T> on Result<T> {
  Widget when({
    required Widget Function(T? data) onData,
    required Widget Function() onLoading,
    required Widget Function(Object? e) onError,
  }) {
    if(isLoading) {
      return onLoading(); 
    }
    if(error != null) {
      return onError(error);
    } 
    return onData(data);
  }
}
