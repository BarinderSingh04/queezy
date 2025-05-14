import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      final authState = context.read<AuthCubit>().state;
      final isLoggedIn = authState is AuthenticatedState;

      if (isLoggedIn) {
        context.go(NavRoute.home.path);
      } else {
        context.go(NavRoute.onBoarding.path);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff6A5AE0)),
        child: Center(child: Image.asset("assets/images/logo.png")),
      ),
    );
  }
}
