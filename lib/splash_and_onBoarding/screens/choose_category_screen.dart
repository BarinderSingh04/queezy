import 'package:flutter/material.dart';

class ChooseCategoryScreen extends StatefulWidget {
  const ChooseCategoryScreen({super.key});

  @override
  State<ChooseCategoryScreen> createState() => _ChooseCategoryScreenState();
}

List<Map<String, dynamic>> content = [
  {"image": "assets/images/math.png", "category": "Math"},
  {"image": "assets/images/sports.png", "category": "Sports"},
  {"image": "assets/images/music.png", "category": "Music"},
  {"image": "assets/images/science.png", "category": "Science"},
  {"image": "assets/images/art.png", "category": "Art"},
  {"image": "assets/images/travel.png", "category": "Travel"},
  {"image": "assets/images/history.png", "category": "History"},
  {"image": "assets/images/tech.png", "category": "Tech"},
];

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6A5AE0),
        title: Center(child: Text("Choose Category")),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff6A5AE0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 684,
                    width: 359,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: content.length,
                        itemBuilder: (context, index) {
                          final item = content[index];
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffEFEEFC),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(item["image"]),
                                  Text(item["category"]),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
