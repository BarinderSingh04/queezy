// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/routes/routes.dart';
import '../models/category_model.dart';

class ChooseCategoryScreen extends StatefulWidget {
  const ChooseCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ChooseCategoryScreen> createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  int? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Category", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
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
                    height: 684,
                    width: 359,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: CategoryGridView(
                              content: content,
                              isSelected: (id) => selectedCategoryId == id,
                              onSelect: (id) {
                                setState(() {
                                  selectedCategoryId = id;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              fixedSize: Size(MediaQuery.of(context).size.width, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              if (selectedCategoryId != null) {
                                context.push(
                                  context.namedLocation(
                                    NavRoute.chooseType.name,
                                    pathParameters: {'categoryId': selectedCategoryId.toString()},
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Please select a category!")),
                                );
                              }
                            },
                            child: Text(
                              "Next",
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
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
      ),
    );
  }
}

class CategoryGridView extends StatelessWidget {
  final List<Map<String, dynamic>> content;
  final Function(int id) onSelect;
  final bool Function(int id) isSelected;
  final List<Color>? colors;

  CategoryGridView({
    Key? key,
    required this.content,
    required this.onSelect,
    this.colors,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = colors ?? [];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 1,
      ),
      itemCount: content.length,
      itemBuilder: (context, index) {
        final item = content[index];

        return Padding(
          padding: const EdgeInsets.all(12),
          child: InkWell(
            onTap: () => onSelect(item["id"]),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:
                    color.isEmpty
                        ? isSelected(item["id"])
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.tertiary
                        : colors?[index],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context.colorScheme.onPrimary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(item["image"], height: 40, width: 40),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item["category"],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color:
                            color.isEmpty
                                ? isSelected(item["id"])
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.secondary
                                : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
