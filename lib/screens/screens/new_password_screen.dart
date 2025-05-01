import 'package:flutter/material.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/widgets/buttons_widget.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final passKey = GlobalKey<FormFieldState>();
  final confpassKey = GlobalKey<FormFieldState>();
  bool passwordVisible = false;
  bool confPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.colorScheme.primary),
        backgroundColor: context.colorScheme.tertiary,
        title: Text(
          "New Password",
          style: context.textTheme.headlineMedium!.copyWith(
            fontFamily: FontFamily.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        color: context.colorScheme.tertiary,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your new password must be different from previous used passwords.',
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: Color(0xff858494),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Password", style: context.textTheme.bodyMedium),
                      const SizedBox(height: 12),
                      Container(
                        height: 60,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: context.colorScheme.secondary,
                            width: 2,
                          ),
                        ),
                        child: TextFormField(
                          key: passKey,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                          onSaved: (value) {},
                          obscureText: !passwordVisible,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: context.colorScheme.onPrimary,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: context.colorScheme.secondary,
                            ),
                            hintText: "Enter password",
                            hintStyle: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(
                              color: Colors.grey,
                              fontFamily: FontFamily.w400,
                            ),
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
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Must be at least 8 characters.',
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: Color(0xff858494),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Confirm Password",
                        style: context.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 60,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: context.colorScheme.secondary,
                            width: 2,
                          ),
                        ),
                        child: TextFormField(
                          key: confpassKey,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                          onSaved: (value) {},
                          obscureText: !passwordVisible,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: context.colorScheme.onPrimary,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: context.colorScheme.secondary,
                            ),
                            hintText: "Enter password",
                            hintStyle: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(
                              color: Colors.grey,
                              fontFamily: FontFamily.w400,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                confPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  confPasswordVisible = !confPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PrimaryButton(onPressed: () {}, label: 'Reset Password'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
