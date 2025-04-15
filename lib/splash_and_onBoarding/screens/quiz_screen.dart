import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/splash_and_onBoarding/cubit/queezy_list_cubit.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/splash_and_onBoarding/models/queezy_model.dart';
import 'package:queezy/splash_and_onBoarding/models/quiz_result.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({super.key, this.selectedDifficulity});
  final String? selectedDifficulity;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final int totalQuestions = 10;

  int currentQuestion = 1;
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
                        Text(
                          '1',
                          style: TextStyle(
                            color: context.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (currentQuestion) / totalQuestions,
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
            ),
            MCQQuesWidget(difficulity: widget.selectedDifficulity),
          ],
        ),
      ),
    );
  }
}

class MCQQuesWidget extends StatefulWidget {
  const MCQQuesWidget({super.key, required this.difficulity});
  final String? difficulity;

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
  final _controller = CountDownController();

  bool isAnswered = false;
  List<Map<String, dynamic>> answers = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueezyListCubit, Result<List<QueezyModel>>>(
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

        final questions = state.data ?? [];

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
                difficulity: widget.difficulity ?? "",
                onTap: (String option) {
                  setState(() {
                    selected = option;
                    isAnswered = true;

                    if (selected == question.correctAnswer) {
                      Future.delayed(Duration(milliseconds: 500), () {
                        if (currentPage < questions.length - 1) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                          _controller.restart(initialPosition: 10);
                        }
                        selected = null;
                        isAnswered = false;
                      });
                    } else {
                      setState(() {
                        incorrect++;
                      });
                      Future.delayed(Duration(milliseconds: 500), () {
                        if (currentPage < questions.length - 1) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                          // _controller.restart(initialPosition: 10);
                        } else {
                          final score = questions.length - incorrect;
                          if (skipped == 0 &&
                              (score + incorrect) == questions.length) {
                            completion = (score / questions.length) * 100;
                          }
                          Navigator.pushNamed(
                            context,
                            NavRoute.resultScreen.path,
                            arguments: QuizResult(
                              correct: score,
                              skipped: skipped,
                              incorrect: incorrect,
                              completion: completion,
                            ),
                          );
                        }
                        selected = null;
                        isAnswered = false;
                      });
                    }
                  });
                },
                onComplete: () {
                  final userAnswere = selected;
                  if (userAnswere == null) {
                    setState(() {
                      skipped++;
                    });
                  }
                  if (currentPage < questions.length - 1) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                    _controller.restart(initialPosition: 10);
                  }
                  setState(() {
                    selected = null;
                    isAnswered = false;
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
    required this.difficulity,
    required this.questionNumber,
  });

  final VoidCallback onComplete;
  final Function(String option)? onTap;
  final int totalQuestions;
  final QueezyModel question;
  final String difficulity;
  final int questionNumber;
  final String? selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            difficulity,
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.onSecondary,
              fontFamily: FontFamily.w500,
            ),
          ),
          Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CountDownProgressIndicator(
                strokeWidth: 50,
                valueColor: Colors.pink.shade100,
                backgroundColor: Colors.transparent,
                initialPosition: 0,
                duration: 10,
                onComplete: onComplete,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Question $questionNumber of $totalQuestions',
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.onSecondary,
              fontFamily: FontFamily.w500,
            ),
          ),
          SizedBox(height: 10),

          Text(question.question ?? '', style: context.textTheme.titleLarge),
          SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: question.randomOptions.length,
              itemBuilder: (BuildContext context, int optionIndex) {
                final optionText = question.randomOptions[optionIndex];
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
                      optionText,
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
                return const SizedBox(height: 10);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class TrueFalseWidget extends StatefulWidget {
//   const TrueFalseWidget({super.key});

//   @override
//   State<TrueFalseWidget> createState() => _TrueFalseWidgetState();
// }

// class _TrueFalseWidgetState extends State<TrueFalseWidget> {
//   final PageController _pageController = PageController();

//   final int totalQuestions = 2;

//   int currentQuestion = 1;

//   String? selected;

//   int skipped = 0;

//   final _controller = CountDownController();

//   bool isAnswered = false;

//   final List<Map<String, dynamic>> questions = [
//     {
//       'question': 'Theodorus of Samos is the person who invented keys??',
//       'options': ['True', 'False'],
//       'correct': "True",
//     },
//     {
//       'question': 'Are you human?',
//       'options': ['True', 'False'],
//       'correct': "True",
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: questions.length,
//         onPageChanged: (index) {},
//         itemBuilder: (context, index) {
//           final question = questions[index];
//           return Container(
//             margin: EdgeInsets.all(16),
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(28),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),

//                 Center(
//                   child: SizedBox(
//                     height: 100,
//                     width: 100,
//                     child: CountDownProgressIndicator(
//                       controller: _controller,
//                       strokeWidth: 50,
//                       valueColor: Colors.pink.shade100,
//                       backgroundColor: Colors.transparent,
//                       initialPosition: 0,
//                       duration: 10,
//                       onComplete: () {
//                         if (selected != question["correct"]) {
//                           setState(() {
//                             skipped++;
//                             selected = null;
//                             isAnswered = false;

//                             if (_pageController.page!.round() <
//                                 totalQuestions - 1) {
//                               _pageController.nextPage(
//                                 duration: Duration(milliseconds: 300),
//                                 curve: Curves.easeIn,
//                               );
//                               _controller.restart(initialPosition: 10);
//                             } else {
//                               final score = totalQuestions - skipped;
//                               Navigator.pushNamed(
//                                 context,
//                                 NavRoute.resultScreen.path,
//                                 arguments: score,
//                               );
//                             }
//                           });
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Question ${index + 1} of $totalQuestions',
//                   style: context.textTheme.bodyMedium!.copyWith(
//                     color: context.colorScheme.onSecondary,
//                     fontFamily: FontFamily.w500,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Center(
//                   child: Image.asset("assets/images/boolIllustration.png"),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   question["question"].toString(),
//                   style: context.textTheme.titleLarge,
//                 ),
//                 SizedBox(height: 24),
//                 Expanded(
//                   child: ListView.separated(
//                     itemCount: question["options"].length,
//                     itemBuilder: (BuildContext context, int optionIndex) {
//                       final optionText = question["options"][optionIndex];
//                       bool isCorrect = selected == question["correct"];
//                       bool isSelected = selected == optionText;

//                       return InkWell(
//                         onTap:
//                             selected == null
//                                 ? () {
//                                   setState(() {
//                                     selected = optionText;
//                                     isAnswered = true;

//                                     if (selected == question["correct"]) {
//                                       Future.delayed(
//                                         Duration(milliseconds: 500),
//                                         () {
//                                           if (_pageController.page!.round() <
//                                               totalQuestions - 1) {
//                                             _pageController.nextPage(
//                                               duration: Duration(
//                                                 milliseconds: 300,
//                                               ),
//                                               curve: Curves.easeIn,
//                                             );
//                                             _controller.restart(
//                                               initialPosition: 10,
//                                             );
//                                           }
//                                           selected = null;
//                                           isAnswered = false;
//                                         },
//                                       );
//                                     }
//                                   });
//                                 }
//                                 : null,

//                         child: Container(
//                           margin: EdgeInsets.symmetric(vertical: 8),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 14,
//                           ),
//                           decoration: BoxDecoration(
//                             color:
//                                 isSelected
//                                     ? (isCorrect ? Colors.green : Colors.red)
//                                     : Colors.white,

//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(color: Colors.grey.shade300),
//                           ),
//                           child: Text(
//                             optionText,
//                             style:
//                                 isSelected
//                                     ? context.textTheme.bodyLarge!.copyWith(
//                                       fontFamily: FontFamily.w500,
//                                     )
//                                     : context.textTheme.bodyLarge,
//                           ),
//                         ),
//                       );
//                     },
//                     separatorBuilder: (BuildContext context, int index) {
//                       return const SizedBox(height: 10);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
