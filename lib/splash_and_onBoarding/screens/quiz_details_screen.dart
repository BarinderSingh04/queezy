import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/splash_and_onBoarding/cubit/queezy_list_cubit.dart';
import 'package:queezy/routes/routes.dart';

class QuizDetailsScreen extends StatefulWidget {
  const QuizDetailsScreen({super.key, this.selectedCategory});
  final Map<String, dynamic>? selectedCategory;

  @override
  State<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  String? selectedDifficulity;

  @override
  Widget build(BuildContext context) {
    print(widget.selectedCategory);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Image.asset(
              "assets/images/Illustration.png",
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: context.colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.selectedCategory?['category'] ?? '',
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
                            Container(
                              height: 40,
                              width: 2,
                              color: Colors.grey.shade300,
                            ),
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
                              "10 questions",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontFamily: FontFamily.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Description",
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: context.colorScheme.onSecondary,
                        fontFamily: FontFamily.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Any time is a good time for a quiz and even better if that happens to be a football themed quiz!",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontFamily: FontFamily.w400,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedDifficulity == 'easy'
                                    ? context.colorScheme.secondary
                                    : context.colorScheme.tertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedDifficulity = "easy";
                            });
                          },
                          child: Text(
                            "Easy",
                            style: context.textTheme.bodyMedium!.copyWith(
                              color:
                                  selectedDifficulity == 'easy'
                                      ? context.colorScheme.onPrimary
                                      : context.colorScheme.primary,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedDifficulity == 'medium'
                                    ? context.colorScheme.secondary
                                    : context.colorScheme.tertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedDifficulity = "medium";
                            });
                          },
                          child: Text(
                            "Medium",
                            style: context.textTheme.bodyMedium!.copyWith(
                              color:
                                  selectedDifficulity == 'medium'
                                      ? context.colorScheme.onPrimary
                                      : context.colorScheme.primary,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedDifficulity == 'hard'
                                    ? context.colorScheme.secondary
                                    : context.colorScheme.tertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedDifficulity = "hard";
                            });
                          },
                          child: Text(
                            "Hard",
                            style: context.textTheme.bodyMedium!.copyWith(
                              color:
                                  selectedDifficulity == 'hard'
                                      ? context.colorScheme.onPrimary
                                      : context.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) {
                            return Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(140, 50),
                                  backgroundColor:
                                      context.colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: context.colorScheme.onSecondary,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<QueezyListCubit>().getquestion(
                                    difficulity: selectedDifficulity ?? 'easy',
                                    category:
                                        widget.selectedCategory?["id"]
                                            .toString(),
                                  );
                                  Navigator.pushNamed(
                                    context,
                                    NavRoute.quizScreen.path,
                                    arguments: selectedDifficulity,
                                  );
                                },
                                child: Text(
                                  "Play Solo",
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: context.colorScheme.secondary,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(140, 50),
                              backgroundColor: context.colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: context.colorScheme.onSecondary,
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Play with Friends",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: context.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
