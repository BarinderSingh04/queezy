import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/splash_and_onBoarding/cubit/queezy_list_cubit.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/splash_and_onBoarding/models/quiz_result.dart';
import 'package:queezy/splash_and_onBoarding/screens/choose_category_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/onboarding_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/quiz_details_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/quiz_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/result_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/splash_screen.dart';

import '../di/service_locator.dart';

final rootNavigator = GlobalKey<NavigatorState>();

class NavRouter {
  Map<String, Widget Function(BuildContext)> routes = {
    NavRoute.splash.path: (context) => SplashScreen(),
    NavRoute.onBoarding.path: (context) => OnboardingScreen(),
    NavRoute.chooseCategory.path: (context) => ChooseCategoryScreen(),
  };

  MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    if (NavRoute.quizDetails.path == settings.name) {
      final selectedCategory = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create: (context) => getIt<QueezyListCubit>(),
              child: QuizDetailsScreen(selectedCategory: selectedCategory),
            ),
      );
    }
    if (NavRoute.quizScreen.path == settings.name) {
      final selectedDifficulity = settings.arguments as String;
      return MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: getIt<QueezyListCubit>(),
              child: QuizScreen(selectedDifficulity: selectedDifficulity),
            ),
      );
    }
    if (NavRoute.resultScreen.path == settings.name) {
      final result = settings.arguments as QuizResult;
      return MaterialPageRoute(
        builder: (context) => ResultScreen(result: result),
      );
    }
    return null;
  }
}
