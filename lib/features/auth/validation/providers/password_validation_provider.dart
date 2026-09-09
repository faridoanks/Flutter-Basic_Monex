import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/features/auth/validation/models/password_validation_model.dart';

class PasswordValidationNotifier extends Notifier<PasswordValidationModel> {
  @override
  PasswordValidationModel build() {
    return PasswordValidationModel(
      password: "",
      length: 0,
      isLengthValid: false,
      hasUppercase: false,
      hasLowercase: false,
      hasNumber: false,
      hasSpecialCharacter: false,
      hasWhitespace: false,
      isValid: false,
    );
  }

  void validate(String password) {
    int length = password.length;
    bool isLengthValid = length >= 8 && length <= 20;

    bool hasUpperCase = false;
    bool hasLowerCase = false;
    bool hasNumber = false;
    bool hasSpecialCharacter = false;
    bool hasWhiteSpace = password.contains(" ");

    if (password.isNotEmpty) {
      hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
      hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
      hasNumber = RegExp(r'[0-9]').hasMatch(password);
      hasSpecialCharacter = RegExp(
        r'[!@#$%^&*(),.?":{}|<>]',
      ).hasMatch(password);
    }

    bool isValid =
        isLengthValid &&
        hasUpperCase &&
        hasLowerCase &&
        hasNumber &&
        hasSpecialCharacter &&
        !hasWhiteSpace;

    state = state.copyWith(
      password: password,
      length: length,
      isLengthValid: isLengthValid,
      hasUppercase: hasUpperCase,
      hasLowercase: hasLowerCase,
      hasNumber: hasNumber,
      hasSpecialCharacter: hasSpecialCharacter,
      hasWhitespace: hasWhiteSpace,
      isValid: isValid,
    );
  }
}

final passwordValidationProvider =
    NotifierProvider<PasswordValidationNotifier, PasswordValidationModel>(() {
      return PasswordValidationNotifier();
    });
