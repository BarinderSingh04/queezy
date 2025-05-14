import 'package:expandable/expandable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/cubit/player_scores_cubit.dart';
import 'package:queezy/screens/models/player_score.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, this.session_id});
  final int? session_id;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final List<Map<String, dynamic>> playerMedals = [
    {"medal": "assets/images/gold_badge.png", "bg": "assets/images/w_base.png"},
    {"medal": "assets/images/silver_badge.png", "bg": "assets/images/s_base.png"},
    {"medal": "assets/images/bronze_badge.png", "bg": "assets/images/b_base.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFEEFC),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top,
            bottom: MediaQuery.paddingOf(context).bottom,
          ),
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
                    const SizedBox(height: 20),
                    Wrap(
                      runSpacing: 16,
                      children: List.generate(score!.length, (index) {
                        return PlayerCard(
                          index: index,
                          sessionId: widget.session_id,
                          leaderBoardModel: score[index],
                          playerMedals: playerMedals,
                        );
                      }),
                    ),
                    const SizedBox(height: 30),
                    AspectRatio(aspectRatio: 1.1, child: ChartDetail(scores: score)),
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
                            child: Icon(Icons.share_outlined, color: context.colorScheme.secondary),
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
  }
}

class ChartDetail extends StatelessWidget {
  final List<PlayerScore> scores;

  const ChartDetail({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 16),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Performance by player",
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: FontFamily.w700,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(right: 16),
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
                      reservedSize: 55,
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
          ),
        ],
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
            color: [Color(0xffFFD6DD), Color(0xffC4D0FB)][index],
            width: 40,
          ),
        ],
      );
    });
  }
}

class PlayerCard extends StatelessWidget {
  final int index;
  final int? sessionId;
  final PlayerScore leaderBoardModel;
  final List<Map<String, dynamic>> playerMedals;
  const PlayerCard({
    super.key,
    required this.index,
    required this.leaderBoardModel,
    required this.playerMedals,
    this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Expandable(
        collapsed: ExpandableButton(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: context.colorScheme.secondary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffE6E6E6)),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: context.textTheme.bodySmall!.copyWith(
                          color: Colors.white,
                          fontFamily: FontFamily.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox.square(dimension: 50, child: Image.network(leaderBoardModel.path)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 4,
                      children: [
                        Text(
                          leaderBoardModel.name ?? "",
                          style: context.textTheme.bodyLarge!.copyWith(
                            fontFamily: FontFamily.w500,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${leaderBoardModel.correct!.toInt() * 10} points",
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontFamily: FontFamily.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  index < 2 ? Image.asset(playerMedals[index]["medal"]) : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
        expanded: ExpandableButton(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: context.colorScheme.secondary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffE6E6E6)),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: context.textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontFamily: FontFamily.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox.square(dimension: 50, child: Image.network(leaderBoardModel.path)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 4,
                          children: [
                            Text(
                              leaderBoardModel.name ?? "",
                              style: context.textTheme.bodyLarge!.copyWith(
                                fontFamily: FontFamily.w500,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${leaderBoardModel.correct!.toInt() * 10} points",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontFamily: FontFamily.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      index < 2 ? Image.asset(playerMedals[index]["medal"]) : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    NavRoute.reviewQuiz.name,
                    pathParameters: {
                      "sessionId": sessionId.toString(),
                      "playerId": leaderBoardModel.playerId.toString(),
                    },
                  );
                },
                child: AspectRatio(
                  aspectRatio: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.secondary,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: IntrinsicHeight(
                      child: Container(
                        margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xff9087E5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "CORRECT",
                                  style: context.textTheme.titleMedium!.copyWith(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  leaderBoardModel.correct.toString(),
                                  style: context.textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: VerticalDivider(color: Colors.white38),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                              children: [
                                Text(
                                  "INCORRECT",
                                  style: context.textTheme.titleMedium!.copyWith(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  leaderBoardModel.incorrect.toString(),
                                  style: context.textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: VerticalDivider(color: Colors.white38),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                              children: [
                                Text(
                                  "SKIPPED",
                                  style: context.textTheme.titleMedium!.copyWith(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  leaderBoardModel.skipped.toString(),
                                  style: context.textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
