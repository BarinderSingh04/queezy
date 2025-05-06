import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/screens/cubit/game_session_cubit.dart';

import '../../common/common.dart';
import '../../model/result.dart';
import '../../routes/routes.dart';
import '../models/queezy_model.dart';
import 'package:html_unescape/html_unescape.dart';

class QuizScreen extends StatefulWidget {
  final String difficulty;
  QuizScreen({super.key, required this.difficulty});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[400],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.white),
                        SizedBox(width: 4),
                        Text('1', style: TextStyle(color: context.colorScheme.onPrimary)),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: currentPage / 10,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),

                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.extension, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          '100',
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            MCQQuesWidget(
              difficulty: widget.difficulty,
              pageController: _pageController,
              onNextTap: (length) {
                if (currentPage < length! - 1) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  final sessionId = context.read<GameSessionCubit>().state.data?.sessionId;
                  if (sessionId != null) {
                    Navigator.pushNamed(context, NavRoute.resultScreen.path, arguments: sessionId);
                  }
                }
              },
              onPageChanged: (pageIndex) {
                setState(() {
                  currentPage = pageIndex;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MCQQuesWidget extends StatelessWidget {
  final String difficulty;
  final PageController pageController;
  final void Function(int)? onPageChanged;
  final void Function(int? length) onNextTap;

  MCQQuesWidget({
    super.key,
    required this.difficulty,
    required this.pageController,
    this.onPageChanged,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameSessionCubit, Result<GameSession>>(
      builder: (context, state) {
        if (state.isLoading) {
          return Expanded(
            child: Center(
              child: Text(
                "Loading....",
                style: context.textTheme.titleMedium!.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ),
          );
        }
        if (state.error != null) {
          return Text(state.error.toString());
        }

        final questions = state.data?.questions ?? [];
        if (questions.isEmpty) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/images/empty_state.png'),
                  Text(
                    "Looks like we are unable to find quiz related to your request. Please change the options and try again.",
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Back"),
                  ),
                ],
              ),
            ),
          ).animate().move(delay: 300.ms, duration: 250.ms, curve: Curves.easeInOut).fade();
        }

        return Expanded(
          child: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            itemCount: questions.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final question = questions[index];
              final totalQuestions = questions.length;

              return QuestionPage(
                questionNumber: index + 1,
                difficulity: difficulty,
                onTap: (String option) {
                  context.read<GameSessionCubit>().submitAnswer(
                    givenAnswer: option,
                    correctAnswer: question.correctAnswer!,
                    question: question.question!,
                  );
                  Future.delayed(Duration(seconds: 1), () {
                    onNextTap(questions.length);
                  });
                },
                onComplete: () {
                  context.read<GameSessionCubit>().submitAnswer(
                    givenAnswer: null,
                    question: question.question!,
                    correctAnswer: question.correctAnswer!,
                  );
                  onNextTap(questions.length);
                },
                totalQuestions: totalQuestions,
                question: question,
              );
            },
          ),
        ).animate().fade();
      },
    );
  }
}

class QuestionPage extends StatefulWidget {
  const QuestionPage({
    super.key,
    required this.totalQuestions,
    required this.question,
    required this.onComplete,
    required this.onTap,
    required this.difficulity,
    required this.questionNumber,
  });

  final VoidCallback onComplete;
  final Function(String option)? onTap;
  final int totalQuestions;
  final Questions question;
  final String difficulity;
  final int questionNumber;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> with SingleTickerProviderStateMixin {
  String? selected;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 10));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)..addListener(() {
      setState(() {});
    });
    _controller.forward();

    _controller.addListener(() {
      if (_controller.isCompleted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.difficulity,
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.onSecondary,
              fontFamily: FontFamily.w500,
            ),
          ),
          Center(
            child: SizedBox(
              height: 80,
              width: 80,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.pink.shade100),
                      value: _animation.value,
                      backgroundColor: Colors.grey.shade100,
                      strokeCap: StrokeCap.round,
                      strokeWidth: 14,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${(_animation.value * 10).round()}",
                      style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Question ${widget.questionNumber} of ${widget.totalQuestions}',
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.onSecondary,
              fontFamily: FontFamily.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            HtmlUnescape().convert(widget.question.question ?? ''),
            style: context.textTheme.titleLarge,
          ),
          SizedBox(height: 24),
          Expanded(
            child:
                Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: List.generate(widget.question.option!.length, (index) {
                    final optionText = widget.question.option![index];
                    bool isCorrect = selected == widget.question.correctAnswer;
                    bool isSelected = selected == optionText;

                    return InkWell(
                      onTap:
                          selected != null
                              ? null
                              : () {
                                widget.onTap!(optionText);
                                setState(() {
                                  selected = optionText;
                                });
                                _controller.stop();
                              },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? (isCorrect ? Colors.green : Colors.red) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          HtmlUnescape().convert(optionText),
                          style:
                              isSelected
                                  ? context.textTheme.bodyLarge!.copyWith(
                                    fontFamily: FontFamily.w500,
                                  )
                                  : context.textTheme.bodyLarge,
                        ),
                      ),
                    );
                  }),
                ).animate().move(delay: 250.ms, duration: 250.ms, curve: Curves.bounceInOut).fade(),
          ),
        ],
      ),
    );
  }
}
