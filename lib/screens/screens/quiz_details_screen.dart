import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../common/common.dart';
import '../../model/result.dart';
import '../cubit/game_session_cubit.dart';
import '../../routes/routes.dart';
import '../cubit/quiz_room_cubit.dart';
import '../models/category_model.dart';
import '../models/queezy_model.dart';
import '../models/room_model.dart';
import '../../widgets/buttons_widget.dart';

class QuizDetailsScreen extends StatefulWidget {
  const QuizDetailsScreen({super.key, required this.quizDetails});
  final RoomModel quizDetails;

  @override
  State<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  String? selectedDifficulity;
  late RoomModel roomModel;
  List<Player> players = [];
  late Map<String, dynamic> category;
  Timer? timer;
  int time = 3;

  @override
  void initState() {
    roomModel = widget.quizDetails;
    category = content.firstWhere((element) => element['id'] == roomModel.categoryId);
    context.read<QuizRoomBloc>().add(JoinRoomEvent(roomModel.code!, roomModel.player!.playerId!));
    context.read<QuizRoomBloc>().add(UpdateRoomEvent(roomModel));
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
        context.push(
          context.namedLocation(
            NavRoute.quizScreen.name,
            queryParameters: {"difficulty": widget.quizDetails.difficulty ?? ""},
          ),
        );
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
      backgroundColor: context.colorScheme.secondary,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            // final bool shouldPop = await _showBackDialog() ?? false;
            // if (shouldPop) {
            Navigator.of(context).pop();
            // }
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                GoRouter.of(context).pushNamed(
                  NavRoute.inviteFriend.name,
                  pathParameters: {"code": widget.quizDetails.code ?? ""},
                );
              },
              child: Icon(Icons.share_outlined, color: context.colorScheme.onPrimary),
            ),
          ),
        ],
      ),
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          // final bool shouldPop = await _showBackDialog() ?? false;
          // if (context.mounted && shouldPop) {
          //   Navigator.pop(context);
          // }
        },
        child: Column(
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
                            category['category'] ?? '',
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
                                              roomModel.type == "multiple"
                                                  ? 'assets/images/multiple.png'
                                                  : 'assets/images/boolean.png',
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          roomModel.type?.capitalize() ?? "",
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
                                          roomModel.difficulty?.capitalize() ?? "",
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
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontFamily: FontFamily.w400,
                            ),
                          ),
                          const SizedBox(height: 18),
                          BlocConsumer<QuizRoomBloc, QuizRoomState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              final players = state.players ?? [];
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
                            },
                          ),
                          const SizedBox(height: 20),
                          if (roomModel is JoinRoomModel && roomModel.player!.isHost == false)
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
                            BlocBuilder<QuizRoomBloc, QuizRoomState>(
                              builder: (context, roomState) {
                                return BlocBuilder<GameSessionCubit, Result<GameSession>>(
                                  builder: (context, state) {
                                    final players = roomState.players ?? [];
                                    return Row(
                                      spacing: 8,
                                      children: [
                                        if (players.length <= 1)
                                          Expanded(
                                            child: OutlineButton(
                                              isLoading: state.isLoading,
                                              title:
                                                  timer?.isActive == true
                                                      ? "Game starts in ${time}"
                                                      : "Play Now",
                                              onPressed: () {
                                                context.read<GameSessionCubit>().create(
                                                  roomcode: roomModel.code,
                                                  singlePlayer: true,
                                                );
                                              },
                                            ),
                                          ),
                                        if (players.length > 1)
                                          Expanded(
                                            child: PrimaryButton(
                                              isLoading: state.isLoading,
                                              onPressed: () {
                                                context.read<GameSessionCubit>().create(
                                                  roomcode: roomModel.code,
                                                  singlePlayer: false,
                                                );
                                              },
                                              label:
                                                  timer?.isActive == true
                                                      ? "Game starts in ${time}"
                                                      : "Play with Friends",
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                );
                              },
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
      ),
    );
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?', style: TextStyle(color: context.colorScheme.secondary)),
          content: const Text('Are you sure you want to leave this page?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
