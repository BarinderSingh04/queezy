import 'package:flutter/material.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/widgets/buttons_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.colorScheme.primary),
        backgroundColor: context.colorScheme.tertiary,
        title: Text(
          "Reset Password",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your email and we will send you a link to reset your password.",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: Color(0xff858494),
                ),
              ),
              const SizedBox(height: 24),
              Text("Email Address", style: context.textTheme.bodyMedium),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    } else if (value.length > 10) {
                      return 'Username should have max 10 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: context.colorScheme.onPrimary,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: context.colorScheme.secondary,
                    ),
                    hintText: "Your email address",
                    hintStyle: Theme.of(
                      context,
                    ).textTheme.titleSmall!.copyWith(
                      color: Colors.grey,
                      fontFamily: FontFamily.w400,
                    ),
                  ),
                ),
              ),
              PrimaryButton(
                onPressed: () {
                  Navigator.pushNamed(context, NavRoute.newPassword.path);
                },
                label: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
