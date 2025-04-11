enum NavRoute { splash, onBoarding, chooseCategory }

extension NavRouteExtension on NavRoute {
  String get path {
    switch (this) {
      case NavRoute.splash:
        return "/";
      case NavRoute.onBoarding:
        return "onBoarding";
      case NavRoute.chooseCategory:
        return "/chooseCategory";
    }
  }
}
