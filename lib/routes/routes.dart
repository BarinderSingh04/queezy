enum NavRoute {
  splash,
  onBoarding,
  loginSignupOption,
  login,
  signup,
  signupPage,
  resetPassword,
  newPassword,
  bottomNav,
  home,
  quizCategory,
  search,
  inviteFriend,
  chooseCategory,
  chooseType,
  quizDetails,
  quizScreen,
  resultScreen,
  reviewQuiz,
  profile
}

extension NavRouteExtension on NavRoute {
  String get path {
    switch (this) {
      case NavRoute.splash:
        return "/";
      case NavRoute.onBoarding:
        return "onBoarding";
      case NavRoute.loginSignupOption:
        return "/loginSignupOption";
      case NavRoute.signup:
        return "/signup";
      case NavRoute.signupPage:
        return "/signupPage";
      case NavRoute.login:
        return "/login";
      case NavRoute.resetPassword:
        return "/resetPassword";
      case NavRoute.newPassword:
        return "/newPassword";
      case NavRoute.bottomNav:
        return "/bottomNav";
      case NavRoute.home:
        return "/home";
      case NavRoute.quizCategory:
        return "/quizCategory";
      case NavRoute.inviteFriend:
        return "/inviteFriend";
      case NavRoute.search:
        return "/search";
      case NavRoute.chooseCategory:
        return "/chooseCategory";
      case NavRoute.chooseType:
        return "/chooseType";
      case NavRoute.quizDetails:
        return "/quizDetails";
      case NavRoute.quizScreen:
        return "/quizScreen";
      case NavRoute.resultScreen:
        return "/resultScreen";
      case NavRoute.reviewQuiz:
        return "/reviewQuiz";
      case NavRoute.profile:
        return "/profile";
    }
  }
}
