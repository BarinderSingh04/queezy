import 'package:flutter/material.dart';
import 'package:queezy/common/common.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leaderboard",
          style: context.textTheme.headlineMedium!.copyWith(
            fontFamily: FontFamily.w500,
            color: context.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(children: []),
              Image.asset("assets/images/Slice 1.png"),
              Container(
                color: Color(0xffEFEEFC),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 700,
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return PlayerCard(index: index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10);
                      },
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

class PlayerCard extends StatelessWidget {
  const PlayerCard({super.key, this.index});
  final int? index;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.colorScheme.onPrimary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffE6E6E6)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                child: Text(
                  "1",
                  style: context.textTheme.bodySmall!.copyWith(
                    color: Color(0xff858494),
                    fontFamily: FontFamily.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Image.asset("assets/images/avatar12.png"),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    "Davis Cutris",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontFamily: FontFamily.w500,
                    ),
                  ),
                  Text(
                    "2,569 points",
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontFamily: FontFamily.w400,
                      color: Color(0xff858494),
                    ),
                  ),
                ],
              ),
            ),
            index == 0
                ? Image.asset("assets/images/gold_badge.png")
                : index == 1
                ? Image.asset("assets/images/silver_badge.png")
                : index == 2
                ? Image.asset("assets/images/bronze_badge.png")
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
