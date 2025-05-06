import 'package:flutter/material.dart';
import 'package:queezy/screens/screens/home_screen.dart';
import 'package:queezy/screens/screens/profile_screen.dart';
import 'package:queezy/screens/screens/quiz_category_screen.dart';

import '../../di/service_locator.dart';
import '../../service/socket_service.dart';
import 'leaderboard_screen.dart';

class QuizBottomNav extends StatefulWidget {
  const QuizBottomNav({super.key});

  @override
  State<QuizBottomNav> createState() => _QuizBottomNavState();
}

class _QuizBottomNavState extends State<QuizBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    QuizCategoryScreen(),
    Center(child: Text('Add')),
    LeaderBoardScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    getIt<SocketService>().initializeSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        child: const Icon(Icons.add, size: 32),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home_outlined,
                      color: _currentIndex == 0 ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: _currentIndex == 1 ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.bar_chart_outlined,
                      color: _currentIndex == 3 ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 3;
                      });
                    },
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    icon: Icon(
                      Icons.person_outline,
                      color: _currentIndex == 4 ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 4;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
