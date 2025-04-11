import 'package:flutter/widgets.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/splash_and_onBoarding/screens/choose_category_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/onboarding_screen.dart';
import 'package:queezy/splash_and_onBoarding/screens/splash_screen.dart';

final rootNavigator = GlobalKey<NavigatorState>();

class NavRouter {
 
  Map<String, Widget Function(BuildContext)> routes = {
   NavRoute.splash.path: (context) => SplashScreen(),
   NavRoute.onBoarding.path: (context) => OnboardingScreen(),
   NavRoute.chooseCategory.path: (context) => ChooseCategoryScreen(),
  }; 
}
