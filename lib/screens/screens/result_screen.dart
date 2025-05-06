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
  @override
  void dispose() {
    print("Disposing QuizLogicCubit");
    getIt.resetLazySingleton<QuizLogicCubit>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<PlayerScoresCubit>()..getScore(widget.session_id),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                color: context.colorScheme.onPrimary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: BlocBuilder<PlayerScoresCubit, Result<List<PlayerScore>>>(
                    builder: (context, result) {
                      final score = result.data;
                      if (result.isLoading) {
                        return Center(child: CircularProgressIndicator());
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
                                  // Navigator.of(context).pushNamedAndRemoveUntil(
                                  //   NavRoute.chooseCategory.path,
                                  //   (route) => true,
                                  // );
                                  context.read<PlayerScoresCubit>().getScore(widget.session_id);
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
                                padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 24),
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/award.png"),
                                    const SizedBox(height: 8),
                                    AnimatedPoints(
                                      score: int.parse(score?.first.correct ?? "0") * 10,
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
                                        Navigator.pushNamed(context, NavRoute.reviewQuiz.path);
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
                          Expanded(flex: 3, child: ChartDetail(scores: score ?? [])),
                          const SizedBox(height: 10),
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
                                  border: Border.all(color: context.colorScheme.onSecondary),
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
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChartDetail extends StatelessWidget {
  final List<PlayerScore> scores;

  const ChartDetail({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 20),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: BarChart(
        BarChartData(
          maxY: 10,
          minY: 0,
          baselineY: 5,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(tooltipPadding: const EdgeInsets.all(6.0)),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) => SizedBox.shrink(),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitles(context),
                reservedSize: 60,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2.5,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  final percentage = (value * 10).toInt();
                  return Text(
                    "$percentage%",
                    style: TextStyle(color: Colors.white, fontFamily: FontFamily.w700),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: 2.49,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: Colors.white30, strokeWidth: 1, dashArray: [6, 8]);
            },
          ),
        ),
      ),
    );
  }

  Widget Function(double, TitleMeta) bottomTitles(BuildContext context) {
    return (double value, TitleMeta meta) {
      final score = scores[value.toInt()];
      final Widget text = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "${score.correct}/${score.total} \n ",
          style: TextStyle(
            fontFamily: FontFamily.w500,
            color: context.colorScheme.onPrimary,
            fontSize: 15,
          ),
          children: [
            TextSpan(
              text: "${score.name?.split(" ")[0]}",
              style: TextStyle(
                color: context.colorScheme.onPrimary.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );

      return SideTitleWidget(
        space: 6, //margin top
        meta: meta,
        child: text,
      );
    };
  }

  List<BarChartGroupData> get barGroups {
    return List.generate(scores.length, (index) {
      return BarChartGroupData(
        barsSpace: 4,
        x: index,
        barRods: [
          BarChartRodData(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            toY: (scores[index].accuracy?.toDouble() ?? 0) / 10,
            color: Colors.accents[index].shade100,
            width: 40,
          ),
        ],
      );
    });
  }
}
