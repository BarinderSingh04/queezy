import 'package:flutter/material.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/di/service_locator.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/service/token_service.dart';

import 'profile_widget.dart';
import 'search_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              getIt<TokenService>().clearToken();
              Navigator.of(context).pushNamedAndRemoveUntil(NavRoute.login.path, (route) => false);
            },
            icon: Icon(Icons.settings, color: context.colorScheme.onPrimary),
          ),
        ],
      ),
      body: Stack(
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/profile_bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 68,
            left: 8,
            right: 8,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.onPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    Text(
                      "Madelyn Dias",
                      style: context.textTheme.headlineSmall!.copyWith(fontFamily: FontFamily.w500),
                    ),
                    const SizedBox(height: 24),
                    const PointsContainer(),
                    const SizedBox(height: 10),
                    SizedBox(height: 500, child: const ProfileTabView()),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 138,
            right: 138,
            child: Center(child: Image.asset("assets/images/3x/avatar1.png", scale: 1.6)),
          ),
          Positioned(
            top: 80,
            left: 228,
            right: 138,
            child: Center(child: Image.asset("assets/images/3x/hungary.png", scale: 1.8)),
          ),
        ],
      ),
    );
  }
}

class PointsContainer extends StatelessWidget {
  const PointsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 101,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.colorScheme.secondary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPointColumn(context, Icons.star_border, "POINTS", "590"),
            _buildDivider(),
            _buildPointColumn(context, Icons.language, "WORLD RANK", "#1,438"),
            _buildDivider(),
            _buildPointColumn(
              context,
              null,
              "POINTS",
              "590",
              customIcon: "assets/images/local_rank_icon.png",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointColumn(
    BuildContext context,
    IconData? icon,
    String label,
    String value, {
    String? customIcon,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (customIcon != null)
          Image.asset(customIcon)
        else if (icon != null)
          Icon(icon, color: context.colorScheme.onPrimary),
        Text(
          label,
          style: context.textTheme.bodySmall!.copyWith(
            fontFamily: FontFamily.w500,
            color: const Color.fromARGB(180, 255, 255, 255),
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodyLarge!.copyWith(
            fontFamily: FontFamily.w700,
            color: context.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(41, 255, 255, 255),
            Colors.white,
            const Color.fromARGB(41, 255, 255, 255),
          ],
        ),
      ),
    );
  }
}

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            indicator: CircleTabIndicator(color: Colors.deepPurple, radius: 3),
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            tabs: const [Tab(text: 'Badge'), Tab(text: 'Stats'), Tab(text: 'Details')],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              children: [buildBadgeTab(), StatsWidget(), Center(child: Text('Details Content'))],
            ),
          ),
        ],
      ),
    );
  }
}
