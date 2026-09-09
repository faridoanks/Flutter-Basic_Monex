import 'package:riverpod/riverpod.dart';

final logoProvider = Provider<String>((ref) {
  return "assets/logos/monex_logo.svg";
});

final firstOnBoardingProvider = Provider<String>((ref) {
  return "assets/images/onboarding_1.png";
});

final secondOnBoardingProvider = Provider<String>((ref) {
  return "assets/images/onboarding_2.png";
});

final thirdOnBoardingProvider = Provider<String>((ref) {
  return "assets/images/onboarding_3.png";
});

final passwordUpdatedImageProvider = Provider<String>((ref) {
  return "assets/images/password_updated.svg";
});

final appleLogoProvider = Provider<String>((ref) {
  return "assets/logos/apple_logo.svg";
});

final googleLogoProvider = Provider<String>((ref) {
  return "assets/logos/google_logo.svg";
});
