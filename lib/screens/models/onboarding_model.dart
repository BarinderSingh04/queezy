class OnboardingModel {
  late String image;
  late String description;

  OnboardingModel({required this.image, required this.description});
}

List<OnboardingModel> content = [
  OnboardingModel(
    image: "assets/images/onboarding1.png",
    description: "Create gamified quizzes becomes simple",
  ),
  OnboardingModel(
    image: "assets/images/onboarding2.png",
    description: "Find quizzes to test out your knowledge",
  ),
  OnboardingModel(
    image: "assets/images/onboarding3.png",
    description: "Take part in challenges with friends",
  ),
];
