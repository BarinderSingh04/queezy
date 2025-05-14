import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentIndex < content.length - 1) {
        currentIndex++;
        _controller.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        setState(() {});
      } else {
        _timer?.cancel();
        Navigator.pushReplacementNamed(context, NavRoute.loginSignupOption.path);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff6A5AE0),
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 400,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: content.length,
                  onPageChanged: (int value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                  itemBuilder: (_, index) {
                    return Center(
                      child: Image.asset(content[index].image, width: size.width * 0.9),
                    );
                  },
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(content.length, (index) => buildDot(index)),
            ),

            const SizedBox(height: 24),
            Container(
              height: 224,
              width: 345,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    content[currentIndex].description,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleLarge!.copyWith(fontFamily: FontFamily.w500),
                  ),

                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6A5AE0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        if (currentIndex == content.length - 1) {
                          context.go(NavRoute.loginSignupOption.path);
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child:
                          currentIndex < content.length - 1
                              ? Text(
                                'Next',
                                style: context.textTheme.bodyLarge!.copyWith(
                                  color: context.colorScheme.onPrimary,
                                  fontFamily: FontFamily.w500,
                                ),
                              )
                              : Text(
                                'Sign Up',
                                style: context.textTheme.bodyLarge!.copyWith(
                                  color: context.colorScheme.onPrimary,
                                  fontFamily: FontFamily.w500,
                                ),
                              ),
                    ),
                  ),

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
                          context.go(NavRoute.login.path);
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
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    bool isActive = currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.all(14),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.transparent,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
    );
  }
}
