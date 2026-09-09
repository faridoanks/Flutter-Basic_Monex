import 'package:flutter_riverpod/legacy.dart';
import 'package:monex/features/onboarding/onboarding_model.dart';

final isEverSeenProvider = StateProvider<bool>((ref) {
  return false;
});

final onBoardingIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final onBoardingAboveProvider = StateProvider<List<OnBoardingModel>>((ref) => [
  OnBoardingModel(title: "Note Down Expenses", image: "assets/images/onboarding_1.png", description: "Daily note your expenses to help  manage money"),
  OnBoardingModel(title: "Simple Money Management", image: "assets/images/onboarding_2.png", description: "Get your notifications or alert when you do the over expenses"),
  OnBoardingModel(title: "Easy to Track and Analize", image: "assets/images/onboarding_3.png", description: "Tracking your expense to help make sure you don't overspend")
]);
