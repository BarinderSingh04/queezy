import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/di/service_locator.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/cubit/join_room_cubit.dart';
import 'package:queezy/screens/models/room_model.dart';
import 'package:queezy/service/local_storage_service.dart';
import 'package:queezy/widgets/buttons_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../models/auth_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = getIt<LocalStorageService>().getUser()!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.wb_sunny_outlined, color: Color(0xffFFD6DD)),
                                const SizedBox(width: 10),
                                Text(
                                  "GOOD MORNING",
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: Color(0xffFFD6DD),
                                    fontFamily: FontFamily.w500,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              user.name ?? "",
                              style: context.textTheme.titleLarge!.copyWith(
                                fontFamily: FontFamily.w500,
                                color: context.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox.square(dimension: 50, child: Image.network(user.avatarPath)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    RecentQuizCard(),
                    const SizedBox(height: 24),
                    Container(
                      height: 240,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage("assets/images/card_design.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox.square(
                                  dimension: 50,
                                  child: Image.asset("assets/images/1.png"),
                                ),
                                Text(
                                  "FEATURED",
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    fontFamily: FontFamily.w500,
                                    color: const Color.fromARGB(219, 255, 255, 255),
                                  ),
                                ),
                                SizedBox.square(dimension: 50),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Center(
                                  child: Text(
                                    "Take part in challenges with friends or other players",
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: context.textTheme.bodyLarge!.copyWith(
                                      fontFamily: FontFamily.w500,
                                      fontSize: 16,
                                      color: context.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                SizedBox.square(dimension: 50),
                                Expanded(
                                  child: Center(
                                    child: RoundedIconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, NavRoute.chooseCategory.path);
                                      },
                                      label: "Create Game",
                                      color: context.colorScheme.onPrimary,
                                      image: ImageIcon(
                                        AssetImage("assets/images/findfrienf_icon.png"),
                                        color: context.colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox.square(
                                  dimension: 50,
                                  child: Image.asset("assets/images/2.png"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 16, right: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xff9087E5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Got a room code?",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: FontFamily.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.sizeOf(context).height / 1.7,
                                ),
                                isScrollControlled: true,
                                builder: (context) {
                                  return BlocProvider(
                                    create: (context) => getIt<JoinRoomCubit>(),
                                    child: JoinRoomSheet(),
                                  );
                                },
                              );
                            },
                            child: Text("Join Now"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colorScheme.secondary,
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  color: context.colorScheme.onPrimary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Live Quizzes",
                            style: context.textTheme.titleLarge!.copyWith(
                              fontSize: 20,
                              fontFamily: FontFamily.w500,
                            ),
                          ),
                          PlainTextButton(
                            onPressed: () {},
                            label: 'See all',
                            color: context.colorScheme.secondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Column(
                        children: [
                          QuizCard(
                            imagePath: "assets/images/stats_frame.png",
                            title: "Statistics Math Quiz",
                            subject: "Math",
                            quizCount: "12 Quizzes",
                          ),
                          const SizedBox(height: 10),
                          QuizCard(
                            imagePath: "assets/images/integer_frame.png",
                            title: "Integer Math Quiz",
                            subject: "Math",
                            quizCount: "12 Quizzes",
                          ),
                          const SizedBox(height: 10),
                          QuizCard(
                            imagePath: "assets/images/maths_frame.png",
                            title: "Algebra Math Quiz",
                            subject: "Math",
                            quizCount: "12 Quizzes",
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
    );
  }
}

class JoinRoomSheet extends StatefulWidget {
  const JoinRoomSheet({super.key});

  @override
  State<JoinRoomSheet> createState() => _JoinRoomSheetState();
}

class _JoinRoomSheetState extends State<JoinRoomSheet> {
  final TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _code.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JoinRoomCubit, Result<RoomModel>>(
      listener: (context, state) {
        if (state.data != null) {
          Navigator.of(
            context,
          ).pushReplacementNamed(NavRoute.quizDetails.path, arguments: state.data);
        }
      },
      builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color(0xff9087E5),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Stack(
                    children: [
                      Positioned.fill(child: Image.asset("assets/images/invitebg.png")),
                      Positioned.fill(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox.square(
                              dimension: 70,
                              child: Image.asset("assets/images/avatar5.png"),
                            ),
                            Text(
                              "Enter Room Code",
                              style: context.textTheme.titleLarge!.copyWith(
                                color: context.colorScheme.onPrimary,
                                fontFamily: FontFamily.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 160,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Union.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 34.0, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Join with friends and family, compete for the victory.",
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLarge!.copyWith(fontFamily: FontFamily.w500),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _code,
                        style: TextStyle(fontSize: 16, fontFamily: FontFamily.w700),
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.all(16),
                          fillColor: Color(0xffEFEEFC),
                          hintText: "AB4Z",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Color(0xffbfd2f2), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Color(0xffbfd2f2), width: 1),
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (state.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            state.error!.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: context.colorScheme.error),
                          ),
                        ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        isLoading: state.isLoading,
                        onPressed: () {
                          if (_code.text.isNotEmpty) {
                            context.read<JoinRoomCubit>().join(roomCode: _code.text);
                          }
                        },
                        label: "Join Now",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class QuizCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subject;
  final String quizCount;

  const QuizCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subject,
    required this.quizCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffefeefc)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(imagePath),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(fontFamily: FontFamily.w500),
                  ),
                  Row(
                    children: [
                      Text(
                        subject,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontFamily: FontFamily.w400,
                          color: const Color(0xff858494),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.circle, color: Color(0xff858494), size: 4),
                      const SizedBox(width: 6),
                      Text(
                        quizCount,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: const Color(0xff858494),
                          fontFamily: FontFamily.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.secondary),
          ],
        ),
      ),
    );
  }
}

class RecentQuizCard extends StatelessWidget {
  const RecentQuizCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(color: Color(0xffffccd5), borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "RECENT QUIZ",
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: Color.fromARGB(176, 102, 0, 19),
                    fontFamily: FontFamily.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.headphones, color: Color(0xff660012)),
                    const SizedBox(width: 10),
                    Text(
                      "A Basic Music Quiz",
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontFamily: FontFamily.w700,
                        color: Color(0xff660012),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(
              width: 80,
              child: Center(
                child: Stack(
                  children: [
                    RadialFilledTrackProgress(
                      progress: 65,
                      size: 180,
                      fillGradientColors: [Color.fromARGB(255, 249, 125, 145)],
                    ),
                    Center(
                      child: Text(
                        "65%",
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontFamily: FontFamily.w700,
                          color: context.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadialFilledTrackProgress extends StatelessWidget {
  final double progress; // 0.0 to 100.0
  final double size;
  final Color backgroundColor;
  final List<Color> fillGradientColors;
  final Duration animationDuration;

  const RadialFilledTrackProgress({
    Key? key,
    required this.progress,
    this.size = 150.0,
    this.backgroundColor = const Color(0xFFFFB3C0),
    this.fillGradientColors = const [Color.fromARGB(255, 249, 125, 145), Color(0xffFFB3C0)],
    this.animationDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: animationDuration,
      builder: (context, animatedValue, _) {
        return SizedBox(
          height: size,
          width: size,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              // Background track
              RadialAxis(
                minimum: 0,
                maximum: 100,
                showTicks: false,
                showLabels: false,
                startAngle: 270,
                endAngle: 630,
                radiusFactor: 0.9,
                axisLineStyle: AxisLineStyle(
                  thickness: 10.12,
                  color: backgroundColor,
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
              ),
              // Foreground progress
              RadialAxis(
                minimum: 0,
                maximum: 100,
                showTicks: false,
                showLabels: false,
                startAngle: 270,
                endAngle: 630,
                radiusFactor: 0.9,
                axisLineStyle: const AxisLineStyle(thickness: 0),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: animatedValue,
                    width: 10.12,
                    sizeUnit: GaugeSizeUnit.factor,
                    cornerStyle: CornerStyle.bothCurve,
                    gradient: SweepGradient(colors: fillGradientColors),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
