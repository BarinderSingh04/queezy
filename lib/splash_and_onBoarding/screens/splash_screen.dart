import 'dart:async';

import 'package:flutter/material.dart';
import 'package:queezy/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, NavRoute.chooseCategory.path);
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
