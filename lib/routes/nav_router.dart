import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/splash_and_onBoarding/cubit/create_quiz_cubit.dart';
import 'package:queezy/splash_and_onBoarding/cubit/queezy_list_cubit.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/splash_and_onBoarding/cubit/quiz_state_cubit.dart';
import 'package:queezy/splash_and_onBoarding/screens/choose_category_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/onboarding_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/quiz_details_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/quiz_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/result_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/review_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/splash_screen.dart';

import '../di/service_locator.dart';

final rootNavigator = GlobalKey<NavigatorState>();

class NavRouter {
  Map<String, Widget Function(BuildContext)> routes = {
    NavRoute.splash.path: (context) {
      return SplashScreen();
    },
    NavRoute.onBoarding.path: (context) {
      return OnboardingScreen();
    },
    NavRoute.chooseCategory.path: (context) {
      final cubit = getIt<CreateQuizCubit>()..reset();
      return BlocProvider.value(value: cubit, child: ChooseCategoryScreen());
    },
    NavRoute.quizDetails.path: (context) {
      return BlocProvider.value(value: getIt<CreateQuizCubit>(), child: QuizDetailsScreen());
    },
    NavRoute.quizScreen.path: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: getIt<CreateQuizCubit>()),
          BlocProvider(create: (context) => getIt<QueezyListCubit>()),
          BlocProvider.value(value: getIt<QuizStateCubit>()),
        ],
        child: QuizScreen(),
      );
    },
    NavRoute.resultScreen.path: (context) {
      return BlocProvider.value(value: getIt<QuizStateCubit>(), child: ResultScreen());
    },
    NavRoute.reviewScreen.path: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: getIt<QuizStateCubit>()),
          BlocProvider.value(value: getIt<CreateQuizCubit>()),
        ],
        child: ReviewScreen(),
      );
    },
  };
}
