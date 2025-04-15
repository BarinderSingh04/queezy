import 'package:flutter/material.dart';

String baseUrl = "https://opentdb.com/api.php?";

abstract class FontFamily {
  static String get w700 => "Rubik_Bold";
  static String get w800 => "Rubik_Black";
  static String get w500 => "Rubik_Medium";
  static String get w400 => "Rubik_Regular";
}

extension ThemeGetter on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
