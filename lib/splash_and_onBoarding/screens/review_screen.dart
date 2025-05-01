import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:queezy/splash_and_onBoarding/cubit/create_quiz_cubit.dart';
import 'package:queezy/splash_and_onBoarding/models/create_quiz.dart';

import '../../common/common.dart';
import '../cubit/quiz_state_cubit.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: BlocBuilder<QuizStateCubit, QuizState>(
            builder: (context, quizState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              "Review Answers",
                              style: context.textTheme.headlineSmall!.copyWith(
                                fontFamily: FontFamily.w500,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: Container(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff6A5AE0),
                      ),
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
                                      "Quiz Category",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    BlocBuilder<CreateQuizCubit, CreateQuiz>(
                                      builder: (context, state) {
                                        return Text(
                                          state.categoryName ?? "",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.extension, size: 20, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xffFF8FA2),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 8),
                                  SizedBox.square(
                                    dimension: 85,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Animate().custom(
                                            duration: Duration(milliseconds: 800),
                                            begin: 0,
                                            end: quizState.completion / 100,
                                            curve: Curves.easeInOut,
                                            builder:
                                                (context, value, child) =>
                                                    CircularProgressIndicator(
                                                      value: value,
                                                      strokeWidth: 10,
                                                      strokeCap: StrokeCap.round,
                                                      valueColor: AlwaysStoppedAnimation(
                                                        Colors.white,
                                                      ),
                                                      backgroundColor: Colors.white.withValues(
                                                        alpha: 0.5,
                                                      ),
                                                    ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Animate().custom(
                                            duration: Duration(milliseconds: 800),
                                            begin: 0,
                                            end: quizState.completion / 100,
                                            curve: Curves.easeInOut,
                                            builder:
                                                (context, value, child) => RichText(
                                                  text: TextSpan(
                                                    text: "${(value * 10).toInt()}",
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: "/${quizState.answers.length}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 24),
                                  Expanded(
                                    child: Text(
                                      "You answered ${quizState.correctAnswers} out of 10 questions",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Your Answers",
                    style: context.textTheme.titleLarge!.copyWith(fontFamily: FontFamily.w500),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      color: Color(0xffEFEEFC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Wrap(
                      runSpacing: 28,
                      children: List.generate(quizState.answers.length, (index) {
                        final question = quizState.answers[index];
                        final attempt = quizState.answers[index];
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: switch ((
                                      attempt.isCorrectAnswer,
                                      attempt.isIncorrectAnswer,
                                      attempt.isSkipped,
                                    )) {
                                      (true, false, false) => Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      (false, true, false) => Icon(Icons.close, color: Colors.red),
                                      (false, false, true) => Icon(
                                        Icons.skip_next,
                                        color: Colors.grey,
                                      ),
                                      _ => Container(),
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Builder(
                                    builder: (context) {
                                      final HtmlUnescape unescape = HtmlUnescape();
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            unescape.convert(question.question),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            unescape.convert(attempt.correctAnswer),
                                            style: TextStyle(color: Color(0xff858494)),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
