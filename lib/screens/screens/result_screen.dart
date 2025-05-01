import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/cubit/player_scores_cubit.dart';
import 'package:queezy/screens/cubit/quiz_logic_cubit.dart';
import 'package:queezy/screens/models/player_score.dart';
import 'package:queezy/screens/widget/animateion_widget.dart';

import '../../di/service_locator.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, this.session_id});
  final int? session_id;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<FlSpot> getAccuracySpots(PlayerScore? result) {
    final totalQuestions = result?.total?.toInt() ?? 0;
    final correctCount = int.tryParse(result?.correct ?? "0") ?? 0;
    final incorrectCount = int.tryParse(result?.incorrect ?? "0") ?? 0;
    // final skippedCount = int.tryParse(result?.skipped ?? "0") ?? 0;

    final List<FlSpot> spots = [];

    for (int i = 0; i < totalQuestions; i++) {
      double y;

      if (i < correctCount) {
        y = 1.0; // Correct
      } else if (i < correctCount + incorrectCount) {
        y = 0.5; // Incorrect
      } else {
        y = 0.0; // Skipped
      }

      spots.add(FlSpot(i + 1.0, y));
    }

    return spots;
  }

  @override
  void dispose() {
    print("Disposing QuizLogicCubit");
    getIt.resetLazySingleton<QuizLogicCubit>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value:  getIt<PlayerScoresCubit>()..getScore(widget.session_id),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: context.colorScheme.onPrimary,
              automaticallyImplyLeading: false,
            ),
            body: Container(
              color: context.colorScheme.onPrimary,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: BlocBuilder<PlayerScoresCubit, Result<PlayerScore>>(
                  builder: (context, result) {
                    final score = result.data;
                    if (result.data == null) {
                      return Center(
                        child: Text(
                          "Getting null data",
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: context.colorScheme.onPrimary,
                          ),
                        ),
                      );
                    }
                    if (result.error != null) {
                      return Center(
                        child: Text(
                          result.error.toString(),
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: context.colorScheme.onPrimary,
                          ),
                        ),
                      );
                    }
                    return Column(
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
                                  AnimatedPoints(
                                    score: int.parse(score?.correct ?? "0") * 10,
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
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        NavRoute.reviewQuiz.path,
                                      );
                                    },
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
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            height: 60,
          
                            child: LineChart(
                              LineChartData(
                                minX: 1,
                                maxX: score?.total?.toDouble() ?? 10,
                                minY: 0,
                                maxY: 1,
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      reservedSize: 24,
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          meta.formattedValue,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: getAccuracySpots(score),
                                    isCurved: false,
                                    color: Colors.deepPurple,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromARGB(255, 184, 176, 241),
                                          Color.fromARGB(255, 237, 235, 249),
                                          Colors.white,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "CORRECT ANSWERE",
                                            style: context.textTheme.labelSmall!
                                                .copyWith(
                                                  color: Colors.grey,
                                                  fontFamily: FontFamily.w500,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              AnimatedScore(
                                                score: int.parse(
                                                  score?.correct ?? "0",
                                                ),
                                                style: context.textTheme.titleLarge!
                                                    .copyWith(
                                                      fontFamily: FontFamily.w500,
                                                    ),
                                              ),
                                              Text(
                                                ' ques',
                                                style: context.textTheme.titleLarge!
                                                    .copyWith(
                                                      fontFamily: FontFamily.w500,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "COMPLETION",
                                            style: context.textTheme.labelSmall!
                                                .copyWith(
                                                  color: Colors.grey,
                                                  fontFamily: FontFamily.w500,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              AnimatedScore(
                                                score:
                                                    score?.accuracy?.toInt() ?? 0,
                                                style: context.textTheme.titleLarge!
                                                    .copyWith(
                                                      fontFamily: FontFamily.w500,
                                                    ),
                                              ),
                                              Text(
                                                " %",
                                                style: context.textTheme.titleLarge!
                                                    .copyWith(
                                                      fontFamily: FontFamily.w500,
                                                    ),
                                              ),
                                            ],
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "SKIPPED",
                                            style: context.textTheme.labelSmall!
                                                .copyWith(
                                                  color: Colors.grey,
                                                  fontFamily: FontFamily.w500,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              AnimatedScore(
                                                score: int.parse(
                                                  score?.skipped ?? "0",
                                                ),
                                                style: context.textTheme.titleLarge!
                                                    .copyWith(
                                                      fontFamily: FontFamily.w500,
                                                    ),
                                              ),
                                              Text(
                                                " ques ",
                                                style: context.textTheme.titleLarge!
                                                    .copyWith(
                                                      fontFamily: FontFamily.w500,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "INCORRECT ANSWERE",
                                            style: context.textTheme.labelSmall!
                                                .copyWith(
                                                  color: Colors.grey,
                                                  fontFamily: FontFamily.w500,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              AnimatedScore(
                                                score: int.parse(
                                                  score?.incorrect ?? "0",
                                                ),
                                                style: context.textTheme.titleLarge!
                                                    .copyWith(
                                                      fontFamily: FontFamily.w500,
                                                    ),
                                              ),
                                              Text(
                                                ' ques',
                                                style: context.textTheme.titleLarge!
                                                    .copyWith(
                                                      fontFamily: FontFamily.w500,
                                                    ),
                                              ),
                                            ],
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
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    NavRoute.chooseCategory.path,
                                    (route) => true,
                                  );
                                },
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
                    );
                  },
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
