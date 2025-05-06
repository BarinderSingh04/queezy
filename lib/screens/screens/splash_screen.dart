import 'dart:async';

import 'package:flutter/material.dart';
import 'package:queezy/routes/routes.dart';

import '../../di/service_locator.dart';
import '../../service/token_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      final token = await getIt<TokenService>().getToken();

      if (token != null && token.token != null) {
        Navigator.pushNamed(context, NavRoute.bottomNav.path);
      } else {
        Navigator.pushNamed(context, NavRoute.onBoarding.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Color(0xff6A5AE0)),
          child: Center(child: Image.asset("assets/images/logo.png")),
        ),
      ),
    );
  }
}
