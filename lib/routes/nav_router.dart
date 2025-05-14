import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:queezy/screens/screens/edit_profile_screen.dart';
import 'package:queezy/screens/screens/home_screen.dart';
import 'package:queezy/screens/screens/leaderboard_screen.dart';
import 'package:queezy/screens/screens/profile_screen.dart';
import 'package:queezy/screens/screens/quiz_category_screen.dart';
import '../screens/cubit/active_room_cubit.dart';
import '../screens/cubit/avatar_list_cubit.dart';
import 'package:queezy/screens/cubit/create_room_cubit.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/cubit/game_details_cubit.dart';
import 'package:queezy/screens/cubit/game_session_cubit.dart';
import 'package:queezy/screens/cubit/player_scores_cubit.dart';
import 'package:queezy/screens/cubit/quiz_room_cubit.dart';
import 'package:queezy/screens/models/room_model.dart';
import 'package:queezy/screens/screens/choose_category_screen.dart';
import 'package:queezy/screens/screens/choose_difficulity_screen.dart';
import 'package:queezy/screens/screens/invite_friends_screen.dart';
import 'package:queezy/screens/screens/login_screen.dart';
import 'package:queezy/screens/screens/onboarding_screen.dart';
import 'package:queezy/screens/screens/quiz_bottom_nav.dart';
import 'package:queezy/screens/screens/quiz_details_screen.dart';
import '../screens/screens/quiz_screen.dart';
import '../screens/screens/result_screen.dart';
import '../screens/screens/review_quiz_screen.dart';
import '../screens/screens/signup_detail_screen.dart';
import '../screens/screens/signup_screen.dart';
import '../screens/screens/splash_screen.dart';
import '../widgets/wrapper.dart';

import '../di/service_locator.dart';
import '../screens/cubit/auth_cubit.dart';
import '../screens/screens/login_signup_option_screen.dart';

final _rootNavigator = GlobalKey<NavigatorState>();
final _homeshellNavigatorKey = GlobalKey<NavigatorState>();

class NavRouter {
  late GoRouter router;

  NavRouter() {
    router = GoRouter(
      debugLogDiagnostics: true,
      initialLocation: NavRoute.splash.path,
      navigatorKey: _rootNavigator,
      redirect: _redirect,
      routes: <RouteBase>[
        GoRoute(
          path: NavRoute.splash.path,
          builder: (BuildContext context, GoRouterState state) {
            return SplashScreen();
          },
        ),
        GoRoute(
          path: NavRoute.onBoarding.path,
          builder: (BuildContext context, GoRouterState state) {
            return OnboardingScreen();
          },
        ),
        GoRoute(
          path: NavRoute.loginSignupOption.path,
          builder: (BuildContext context, GoRouterState state) {
            return LoginSignupOptionScreen();
          },
        ),
        GoRoute(
          path: NavRoute.login.path,
          builder: (BuildContext context, GoRouterState state) {
            return LoginScreen();
          },
        ),
        GoRoute(
          path: NavRoute.signup.path,
          builder: (BuildContext context, GoRouterState state) {
            return SignupScreen();
          },
        ),
        GoRoute(
          path: NavRoute.signupPage.path,
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (context) => getIt<AvatarListCubit>()..getAvatarList(),
              child: SignUpPage(),
            );
          },
        ),
        ShellRoute(
          parentNavigatorKey: _rootNavigator,
          navigatorKey: _homeshellNavigatorKey,
          builder: (context, state, child) {
            return BlocProvider(
              create: (context) => getIt<ActiveRoomCubit>(),
              child: QuizBottomNav(child: child),
            );
          },
          routes: [
            GoRoute(
              parentNavigatorKey: _homeshellNavigatorKey,
              path: NavRoute.home.path,
              name: NavRoute.home.name,
              pageBuilder: (context, state) {
                return _pageTransition(context, state, HomeScreen());
              },
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigator,
                  path: NavRoute.chooseCategory.path,
                  name: NavRoute.chooseCategory.name,
                  builder: (context, state) {
                    return ChooseCategoryScreen();
                  },
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _rootNavigator,
                      path: NavRoute.chooseType.path,
                      name: NavRoute.chooseType.name,
                      builder: (context, state) {
                        final selectedCategoryId = state.pathParameters["categoryId"];
                        return BlocProvider(
                          create: (context) => getIt<CreateRoomCubit>(),
                          child: ChooseDifficulityScreen(
                            selectedCategoryId: int.parse(selectedCategoryId!),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                ShellRoute(
                  parentNavigatorKey: _rootNavigator,
                  builder: (context, state, child) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(create: (context) => getIt<QuizRoomBloc>()),
                        BlocProvider(create: (context) => getIt<GameSessionCubit>()),
                      ],
                      child: Wrapper(child: child),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: NavRoute.quizDetails.path,
                      name: NavRoute.quizDetails.name,
                      builder: (context, state) {
                        return QuizDetailsScreen(quizDetails: state.extra as RoomModel);
                      },
                      routes: [
                        GoRoute(
                          path: NavRoute.quizScreen.path,
                          name: NavRoute.quizScreen.name,
                          builder: (context, state) {
                            return QuizScreen(
                              difficulty: state.uri.queryParameters["difficulty"] ?? "",
                            );
                          },
                        ),
                        GoRoute(
                          path: NavRoute.inviteFriend.path,
                          name: NavRoute.inviteFriend.name,
                          builder: (context, state) {
                            final code = state.pathParameters["code"];
                            return InviteFriendsScreen(code: code!);
                          },
                        ),
                      ],
                    ),
                    GoRoute(
                      path: NavRoute.resultScreen.path,
                      name: NavRoute.resultScreen.name,
                      builder: (context, state) {
                        final session = state.pathParameters["sessionId"];
                        final sessionId = int.parse(session!);
                        return BlocProvider(
                          create: (context) => getIt<PlayerScoresCubit>()..getScore(sessionId),
                          child: ResultScreen(session_id: sessionId),
                        );
                      },
                    ),
                    GoRoute(
                      path: NavRoute.reviewQuiz.path,
                      name: NavRoute.reviewQuiz.name,
                      builder: (context, state) {
                        final session = state.pathParameters["sessionId"];
                        final player = state.pathParameters["playerId"];
                        final sessionId = int.parse(session!);
                        final playerId = int.parse(player!);
                        return BlocProvider(
                          create: (context) {
                            return getIt<GameDetailsCubit>()..getGameDetails(sessionId, playerId);
                          },
                          child: ReviewScreen(sessionId: sessionId),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: _homeshellNavigatorKey,
              path: NavRoute.quizCategory.path,
              name: NavRoute.quizCategory.name,
              pageBuilder: (context, state) {
                return _pageTransition(context, state, QuizCategoryScreen());
              },
            ),
            GoRoute(
              parentNavigatorKey: _homeshellNavigatorKey,
              path: NavRoute.leaderboard.path,
              name: NavRoute.leaderboard.name,
              pageBuilder: (context, state) {
                return _pageTransition(context, state, LeaderBoardScreen());
              },
            ),
            GoRoute(
              parentNavigatorKey: _homeshellNavigatorKey,
              path: NavRoute.profile.path,
              name: NavRoute.profile.name,
              pageBuilder: (context, state) {
                return _pageTransition(context, state, ProfileScreen());
              },
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigator,
                  path: NavRoute.editProfile.path,
                  name: NavRoute.editProfile.name,
                  builder: (context, state) {
                    return BlocProvider(
                      create: (context) => getIt<AvatarListCubit>()..getAvatarList(),
                      child: EditProfileScreen(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  FutureOr<String?> _redirect(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthCubit>().state;
    final isLoggedIn = authState is AuthenticatedState;
    final currentLocation = state.matchedLocation;

    if (currentLocation == NavRoute.splash.path) {
      return null;
    }

    if (authState is AuthenticationInitial) {
      return NavRoute.splash.path;
    }

    if (isLoggedIn) {
      if (_isPublicRoute(currentLocation)) {
        return NavRoute.bottomNav.path;
      }
      return null;
    } else {
      if (currentLocation == NavRoute.splash.path) {
        return NavRoute.onBoarding.path;
      }
      if (!_isPublicRoute(currentLocation)) {
        return NavRoute.loginSignupOption.path;
      }
      return null;
    }
  }

  bool _isPublicRoute(String location) {
    return [
      NavRoute.splash.path,
      NavRoute.onBoarding.path,
      NavRoute.loginSignupOption.path,
      NavRoute.login.path,
      NavRoute.signup.path,
      NavRoute.signupPage.path,
    ].contains(location);
  }

  CustomTransitionPage _pageTransition(BuildContext context, GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      reverseTransitionDuration: Duration(milliseconds: 250),
      transitionDuration: Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
        final scale = Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return FadeTransition(opacity: fade, child: ScaleTransition(scale: scale, child: child));
      },
    );
  }
}
