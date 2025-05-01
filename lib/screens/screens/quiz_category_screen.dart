import 'package:flutter/material.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/models/category_model.dart';
import 'package:queezy/screens/screens/choose_category_screen.dart';

class QuizCategoryScreen extends StatefulWidget {
  const QuizCategoryScreen({super.key});

  @override
  State<QuizCategoryScreen> createState() => _QuizCategoryScreenState();
}

class _QuizCategoryScreenState extends State<QuizCategoryScreen> {
  Map<String, dynamic>? selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Discover",
          style: context.textTheme.titleLarge!.copyWith(
            color: context.colorScheme.onPrimary,
            fontFamily: FontFamily.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  TextField(
                    onTap: () {
                      Navigator.pushNamed(context, NavRoute.search.path);
                    },
                    decoration: InputDecoration(
                      
                      filled: true,
                      fillColor: Color(0xff5b4dc3),
                      prefixIcon: Icon(
                        Icons.search,
                        color: context.colorScheme.onPrimary,
                      ),
                      hintText: "Quiz, categories, or friends",
                      hintStyle: context.textTheme.bodyMedium!.copyWith(
                        color: context.colorScheme.onPrimary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TopPicksCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Top rank of the week",
                      style: context.textTheme.titleLarge!.copyWith(
                        fontFamily: FontFamily.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Container(
                            height: 92,
                            width: MediaQuery.sizeOf(context).width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage("assets/images/Base.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      child: Text(
                                        "1",
                                        style: context.textTheme.bodySmall!
                                            .copyWith(
                                              color:
                                                  context.colorScheme.onPrimary,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Stack(
                                    children: [
                                      Image.asset("assets/images/avatar6.png"),
                                      Container(
                                        width: 60,
                                        height: 100,
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Image.asset(
                                            "assets/images/czech_republic.png",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bradon Matrovs",
                                        style: context.textTheme.bodyLarge!
                                            .copyWith(
                                              color:
                                                  context.colorScheme.onPrimary,
                                              fontFamily: FontFamily.w500,
                                            ),
                                      ),
                                      Text(
                                        "124 points",
                                        style: context.textTheme.bodyMedium!
                                            .copyWith(
                                              fontFamily: FontFamily.w400,
                                              color:
                                                  context.colorScheme.onPrimary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 340,
                          height: 100,

                          child: Align(
                            alignment: Alignment.topRight,
                            child: Image.asset("assets/images/gold_badge.png"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Categories",
                      style: context.textTheme.titleLarge!.copyWith(
                        fontFamily: FontFamily.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 2180,
                      child: Column(
                        children: [
                          Expanded(
                            child: CategoryGridView(
                              physics: NeverScrollableScrollPhysics(),
                              content: content,
                              selectedCategory: selectedCategory,
                              onSelect: (item) {
                                setState(() {
                                  selectedCategory = item;
                                  print("Selected Category: $selectedCategory");
                                });
                                Navigator.pushNamed(
                                  context,
                                  NavRoute.quizDetails.path,arguments: selectedCategory
                                );
                              },
                              colors: colors,
                            ),
                          ),
                        ],
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

class TopPicksCard extends StatelessWidget {
  const TopPicksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xffFFE0E6),
        image: DecorationImage(
          alignment: Alignment.bottomRight,
          image: AssetImage("assets/images/search_Illustration.png"),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffff8fa2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Text(
                  "TOP PICKS",
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Travel Trivia Quiz",
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: Color(0xff660012),
                      fontFamily: FontFamily.w500,
                    ),
                  ),

                  Row(
                    children: [
                      Image.asset("assets/images/music_icon.png"),
                      Text(
                        "Music",
                        style: context.textTheme.bodySmall!.copyWith(
                          color: Color(0xff660012),
                          fontFamily: FontFamily.w400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.circle, size: 5, color: Color(0xff660012)),
                      const SizedBox(width: 4),
                      Text(
                        "5 Quizzes",
                        style: context.textTheme.bodySmall!.copyWith(
                          color: Color(0xff660012),
                          fontFamily: FontFamily.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
