import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/cubit/quiz_logic_cubit.dart';
import 'package:queezy/screens/models/quiz_result.dart';
import 'package:queezy/screens/widget/animateion_widget.dart';

import '../../di/service_locator.dart';

class ReviewQuizScreen extends StatefulWidget {
  const ReviewQuizScreen({super.key});

  @override
  State<ReviewQuizScreen> createState() => _ReviewQuizScreenState();
}

class _ReviewQuizScreenState extends State<ReviewQuizScreen> {
  var unescape = HtmlUnescape();
  
  @override
  void dispose() {
    getIt.resetLazySingleton<QuizLogicCubit>();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<QuizLogicCubit, QuizResult>(
        builder: (context, result) {
          return SingleChildScrollView(
            child: Container(
              color: context.colorScheme.onPrimary,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                "Review Answere!",
                                style: context.textTheme.headlineSmall!
                                    .copyWith(fontFamily: FontFamily.w500),
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
                        width: MediaQuery.sizeOf(context).width,
                        height: 248,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: context.colorScheme.secondary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${result.category}",
                                          style: context.textTheme.bodyMedium!
                                              .copyWith(
                                                color: Colors.grey.shade400,
                                                fontFamily: FontFamily.w500,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "English Premier League Quiz",
                                          style: context.textTheme.bodyLarge!
                                              .copyWith(
                                                color:
                                                    context
                                                        .colorScheme
                                                        .onPrimary,
                                                fontFamily: FontFamily.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white30,
                                      ),
                                      child: Icon(
                                        Icons.extension_outlined,
                                        color: context.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  color: context.colorScheme.onTertiary,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center, // Centers the children in the Row
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .center, // Ensures vertical alignment
                                    children: [
                                      Stack(
                                        alignment:
                                            Alignment
                                                .center, // Aligns all Stack children at the center
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: AnimatedCircularProgress(
                                              value: result.correctAnswere / 10,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              AnimatedScore(
                                                score: result.correctAnswere,
                                                style: context
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                      color:
                                                          context
                                                              .colorScheme
                                                              .onPrimary,
                                                      fontFamily:
                                                          FontFamily.w500,
                                                    ),
                                              ),
                                              Text(
                                                '/ ${result.answere.length}',
                                                style: context
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                      color:
                                                          context
                                                              .colorScheme
                                                              .onPrimary,
                                                      fontFamily:
                                                          FontFamily.w500,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ), // Adds spacing between the Stack and the text
                                      Expanded(
                                        child: Text(
                                          "You answered ${result.correctAnswere} out of ${result.answere.length} questions correctly",
                                          maxLines: 2,
                                          overflow:
                                              TextOverflow
                                                  .ellipsis, // Ensures the text doesn't overflow
                                          textAlign:
                                              TextAlign
                                                  .left, // Aligns the text to the start
                                          style: context.textTheme.bodyLarge!
                                              .copyWith(
                                                color:
                                                    context
                                                        .colorScheme
                                                        .onPrimary,
                                                fontFamily: FontFamily.w500,
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
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Your Answere",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontFamily: FontFamily.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffEFEEFC),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        child: Wrap(
                          runSpacing: 20,
                          children: List.generate(
                            result.answere.length,
                            growable: true,
                            (int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: context.colorScheme.onPrimary,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          result.answere[index].isCorrect
                                              ? Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              )
                                              : result
                                                  .answere[index]
                                                  .isIncorrect
                                              ? Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              )
                                              : result.answere[index].isSkipped
                                              ? Icon(
                                                Icons.skip_next_sharp,
                                                color: Colors.grey,
                                              )
                                              : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          unescape.convert(
                                            result.answere[index].question ??
                                                '',
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          unescape.convert(
                                            result
                                                    .answere[index]
                                                    .correctAnswer ??
                                                '',
                                          ),
                                          style: context.textTheme.bodyMedium!
                                              .copyWith(
                                                color: Colors.grey.shade500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(children: [
                        
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedCircularProgress extends StatefulWidget {
  final double value; // from 0.0 to 1.0

  const AnimatedCircularProgress({Key? key, required this.value})
    : super(key: key);

  @override
  _AnimatedCircularProgressState createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double oldValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }


  @override
  void didUpdateWidget(covariant AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: oldWidget.value,
        end: widget.value,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CircularProgressIndicator(
          backgroundColor: Colors.white24,
          color: Theme.of(context).colorScheme.onPrimary,
          strokeWidth: 12,
          strokeCap: StrokeCap.round,
          value: _animation.value,
        );
      },
    );
  }
}
