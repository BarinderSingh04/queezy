import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/di/service_locator.dart';
import 'package:queezy/routes/routes.dart';
import '../cubit/quiz_state_cubit.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<QuizStateCubit, QuizState>(
        builder: (context, state) {
          return Container(
            color: context.colorScheme.onPrimary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SafeArea(
                bottom: false,
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
                              (route) => false,
                            );
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                              Text(
                                "Yoy get +${state.points} Quiz Points",
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
                                  Navigator.pushNamed(context, NavRoute.reviewScreen.path);
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
                    const SizedBox(height: 34),
                    ChartGraph(),
                    const SizedBox(height: 24),
                    Expanded(
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
                                    AnimatedText(
                                      value: state.correctAnswers.toDouble(),
                                      text: " questions",
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
                                    AnimatedText(value: state.completion.toDouble(), text: " %"),
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
                                    AnimatedText(value: state.skipped.toDouble()),
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
                                    AnimatedText(value: state.incorrectAnswers.toDouble()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
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
                                (route) => false,
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
                            child: Icon(Icons.share_outlined, color: context.colorScheme.secondary),
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
        },
      ),
    );
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<QuizStateCubit>();
    super.dispose();
  }
}

class AnimatedText extends StatelessWidget {
  final double value;
  final String? text;
  const AnimatedText({super.key, required this.value, this.text});

  @override
  Widget build(BuildContext context) {
    return Animate().custom(
      duration: Duration(seconds: 1),
      begin: 0,
      end: value,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return RichText(
          text: TextSpan(
            text: "${value.toInt()}" + "${text ?? ""}",
            style: context.textTheme.titleLarge!.copyWith(fontFamily: FontFamily.w500),
          ),
        );
      },
    );
  }
}

class ChartGraph extends StatelessWidget {
  const ChartGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: AspectRatio(
        aspectRatio: 2.5,
        child: BlocBuilder<QuizStateCubit, QuizState>(
          builder: (context, state) {
            return LineChart(
              mainData(spots: state.chatData, onTapLabel: (value) => state.label(value)),
            );
          },
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    Widget child;
    final textValue = value.toInt().toString();
    child = Text(textValue, style: style);
    return SideTitleWidget(meta: meta, child: child);
  }

  LineChartData mainData({
    required List<FlSpot> spots,
    required String Function(double value) onTapLabel,
  }) {
    return LineChartData(
      backgroundColor: Colors.white,
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return LineTooltipItem(onTapLabel(touchedSpot.y), textStyle);
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: Colors.white, strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(color: Colors.white, strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(bottom: BorderSide(color: const Color(0xffEFEEFC))),
      ),
      minX: 1,
      maxX: 10,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: Color(0xff6A5AE0),
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff6A5AE0).withValues(alpha: 0.4),
                Color(0xff6A5AE0).withValues(alpha: 0.1),
                Color(0xff6A5AE0).withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
