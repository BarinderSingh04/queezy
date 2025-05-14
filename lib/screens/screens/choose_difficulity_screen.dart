import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/cubit/create_room_cubit.dart';
import 'package:queezy/screens/models/room_model.dart';
import 'package:queezy/widgets/buttons_widget.dart';

class ChooseDifficulityScreen extends StatefulWidget {
  const ChooseDifficulityScreen({super.key, this.selectedCategoryId});
  final int? selectedCategoryId;
  @override
  State<ChooseDifficulityScreen> createState() => _ChooseDifficulityScreenState();
}

class _ChooseDifficulityScreenState extends State<ChooseDifficulityScreen> {
  String? selectedDifficulity;
  String? selectedType;

  List<type> types = [
    (image: "assets/images/bool_type.png", type: "TRUE FALSE", value: "boolean"),
    (image: "assets/images/multiple_type.png", type: "MULTI CHOICE", value: "multiple"),
  ];

  List<difficulty> difficulties = [
    (type: "EASY", value: "easy"),
    (type: "MEDIUM", value: "medium"),
    (type: "HARD", value: "hard"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.secondary,
      appBar: AppBar(
        title: Text("Choose Difficulty", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: context.colorScheme.onPrimary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<CreateRoomCubit, Result<RoomModel>>(
              listener: (context, state) {
                if (state.data != null) {
                  context.goNamed(NavRoute.quizDetails.name, extra: state.data);
                }
                if (state.error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error.toString())));
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose Type",
                          style: context.textTheme.titleLarge!.copyWith(
                            fontFamily: FontFamily.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          spacing: 10,
                          children:
                              types.map((e) {
                                return Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedType = e.value;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color:
                                            selectedType == e.value
                                                ? context.colorScheme.secondary
                                                : context.colorScheme.tertiary,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 24,
                                        ),
                                        child: Column(
                                          spacing: 8,
                                          children: [
                                            Image.asset(e.image),
                                            Text(
                                              e.type,
                                              style: context.textTheme.bodyMedium!.copyWith(
                                                fontFamily: FontFamily.w500,
                                                color:
                                                    selectedType != e.value
                                                        ? context.colorScheme.secondary
                                                        : Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          "Choose Difficulity",
                          style: context.textTheme.titleLarge!.copyWith(
                            fontFamily: FontFamily.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:
                              difficulties
                                  .map(
                                    (e) => ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            selectedDifficulity == e.value
                                                ? context.colorScheme.secondary
                                                : context.colorScheme.tertiary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedDifficulity = e.value;
                                        });
                                      },
                                      child: Text(
                                        e.type,
                                        style: context.textTheme.bodyMedium!.copyWith(
                                          fontFamily: FontFamily.w500,
                                          color:
                                              selectedDifficulity == e.value
                                                  ? context.colorScheme.onPrimary
                                                  : context.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                    Spacer(),
                    PrimaryButton(
                      label: 'NEXT',
                      isLoading: state.isLoading,
                      onPressed:
                          selectedDifficulity == null || selectedType == null
                              ? null
                              : () {
                                context.read<CreateRoomCubit>().createRoom(
                                  categoryId: widget.selectedCategoryId!,
                                  type: selectedType!,
                                  difficulty: selectedDifficulity!,
                                );
                              },
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

typedef type = ({String type, String image, String value});
typedef difficulty = ({String type, String value});
