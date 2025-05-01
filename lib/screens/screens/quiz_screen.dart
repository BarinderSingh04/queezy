import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/di/service_locator.dart';
import 'package:queezy/screens/cubit/queezy_list_cubit.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/cubit/quiz_logic_cubit.dart';
import 'package:queezy/screens/models/queezy_model.dart';
import 'package:queezy/screens/models/quiz_result.dart';
import 'package:queezy/screens/widget/fade_animation.dart';
import 'package:queezy/service/socket_service.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({super.key, this.quizDetails});
  final Map<String, dynamic>? quizDetails;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final int totalQuestions = 10;

  int currentQuestion = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopProgressRowWidget(
              totalQuestions: totalQuestions,
              
            ),
            MCQQuesWidget(category: widget.quizDetails?['category']["id"]),
          ],
        ),
      ),
    );
  }
}

class TopProgressRowWidget extends StatelessWidget {
  const TopProgressRowWidget({
    super.key,
    required this.totalQuestions,
   
  });

  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                Text(
                  "1",
                  style: TextStyle(color: context.colorScheme.onPrimary),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          BlocBuilder<QuizLogicCubit, QuizResult>(
            builder: (context, state) {
              return Expanded(
                child: LinearProgressIndicator(
                  value: (state.answere.length) / totalQuestions,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            },
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
                  '35',
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MCQQuesWidget extends StatefulWidget {
  const MCQQuesWidget({super.key, required this.category});
  final String? category;

  @override
  State<MCQQuesWidget> createState() => _MCQQuesWidgetState();
}

class _MCQQuesWidgetState extends State<MCQQuesWidget> {
  final PageController _pageController = PageController();

  int currentQuestion = 1;
  int currentPage = 0;

  String? selected;

  int skipped = 0;
  int incorrect = 0;
  double completion = 0;

  bool isAnswered = false;
  List<Map<String, dynamic>> answers = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueezyListCubit, Result<Queezy>>(
      builder: (context, state) {
        if (state.isLoading) {
          return Expanded(
            child: Center(
              child: FadingImage(imageUrl: 'assets/images/loading.png'),
            ),
          );
        }
        if (state.error != null) {
          return Text(state.error.toString());
        }

        final questions = state.data?.questions ?? [];

        return Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: questions.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final question = questions[index];
              final totalQuestions = questions.length;

              return QuestionPage(
                questionNumber: index + 1,
                onTap: (String option) {
                  setState(() {
                    selected = option;
                  });
                  context.read<QuizLogicCubit>().getResult(
                    index: currentPage,
                    correctAnswer: question.correctAnswer,
                    answereGiven: selected,
                    question: question.question,
                    category: widget.category,
                  );
                  getIt<SocketService>().emit("submit_answer", {
                    "sessionId": state.data?.sessionId,
                    "question": question.question,
                    "answer": selected,
                    "correctAnswer": question.correctAnswer,
                    "playerId": 27,
                  });
                  Future.delayed(Duration(milliseconds: 500), () {
                    if (currentPage < questions.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    } else {
                      Navigator.pushNamed(
                        context,
                        NavRoute.resultScreen.path,
                        arguments: state.data?.sessionId,
                      );
                    }
                    selected = null;
                    isAnswered = false;
                  });
                },

                onComplete: () {
                  final userAnswer = selected;
                  context.read<QuizLogicCubit>().getResult(
                    index: currentPage,
                    correctAnswer: question.correctAnswer,
                    answereGiven: userAnswer,
                    question: question.question,
                    category: widget.category,
                  );
                  getIt<SocketService>().emit("submit_answer", {
                    "sessionId": state.data?.sessionId,
                    "question": question.question,
                    "answer": userAnswer,
                    "correctAnswer": question.correctAnswer,
                    "playerId": 27,
                  });
                  if (currentPage < questions.length - 1) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      NavRoute.resultScreen.path,
                      arguments: state.data?.sessionId,
                    );
                  }
                  setState(() {
                    selected = null;
                  });
                },
                totalQuestions: totalQuestions,
                question: question,
                selected: selected,
              );
            },
          ),
        );
      },
    );
  }
}

class QuestionPage extends StatelessWidget {
  const QuestionPage({
    super.key,
    required this.totalQuestions,
    required this.question,
    required this.selected,
    required this.onComplete,
    required this.onTap,
    required this.questionNumber,
  });

  final VoidCallback onComplete;
  final Function(String option)? onTap;
  final int totalQuestions;
  final Questions question;
  final int questionNumber;
  final String? selected;

  @override
  Widget build(BuildContext context) {
    var unescape = HtmlUnescape();
    final option = question.option ?? [];
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            question.difficulty ?? "",
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.onSecondary,
              fontFamily: FontFamily.w500,
            ),
          ),
          Center(
            child: SizedBox(
              height: 80,
              width: 80,
              child: CountDownProgressIndicator(
                strokeWidth: 10,
                valueColor: Colors.pink.shade100,
                backgroundColor: Colors.transparent,
                initialPosition: 0,
                duration: 10,
                onComplete: onComplete,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Question $questionNumber of $totalQuestions',
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.onSecondary,
              fontFamily: FontFamily.w500,
            ),
          ),
          SizedBox(height: 4),

          Text(
            unescape.convert(question.question ?? ''),
            style: context.textTheme.titleLarge,
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: option.length,
              itemBuilder: (BuildContext context, int optionIndex) {
                final String optionText = question.option?[optionIndex] ?? '';
                bool isCorrect = selected == question.correctAnswer;
                bool isSelected = selected == optionText;

                return InkWell(
                  onTap: () {
                    onTap!(optionText);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? (isCorrect ? Colors.green : Colors.red)
                              : Colors.white,

                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      unescape.convert(optionText),
                      style:
                          isSelected
                              ? context.textTheme.bodyLarge!.copyWith(
                                fontFamily: FontFamily.w500,
                              )
                              : context.textTheme.bodyLarge,
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 4);
              },
            ),
          ),
        ],
      ),
    );
  }
}
