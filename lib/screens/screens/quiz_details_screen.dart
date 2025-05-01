import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/di/service_locator.dart';
import 'package:queezy/screens/cubit/queezy_list_cubit.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/models/room_model.dart';
import 'package:queezy/service/socket_service.dart';

class QuizDetailsScreen extends StatefulWidget {
  const QuizDetailsScreen({super.key, this.quizDetails});
  final Map<String, dynamic>? quizDetails;

  @override
  State<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  String? selectedDifficulity;

  RoomModel? roomModel;
  @override
  void initState() {
    getIt<SocketService>().on("player_joined", (data) {
      print(data);
      final roomModel = RoomModel.fromJson(data);
      setState(() {
        this.roomModel = roomModel;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.quizDetails);
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
              child: Icon(
                Icons.share_outlined,
                color: context.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Image.asset(
                "assets/images/Illustration.png",
                fit: BoxFit.contain,
              ),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.quizDetails?['category']['category'] ?? '',
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
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: context.colorScheme.secondary,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.question_mark,
                                    color: context.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                "10 questions",
                                style: context.textTheme.bodyMedium!.copyWith(
                                  fontFamily: FontFamily.w500,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                height: 40,
                                width: 2,
                                color: Colors.grey.shade300,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: context.colorScheme.onTertiary,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.extension_outlined,
                                    color: context.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                "10 questions",
                                style: context.textTheme.bodyMedium!.copyWith(
                                  fontFamily: FontFamily.w500,
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
                        widget.quizDetails!['category']['description'],
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontFamily: FontFamily.w400,
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (roomModel != null)
                        Expanded(
                          child: ListView.separated(
                            itemCount: roomModel!.players!.length,
                            itemBuilder: (context, index) {
                              final player = roomModel!.players![index];
                              return Row(
                                children: [
                                  Image.network(
                                    "$baseUrl${player.avatar}",
                                    scale: 3,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${player.name}",
                                        style: context.textTheme.bodyMedium!
                                            .copyWith(
                                              fontFamily: FontFamily.w500,
                                            ),
                                      ),
                                      Text(
                                        player.isHost == true
                                            ? "Creator"
                                            : "Joiner",
                                        style: context.textTheme.bodySmall!
                                            .copyWith(
                                              fontFamily: FontFamily.w400,
                                              color: Colors.grey,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              return const SizedBox(height: 10);
                            },
                          ),
                        ),
                        if(roomModel == null)
                        Expanded(child: SizedBox()),
                      const SizedBox(height: 20),
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                  MediaQuery.sizeOf(context).width,
                                  50,
                                ),
                                backgroundColor:
                                    context.colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: context.colorScheme.onSecondary,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                context.read<QueezyListCubit>().getquestion(
                                  difficulity: selectedDifficulity ?? 'easy',
                                  category:
                                      widget.quizDetails?['category']["id"],
                                  type: widget.quizDetails?['type'],
                                  roomcode: roomModel!.code,
                                );
                                Navigator.pushNamed(
                                  context,
                                  NavRoute.quizScreen.path,
                                  arguments: {
                                    "category":
                                        widget
                                            .quizDetails?['category']['category'],
                                    "players": roomModel?.players?.length,
                                  },
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
                                fixedSize: Size(
                                  MediaQuery.sizeOf(context).width,
                                  50,
                                ),
                                backgroundColor:
                                    context.colorScheme.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: context.colorScheme.onSecondary,
                                  ),
                                ),
                              ),
                      
                              onPressed: () {
                                context.read<QueezyListCubit>().getquestion(
                                  difficulity: selectedDifficulity ?? 'easy',
                                  category:
                                      widget.quizDetails?['category']["id"],
                                  type: widget.quizDetails?['type'],
                                  roomcode: roomModel!.code,
                                );
                                Navigator.pushNamed(
                                  context,
                                  NavRoute.quizScreen.path,
                                  arguments:
                                      widget
                                          .quizDetails?['category']['category'],
                                );
                              },
                              child: Text(
                                "Play with Friends",
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
