import 'package:flutter/material.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/widgets/buttons_widget.dart';

class LoginSignupOptionScreen extends StatefulWidget {
  const LoginSignupOptionScreen({super.key});

  @override
  State<LoginSignupOptionScreen> createState() =>
      _LoginSignupOptionScreenState();
}

class _LoginSignupOptionScreenState extends State<LoginSignupOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Image.asset("assets/images/logo.png", height: 80),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Queezy",
              style: context.textTheme.titleLarge!.copyWith(
                color: context.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Image.asset("assets/images/optionIllustration.png"),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: context.colorScheme.onPrimary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Login or Sign Up",
                      style: context.textTheme.headlineMedium!.copyWith(
                        fontFamily: FontFamily.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Login or create an account to take quiz, take part in challenge, and more.",
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: context.colorScheme.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      onPressed: () {
                        Navigator.pushNamed(context, NavRoute.login.path);
                      },
                      label: "Login",
                    ),
                    const SizedBox(height: 20),
                    LightPrimaryButton(
                      onPressed: () {
                        Navigator.pushNamed(context, NavRoute.signup.path);
                      },
                      label: "Create an account",
                    ),
                    const SizedBox(height: 10),
                    PlainTextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, NavRoute.bottomNav.path);
                      },
                      label: "Later",
                      color: context.colorScheme.onSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
