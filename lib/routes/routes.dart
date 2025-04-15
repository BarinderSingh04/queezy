enum NavRoute { splash, onBoarding, chooseCategory,quizDetails ,quizScreen, resultScreen,}

extension NavRouteExtension on NavRoute {
  String get path {
    switch (this) {
      case NavRoute.splash:
        return "/";
      case NavRoute.onBoarding:
        return "onBoarding";
      case NavRoute.chooseCategory:
        return "/chooseCategory";
      case NavRoute.quizDetails:
        return "/quizDetails";
      case NavRoute.quizScreen:
        return "/quizScreen";
      case NavRoute.resultScreen:
        return "/resultScreen";  
    }
  }
}
