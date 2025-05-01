import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/splash_and_onBoarding/cubit/create_quiz_cubit.dart';
import 'package:queezy/splash_and_onBoarding/models/create_quiz.dart';

class QuizDetailsScreen extends StatefulWidget {
  const QuizDetailsScreen({super.key});

  @override
  State<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  Map<String, dynamic> difficulty = {"easy": "Easy", "medium": "Medium", "hard": "Hard"};
  Map<String, dynamic> types = {"boolean": "True / False", "multiple": "Multiple Choice"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<CreateQuizCubit, CreateQuiz>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Image.asset("assets/images/Illustration.png", fit: BoxFit.contain),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.categoryName ?? "",
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.onSecondary,
                              fontFamily: FontFamily.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Basic Trivia Quiz",
                            style: context.textTheme.headlineMedium!.copyWith(
                              fontFamily: FontFamily.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: context.colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: context.colorScheme.secondary,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.question_mark,
                                        color: context.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "10 questions",
                                    style: context.textTheme.bodyMedium!.copyWith(
                                      fontFamily: FontFamily.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Container(height: 40, width: 2, color: Colors.grey.shade300),
                                  const SizedBox(width: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: context.colorScheme.onTertiary,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.extension_outlined,
                                        color: context.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "100 points",
                                    style: context.textTheme.bodyMedium!.copyWith(
                                      fontFamily: FontFamily.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Description",
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.onSecondary,
                              fontFamily: FontFamily.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.description ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontFamily: FontFamily.w400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Difficulty",
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.onSecondary,
                              fontFamily: FontFamily.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          DropdownButton<String>(
                            items:
                                difficulty.entries
                                    .map(
                                      (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                                    )
                                    .toList(),
                            value: state.difficulty,
                            hint: Text("Select quiz difficulty"),
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(10),
                            focusColor: context.colorScheme.secondary,
                            onChanged: (v) {
                              context.read<CreateQuizCubit>().update(
                                (up) => up.copyWith(difficulty: v),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Quiz Type",
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.onSecondary,
                              fontFamily: FontFamily.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          DropdownButton(
                            items:
                                types.entries
                                    .map(
                                      (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                                    )
                                    .toList(),
                            value: state.type,
                            hint: Text("Select quiz type"),
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(10),
                            focusColor: context.colorScheme.secondary,
                            onChanged: (v) {
                              context.read<CreateQuizCubit>().update((up) => up.copyWith(type: v));
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              minimumSize: Size.fromHeight(46),
                              backgroundColor: Color(0xff6A5AE0),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed:
                                state.difficulty == null || state.type == null
                                    ? null
                                    : () {
                                      Navigator.pushNamed(context, NavRoute.quizScreen.path);
                                    },
                            child: Text(
                              "Play Now",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
