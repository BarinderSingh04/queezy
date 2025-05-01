import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/splash_and_onBoarding/cubit/create_quiz_cubit.dart';
import 'package:queezy/splash_and_onBoarding/models/create_quiz.dart';
import 'package:queezy/splash_and_onBoarding/widgets/primary_button.dart';

import '../models/category_model.dart';

class ChooseCategoryScreen extends StatelessWidget {
  const ChooseCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Choose Category",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
      body: BlocBuilder<CreateQuizCubit, CreateQuiz>(
        builder: (context, state) {
          return Container(
            color: const Color(0xff6A5AE0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 0,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: content.length,
                                  itemBuilder: (context, index) {
                                    final item = content[index];
                                    bool isSelected = state.categoryName == item["category"];

                                    return Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: InkWell(
                                        onTap: () {
                                          context.read<CreateQuizCubit>().set(
                                            CreateQuiz(
                                              categoryName: item["category"],
                                              categoryId: item["id"],
                                              description: item["description"],
                                            ),
                                          );
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 250),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color:
                                                isSelected
                                                    ? Theme.of(context).colorScheme.onTertiary
                                                    : Theme.of(context).colorScheme.tertiary,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: context.colorScheme.onPrimary.withValues(
                                                    alpha: isSelected ? 0.5 : 1,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    item["image"],
                                                    height: 40,
                                                    width: 40,
                                                    color: isSelected ? Colors.white : null,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  item["category"],
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium!.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        isSelected
                                                            ? Theme.of(
                                                              context,
                                                            ).colorScheme.onPrimary
                                                            : Theme.of(
                                                              context,
                                                            ).colorScheme.secondary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              PrimaryButton(
                                text: "Next",
                                onTap: () {
                                  if (state.categoryName != null) {
                                    Navigator.pushNamed(context, NavRoute.quizDetails.path);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Please select a category!")),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
