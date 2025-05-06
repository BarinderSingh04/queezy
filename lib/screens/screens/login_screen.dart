import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/cubit/auth_cubit.dart';
import 'package:queezy/screens/models/auth_model.dart';
import 'package:queezy/widgets/buttons_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginkey = GlobalKey<FormState>();
  final passKey = GlobalKey<FormFieldState>();

  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.colorScheme.primary),
        backgroundColor: context.colorScheme.tertiary,
        title: Text(
          "Login",
          style: context.textTheme.headlineMedium!.copyWith(fontFamily: FontFamily.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: context.colorScheme.tertiary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: BlocConsumer<AuthCubit, Result<AuthModel>>(
              listener: (context, state) {
                if (state.data != null) {
                  Navigator.pushNamed(context, NavRoute.bottomNav.path);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Login successfull!")));
                }
                if (state.error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error.toString())));
                }
              },
              builder: (context, state) {
                return Form(
                  key: loginkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GoogleLoginButton(onPressed: () {}),
                      const SizedBox(height: 20),
                      FacebookLoginButton(onPressed: () {}),
                      const SizedBox(height: 24),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(child: Container(color: Color(0xffE6E6E6), height: 2)),

                          Text(
                            'OR',
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.onSecondary,
                            ),
                          ),
                          Expanded(child: Container(color: Color(0xffE6E6E6), height: 2)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email Address", style: context.textTheme.bodyMedium),
                          const SizedBox(height: 16),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return 'Please enter a valid email format';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              context.read<AuthCubit>().updateForm("email", value);
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: context.colorScheme.secondary,
                              ),
                              hintText: "Your email address",
                            ),
                          ),
                          const SizedBox(height: 26),
                          Text("Password", style: context.textTheme.bodyMedium),
                          const SizedBox(height: 16),
                          TextFormField(
                            key: passKey,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 8) {
                                return 'Password must be at least 8 characters long';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              context.read<AuthCubit>().updateForm("password", value);
                            },
                            obscureText: !passwordVisible,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: context.colorScheme.secondary,
                              ),
                              hintText: "Enter password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              if (loginkey.currentState!.validate()) {
                                loginkey.currentState?.save();
                                context.read<AuthCubit>().login();
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            isLoading: context.watch<AuthCubit>().state.isLoading,
                            onPressed: () {
                              if (loginkey.currentState!.validate()) {
                                loginkey.currentState?.save();
                                context.read<AuthCubit>().login();
                              }
                            },
                            label: "Login",
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: PlainTextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, NavRoute.resetPassword.path);
                              },
                              label: 'Forget Password?',
                              color: context.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "By continuing, you agree to the ",
                          style: context.textTheme.bodyMedium!.copyWith(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: 'Terms of Services',
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontFamily: FontFamily.w500,
                              ),
                            ),
                            TextSpan(
                              text: ' & ',
                              style: context.textTheme.bodyMedium!.copyWith(color: Colors.grey),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
