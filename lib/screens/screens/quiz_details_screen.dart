import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/cubit/game_session_cubit.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/cubit/quiz_room_cubit.dart';
import 'package:queezy/screens/models/category_model.dart';
import 'package:queezy/screens/models/queezy_model.dart';
import 'package:queezy/screens/models/room_model.dart';

class QuizDetailsScreen extends StatefulWidget {
  const QuizDetailsScreen({super.key, required this.quizDetails});
  final RoomModel quizDetails;

  @override
  State<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  String? selectedDifficulity;
  RoomModel? roomModel;
  List<Player> players = [];
  late Map<String, dynamic> category;
  Timer? timer;
  int time = 3;

  @override
  void initState() {
    roomModel = widget.quizDetails;
    category = content.firstWhere((element) => element['id'] == roomModel!.categoryId);
    context.read<QuizRoomBloc>().add(JoinRoomEvent(roomModel!.code!, roomModel!.player!.playerId!));
    context.read<QuizRoomBloc>().add(UpdateRoomEvent(roomModel!));
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time <= 0) {
        timer.cancel();
        time = 3;
        Navigator.of(context).pushNamed(NavRoute.quizScreen.path, arguments: roomModel?.difficulty);
      } else {
        setState(() {
          time = time - 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  NavRoute.inviteFriend.path,
                  arguments: roomModel!.code,
                );
              },
              child: Icon(Icons.share_outlined, color: context.colorScheme.onPrimary),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Image.asset("assets/images/Illustration.png", fit: BoxFit.contain),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: context.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: BlocListener<GameSessionCubit, Result<GameSession>>(
                  listener: (context, state) {
                    if (state.data != null) {
                      startCountdown();
                    }
                    if (state.error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error.toString())));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['type'] ?? '',
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.onSecondary,
                            fontFamily: FontFamily.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Basic Trivia Quiz",
                          style: context.textTheme.headlineMedium!.copyWith(
                            fontFamily: FontFamily.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 55,
                                        height: 55,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Image.asset(
                                            roomModel?.type == "multiple"
                                                ? 'assets/images/multiple.png'
                                                : 'assets/images/boolean.png',
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        roomModel?.type?.capitalize() ?? "",
                                        style: context.textTheme.bodyMedium!.copyWith(
                                          fontSize: 15,
                                          fontFamily: FontFamily.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Container(height: 40, width: 2, color: Colors.grey.shade300),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 55,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Image.asset('assets/images/difficulty.png'),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        roomModel?.difficulty?.capitalize() ?? "",
                                        style: context.textTheme.bodyMedium!.copyWith(
                                          fontSize: 15,
                                          fontFamily: FontFamily.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Description",
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.onSecondary,
                            fontFamily: FontFamily.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          category['description'],
                          style: context.textTheme.bodyLarge!.copyWith(fontFamily: FontFamily.w400),
                        ),
                        const SizedBox(height: 18),
                        if (roomModel != null)
                          BlocConsumer<QuizRoomBloc, QuizRoomState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              if (state is QuizRoomUpdateState) {
                                final players = state.players;
                                return Expanded(
                                  child: ListView.separated(
                                    itemCount: players.length,
                                    itemBuilder: (context, index) {
                                      final player = players[index];
                                      return Row(
                                        children: [
                                          SizedBox.square(
                                            dimension: 45,
                                            child: Image.network(player.avatarUrl),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${player.name}",
                                                style: context.textTheme.bodyMedium!.copyWith(
                                                  fontFamily: FontFamily.w500,
                                                ),
                                              ),
                                              Text(
                                                player.isHost == true ? "Creator" : "Joiner",
                                                style: context.textTheme.bodySmall!.copyWith(
                                                  fontFamily: FontFamily.w400,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) {
                                      return const SizedBox(height: 10);
                                    },
                                  ),
                                );
                              }
                              return SizedBox();
                            },
                          ),
                        if (roomModel == null) Expanded(child: SizedBox()),
                        const SizedBox(height: 20),
                        if (roomModel is JoinRoomModel && roomModel!.player!.isHost == false)
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.info_outline_rounded, color: Colors.white),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  timer?.isActive == true
                                      ? "Game starts in ${time}"
                                      : "Only creator can start the game",
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    fontFamily: FontFamily.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Row(
                            spacing: 8,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
                                    backgroundColor: context.colorScheme.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: context.colorScheme.onSecondary),
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<GameSessionCubit>().create(
                                      roomcode: roomModel!.code,
                                    );
                                  },
                                  child: Text(
                                    "Play Solo",
                                    style: context.textTheme.bodyMedium!.copyWith(
                                      color: context.colorScheme.secondary,
                                      fontFamily: FontFamily.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
                                    backgroundColor: context.colorScheme.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: context.colorScheme.onSecondary),
                                    ),
                                  ),

                                  onPressed: () {
                                    context.read<GameSessionCubit>().create(
                                      roomcode: roomModel!.code,
                                    );
                                  },
                                  child: Text(
                                    timer?.isActive == true
                                        ? "Game starts in ${time}"
                                        : "Play with Friends",
                                    style: context.textTheme.bodyMedium!.copyWith(
                                      color: context.colorScheme.onPrimary,
                                      fontFamily: FontFamily.w500,
                                    ),
                                  ),
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
