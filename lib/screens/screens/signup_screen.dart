import 'package:flutter/material.dart';
import 'package:queezy/common/common.dart';

import '../../routes/routes.dart';
import '../../widgets/buttons_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final signupKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.colorScheme.primary),
        backgroundColor: context.colorScheme.tertiary,
        title: Text(
          "Sign Up",
          style: context.textTheme.headlineMedium!.copyWith(
            fontFamily: FontFamily.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: context.colorScheme.tertiary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
            child: Form(
              key: signupKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryIconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, NavRoute.signupPage.path);
                    },
                    label: 'Sign Up with Email',
                    icon: Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 20),
                  GoogleLoginButton(onPressed: () {}),
                  const SizedBox(height: 20),
                  FacebookLoginButton(onPressed: () {}),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colorScheme.onSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            NavRoute.login.path,
                          );
                        },
                        child: Text(
                          "Login",
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.secondary,
                            fontFamily: FontFamily.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "By continuing, you agree to the ",
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms of Services',
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontFamily: FontFamily.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' & ',
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: 'Privacy Policy.',
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontFamily: FontFamily.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
