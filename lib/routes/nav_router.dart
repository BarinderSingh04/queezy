import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/screens/cubit/queezy_list_cubit.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/cubit/quiz_logic_cubit.dart';
import 'package:queezy/screens/screens/choose_category_screen.dart';
import 'package:queezy/screens/screens/choose_difficulity_screen.dart';
import 'package:queezy/screens/screens/home_screen.dart';
import 'package:queezy/screens/screens/invite_friends_screen.dart';
import 'package:queezy/screens/screens/login_screen.dart';
import 'package:queezy/screens/screens/new_password_screen.dart';
import 'package:queezy/screens/screens/onboarding_screen.dart';
import 'package:queezy/screens/screens/profile_screen.dart';
import 'package:queezy/screens/screens/quiz_bottom_nav.dart';
import 'package:queezy/screens/screens/quiz_details_screen.dart';
import 'package:queezy/screens/screens/quiz_screen.dart';
import 'package:queezy/screens/screens/reset_password_screen.dart';
import 'package:queezy/screens/screens/result_screen.dart';
import 'package:queezy/screens/screens/review_quiz_screen.dart';
import 'package:queezy/screens/screens/quiz_category_screen.dart';
import 'package:queezy/screens/screens/signup_detail_screen.dart';
import 'package:queezy/screens/screens/signup_screen.dart';
import 'package:queezy/screens/screens/splash_screen.dart';

import '../di/service_locator.dart';
import '../screens/cubit/auth_cubit.dart';
import '../screens/screens/login_signup_option_screen.dart';
import '../screens/screens/search_screen.dart';

final rootNavigator = GlobalKey<NavigatorState>();

class NavRouter {
  Map<String, Widget Function(BuildContext)> routes = {
    NavRoute.splash.path: (context) => SplashScreen(),
    NavRoute.onBoarding.path: (context) => OnboardingScreen(),
    NavRoute.loginSignupOption.path: (context) => LoginSignupOptionScreen(),
    NavRoute.signup.path: (context) => SignupScreen(),
    NavRoute.signupPage.path:
        (context) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: SignUpPage(),
        ),
    NavRoute.login.path:
        (context) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: LoginScreen(),
        ),
    NavRoute.resetPassword.path: (context) => ResetPasswordScreen(),
    NavRoute.newPassword.path: (context) => NewPasswordScreen(),
    NavRoute.bottomNav.path: (context) => QuizBottomNav(),
    NavRoute.home.path: (context) => HomeScreen(),
    NavRoute.quizCategory.path: (context) => QuizCategoryScreen(),

    NavRoute.search.path: (context) => SearchScreen(),
    NavRoute.chooseCategory.path: (context) => ChooseCategoryScreen(),
    NavRoute.profile.path: (context) => ProfileScreen(),
  };

  MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    if (NavRoute.inviteFriend.path == settings.name) {
      final code = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => InviteFriendsScreen(code: code),
      );
    }
    if (NavRoute.chooseType.path == settings.name) {
      final selectedCategory = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder:
            (context) =>
                ChooseDifficulityScreen(selectedCategory: selectedCategory),
      );
    }
    if (NavRoute.quizDetails.path == settings.name) {
      final quizDetails = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create: (context) => getIt<QueezyListCubit>(),
              child: QuizDetailsScreen(quizDetails: quizDetails),
            ),
      );
    }
    if (NavRoute.quizScreen.path == settings.name) {
      final category = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder:
            (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: getIt<QueezyListCubit>()),
                BlocProvider(create: (context) => getIt<QuizLogicCubit>()),
              ],
              child: QuizScreen(quizDetails: category),
            ),
      );
    }
    if (NavRoute.resultScreen.path == settings.name) {
      final sessionId = settings.arguments as int;
      return MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: getIt<QuizLogicCubit>(),
              child: ResultScreen(session_id: sessionId),
            ),
      );
    }
    if (NavRoute.reviewQuiz.path == settings.name) {
      return MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: getIt<QuizLogicCubit>(),
              child: ReviewQuizScreen(),
            ),
      );
    }
    return null;
  }
}
