import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:queezy/routes/routes.dart';

import '../../common/common.dart';
import '../cubit/auth_cubit.dart';
import 'profile_widget.dart';
import 'search_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/profile_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: BlocBuilder<AuthCubit, AuthenticationState>(
            builder: (context, state) {
              final user = state is AuthenticatedState ? state.authModel.data : null;
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 200,
                        maxHeight: 280,
                        child: Container(
                          decoration: BoxDecoration(color: context.colorScheme.secondary),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Image.asset(
                                  "assets/images/profile_bg.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.paddingOf(context).top + 6,
                                left: 16,
                                right: 16,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        final String location = GoRouterState.of(context).uri.path;
                                        if (location == NavRoute.profile.path) {
                                          return SizedBox.square(dimension: 24);
                                        }
                                        return IconButton(
                                          onPressed: () {
                                            context.goNamed(NavRoute.home.name);
                                          },
                                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.settings, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 48),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(32),
                                            topRight: Radius.circular(32),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Center(
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: 95,
                                                  height: 95,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.grey.shade100,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Image.network(
                                                    user?.avatarPath ?? "",
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                          "assets/images/avatar5.png",
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 10,
                                                  child: InkWell(
                                                    onTap: () {
                                                      context.goNamed(NavRoute.editProfile.name);
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        color: context.colorScheme.secondary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          user?.name ?? "",
                                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 24,
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
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: false,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 120,
                        maxHeight: 120,
                        child: Container(
                          padding: EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(color: Colors.white),
                          child: PointsContainer(), // Customize as needed
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 70,
                        maxHeight: 70,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(bottom: 12),
                          child: TabBar(
                            dividerColor: Colors.transparent,
                            indicator: CircleTabIndicator(color: Colors.deepPurple, radius: 3),
                            labelColor: Colors.deepPurple,
                            unselectedLabelColor: Colors.grey,
                            onTap: (index) {
                              setState(() {
                                currentTab = index;
                              });
                            },
                            tabs: const [
                              Tab(text: 'Badge'),
                              Tab(text: 'Stats'),
                              Tab(text: 'Details'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: Container(
                  color: Colors.white,
                  child: TabBarView(
                    children: [
                      buildBadgeTab(),
                      StatsWidget(),
                      Center(child: Text('Details Content')),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PointsContainer extends StatelessWidget {
  const PointsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: EdgeInsets.symmetric(horizontal: 16),
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
  final ScrollController scrollController;
  const ProfileTabView({super.key, required this.scrollController});

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
          // TabBarView(
          //   children: [
          //     buildBadgeTab(scrollController),
          //     StatsWidget(scrollController: scrollController),
          //     Center(child: Text('Details Content')),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.minHeight, required this.maxHeight, required this.child});
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
