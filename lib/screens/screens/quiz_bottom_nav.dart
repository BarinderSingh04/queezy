import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/routes/routes.dart';

import '../../di/service_locator.dart';
import '../../service/socket_service.dart';

class QuizBottomNav extends StatefulWidget {
  final Widget child;
  const QuizBottomNav({super.key, required this.child});

  @override
  State<QuizBottomNav> createState() => _QuizBottomNavState();
}

class _QuizBottomNavState extends State<QuizBottomNav> {
  int _currentIndex = 0;

  @override
  void initState() {
    getIt<SocketService>().initializeSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
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
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        color: context.colorScheme.tertiary,
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
                      color: _currentIndex == 0 ? Colors.black : Colors.grey.shade700,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                      _onItemTapped(0, context);
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
                      _onItemTapped(1, context);
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
                      _onItemTapped(3, context);
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
                      _onItemTapped(4, context);
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

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(NavRoute.home.path);
      case 1:
        GoRouter.of(context).go(NavRoute.quizCategory.path);
      case 3:
        GoRouter.of(context).go(NavRoute.leaderboard.path);
      case 4:
        GoRouter.of(context).go(NavRoute.profile.path);
      case 2:
        GoRouter.of(context).go(NavRoute.profile.path);
    }
  }
}
