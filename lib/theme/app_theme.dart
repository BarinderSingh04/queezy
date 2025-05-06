import 'package:flutter/material.dart';

import '../common/common.dart';

class AppTheme {
  final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Color(0xff6A5AE0),
      onSecondary: Color(0xff858494),
      tertiary: Color(0xffEFEEFC),
      onTertiary: Color(0xffFF8FA2),
      // outline: Color(0xff333333),
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xff6A5AE0),
    textTheme: textTheme.apply(displayColor: Colors.black, bodyColor: Colors.black),
    primaryColor: Colors.black,
    useMaterial3: true,
    fontFamily: "Mont_Blanc_Regular",
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xff6A5AE0),
      surfaceTintColor: Color(0xff6A5AE0),
      titleTextStyle: TextStyle(fontFamily: FontFamily.w700, fontSize: 22, color: Colors.black),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(buttonColor: Colors.black),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontFamily: FontFamily.w700),
      ),
    ),
    iconTheme: IconThemeData(color: Colors.black),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.black; // Thumb color when the switch is ON
        }
        return Colors.grey; // Thumb color when the switch is OFF
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.black; // Track color when the switch is ON
        }
        return Colors.grey; // Track color when the switch is OFF
      }),
    ),
    cardTheme: CardTheme(color: Colors.white),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(side: BorderSide(color: Color(0xff808080))),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(color: Color(0xff858494)),
      contentPadding: EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static final textTheme = Typography.englishLike2021.copyWith(
    headlineSmall: TextStyle(fontSize: 28, fontFamily: FontFamily.w700),
    titleMedium: TextStyle(fontFamily: FontFamily.w700),
  );
}
