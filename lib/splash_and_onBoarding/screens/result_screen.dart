import 'package:flutter/material.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/splash_and_onBoarding/models/quiz_result.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, this.result});
  final QuizResult? result;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.onPrimary,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: context.colorScheme.onPrimary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        "Good Job!",
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontFamily: FontFamily.w500,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        NavRoute.chooseCategory.path,
                        (route) => true,
                      );
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: context.colorScheme.onTertiary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 24,
                    ),
                    child: Column(
                      children: [
                        Image.asset("assets/images/award.png"),
                        const SizedBox(height: 8),
                        Text(
                          "Yoy get+80 Quiz Points",
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: context.colorScheme.onPrimary,
                            fontFamily: FontFamily.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white30,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Check Correct Answer",
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: context.colorScheme.onPrimary,
                              fontFamily: FontFamily.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CORRECT ANSWERE",
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: Colors.grey,
                                    fontFamily: FontFamily.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${widget.result?.correct} questions ",
                                  style: context.textTheme.titleLarge!.copyWith(
                                    fontFamily: FontFamily.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "COMPLETION",
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: Colors.grey,
                                    fontFamily: FontFamily.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${widget.result?.completion.floor()} %",
                                  style: context.textTheme.titleLarge!.copyWith(
                                    fontFamily: FontFamily.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "SKIPPED",
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: Colors.grey,
                                    fontFamily: FontFamily.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${widget.result?.skipped} " ,
                                  style: context.textTheme.titleLarge!.copyWith(
                                    fontFamily: FontFamily.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "INCORRECT ANSWERE",
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: Colors.grey,
                                    fontFamily: FontFamily.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${widget.result?.incorrect}",
                                  style: context.textTheme.titleLarge!.copyWith(
                                    fontFamily: FontFamily.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Done",
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: context.colorScheme.onPrimary,
                          fontFamily: FontFamily.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: context.colorScheme.onSecondary,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.share_outlined,
                        color: context.colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
