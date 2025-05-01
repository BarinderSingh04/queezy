import 'package:flutter/material.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/di/service_locator.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/service/socket_service.dart';
import 'package:queezy/widgets/buttons_widget.dart';

class ChooseDifficulityScreen extends StatefulWidget {
  const ChooseDifficulityScreen({super.key, this.selectedCategory});
  final Map<String, dynamic>? selectedCategory;
  @override
  State<ChooseDifficulityScreen> createState() =>
      _ChooseDifficulityScreenState();
}

class _ChooseDifficulityScreenState extends State<ChooseDifficulityScreen> {
  String? selectedDifficulity;
  String? selectedType;
  @override
  Widget build(BuildContext context) {
    print(widget.selectedCategory);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose Category",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
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
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedType = "truefalse";
                              });
                            },
                            child: Container(
                              width: 156,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    selectedType == "truefalse"
                                        ? context.colorScheme.onTertiary
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
                                    Image.asset(
                                      "assets/images/bool_type.png",
                                    ),
                                    Text(
                                      "TRUE FALSE",
                                      style: context.textTheme.bodyMedium!
                                          .copyWith(
                                            fontFamily: FontFamily.w500,
                                            color:
                                                context.colorScheme.secondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedType = "multiple";
                              });
                            },
                            child: Container(
                              width: 156,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    selectedType == 'multiple'
                                        ? context.colorScheme.onTertiary
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
                                    Image.asset(
                                      "assets/images/multiple_type.png",
                                    ),
                                    Expanded(
                                      child: Text(
                                        "MULTI CHOICE",
                                        style: context.textTheme.bodyMedium!
                                            .copyWith(
                                              fontFamily: FontFamily.w500,
                                              color:
                                                  context.colorScheme.secondary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  selectedDifficulity == 'easy'
                                      ? context.colorScheme.secondary
                                      : context.colorScheme.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedDifficulity = "easy";
                              });
                            },
                            child: Text(
                              "Easy",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontFamily: FontFamily.w500,
                                color:
                                    selectedDifficulity == 'easy'
                                        ? context.colorScheme.onPrimary
                                        : context.colorScheme.primary,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  selectedDifficulity == 'medium'
                                      ? context.colorScheme.secondary
                                      : context.colorScheme.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedDifficulity = "medium";
                              });
                            },
                            child: Text(
                              "Medium",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color:
                                    selectedDifficulity == 'medium'
                                        ? context.colorScheme.onPrimary
                                        : context.colorScheme.primary,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  selectedDifficulity == 'hard'
                                      ? context.colorScheme.secondary
                                      : context.colorScheme.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedDifficulity = "hard";
                              });
                            },
                            child: Text(
                              "Hard",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color:
                                    selectedDifficulity == 'hard'
                                        ? context.colorScheme.onPrimary
                                        : context.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                PrimaryButton(
                  onPressed: () {
                    getIt<SocketService>().emit("create_room", '');
                    Navigator.pushNamed(
                      context,
                      NavRoute.quizDetails.path,
                      arguments: {
                        "category": widget.selectedCategory,
                        "difficulity": selectedDifficulity,
                        "type": selectedType,
                      },
                    );
                  },
                  label: 'NEXT',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
