import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:queezy/common/common.dart';

Widget buildBadgeTab() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _badgeItem("assets/images/badge3.png"),
        _badgeItem("assets/images/badge2.png"),
        _badgeItem("assets/images/badge4.png"),
        _badgeItem("assets/images/badge5.png"),
        _badgeItem("assets/images/badge6.png"),
        _badgeItem("assets/images/badge1.png"),
      ],
    ),
  );
}

Widget _badgeItem(String image) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
    child: Center(child: Image.asset(image)),
  );
}

class StatsWidget extends StatefulWidget {
  final ScrollController? scrollController;
  StatsWidget({super.key, this.scrollController});

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          QuizPlayedWidget(),
          SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: context.colorScheme.secondary,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Top performance by category",
                          style: context.textTheme.titleLarge!.copyWith(
                            fontFamily: FontFamily.w500,
                            color: context.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      Image.asset("assets/images/bar_graph_icon.png"),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        child: Row(
                          spacing: 10,

                          children: [
                            Icon(Icons.circle, color: Color(0xffFFD6DD), size: 10),
                            Text(
                              "Math",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontFamily: FontFamily.w500,
                                color: context.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(Icons.circle, color: Color(0xffC4D0FB), size: 10),
                            Text(
                              "Sports",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontFamily: FontFamily.w500,
                                color: context.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(Icons.circle, color: Color(0xffA9ADF3), size: 10),
                            Text(
                              "Music",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontFamily: FontFamily.w500,
                                color: context.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          horizontalInterval: 1.5,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white38,
                              strokeWidth: 1,
                              dashArray: [10, 10, 10, 10],
                            );
                          },
                        ),

                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,

                              getTitlesWidget: (value, meta) {
                                String text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = '0%';
                                    break;
                                  case 2:
                                    text = '20%';
                                    break;
                                  case 5:
                                    text = '50%';
                                    break;
                                  case 7:
                                    text = '70%';
                                    break;
                                  case 10:
                                    text = '100%';
                                    break;
                                  default:
                                    return const SizedBox.shrink();
                                }

                                return Text(
                                  text,
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              getTitlesWidget: (value, _) {
                                String title;
                                switch (value.toInt()) {
                                  case 0:
                                    title = "3/10";
                                    break;
                                  case 1:
                                    title = "8/10";
                                    break;
                                  case 2:
                                    title = "6/10";
                                    break;
                                  default:
                                    return const SizedBox.shrink();
                                }

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Questions",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      "Answered",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: 3,
                                width: 36,
                                color: Color(0xffFFD6DD),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: 8,
                                width: 36,
                                color: Color(0xffC4D0FB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: 6,
                                width: 36,
                                color: Color(0xffA9ADF3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class QuizPlayedWidget extends StatelessWidget {
  QuizPlayedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage("assets/images/stats_bg.png"), fit: BoxFit.cover),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(height: 34, width: 92, child: TimeSpanDropDown()),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "You have played a total ",
                  style: context.textTheme.titleLarge!.copyWith(fontFamily: FontFamily.w500),
                  children: [
                    TextSpan(
                      text: "24 quizzes ",
                      style: context.textTheme.titleLarge!.copyWith(
                        fontFamily: FontFamily.w500,
                        color: context.colorScheme.secondary,
                      ),
                    ),
                    TextSpan(
                      text: "this month",
                      style: context.textTheme.titleLarge!.copyWith(fontFamily: FontFamily.w500),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 145,
                  width: 145,
                  child: CircularProgressIndicator(
                    value: 37 / 50,
                    backgroundColor: context.colorScheme.onPrimary,
                    color: context.colorScheme.secondary,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "37",
                    style: context.textTheme.headlineMedium!.copyWith(fontFamily: FontFamily.w700),
                    children: [
                      TextSpan(
                        text: " /50\nquiz played",
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontFamily: FontFamily.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: context.colorScheme.onPrimary,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "5",
                                style: context.textTheme.headlineMedium!.copyWith(
                                  fontFamily: FontFamily.w700,
                                ),
                              ),
                              Icon(Icons.edit_outlined),
                            ],
                          ),
                          Text(
                            "Quiz Created",
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontFamily: FontFamily.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: context.colorScheme.secondary,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "21",
                                style: context.textTheme.headlineMedium!.copyWith(
                                  fontFamily: FontFamily.w700,
                                  color: context.colorScheme.onPrimary,
                                ),
                              ),
                              Image.asset("assets/images/won_match_icon.png"),
                            ],
                          ),
                          Text(
                            "Quiz Created",
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontFamily: FontFamily.w400,
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSpanDropDown extends StatefulWidget {
  @override
  _TimeSpanDropDownState createState() => _TimeSpanDropDownState();
}

class _TimeSpanDropDownState extends State<TimeSpanDropDown> {
  String? selectedValue;
  final List<String> items = ['Monthly', 'Weekly', 'Yearly'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.colorScheme.onPrimary,
      ),
      child: Center(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Text(items[0]),
          icon: Icon(Icons.arrow_drop_down, color: context.colorScheme.secondary),
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: SizedBox(),
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue;
            });
          },
          items:
              items.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
        ),
      ),
    );
  }
}
