import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/di/service_locator.dart';
import 'package:queezy/model/result.dart';

import '../cubit/leaderboard_cubit.dart';
import '../models/room_model.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LeaderBoardCubit>()..fetch(),
      child: Builder(
        builder: (context) {
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
              child: BlocBuilder<LeaderBoardCubit, Result<List<LeaderBoardModel>>>(
                builder: (context, state) {
                  return state.when(
                    onData: (data) {
                      return Column(
                        children: [
                          Image.asset("assets/images/Slice 1.png"),
                          Expanded(
                            child: Container(
                              color: Color(0xffEFEEFC),
                              child: ListView.separated(
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                                itemCount: data!.length,
                                itemBuilder: (context, index) {
                                  return PlayerCard(index: index, leaderBoardModel: data[index]);
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(height: 10);
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    onLoading: () {
                      return Center(child: CircularProgressIndicator());
                    },
                    onError: (e) {
                      return Center(child: Text(e.toString()));
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  final LeaderBoardModel leaderBoardModel;
  const PlayerCard({super.key, this.index, required this.leaderBoardModel});
  final int? index;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.colorScheme.onPrimary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffE6E6E6)),
                shape: BoxShape.circle,
              ),
              child: Text(
                "${index! + 1}",
                style: context.textTheme.bodySmall!.copyWith(
                  color: Color(0xff858494),
                  fontFamily: FontFamily.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox.square(dimension: 50, child: Image.network(leaderBoardModel.avatarUrl)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 4,
                children: [
                  Text(
                    leaderBoardModel.name ?? "",
                    style: context.textTheme.bodyLarge!.copyWith(fontFamily: FontFamily.w500),
                  ),
                  Text(
                    "${leaderBoardModel.totalScore!.toInt() * 10} points",
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
