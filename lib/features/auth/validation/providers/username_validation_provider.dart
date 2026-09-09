import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/features/auth/validation/models/username_validation_model.dart';

class UsernameValidationNotifier extends Notifier<UsernameValidationModel> {
  @override
  UsernameValidationModel build() {
    return UsernameValidationModel(
      username: "",
      length: 0,
      isLengthValid: false,
      hasLetter: false,
      hasWhitespace: false,
      hasInvalidCharacter: false,
      isValid: false,
    );
  }

  void validate(String name) {
    int length = name.length;

    bool isLengthValid = length >= 4 && length <= 20;

    bool hasLetter = RegExp(r'[a-zA-Z]').hasMatch(name);

    bool hasWhitespace = name.contains(" ");

    bool hasInvalidCharacter = RegExp(r'[^a-zA-Z0-9_]').hasMatch(name) && !name.contains(" ");

    bool isValid =
        isLengthValid &&
        hasLetter &&
        !hasWhitespace &&
        !hasInvalidCharacter;

    state = state.copyWith(
      username: name,
      length: length,
      isLengthValid: isLengthValid,
      hasLetter: hasLetter,
      hasWhitespace: hasWhitespace,
      hasInvalidCharacter: hasInvalidCharacter,
      isValid: isValid,
    );
  }
}

final usernameValidationProvider =
    NotifierProvider<UsernameValidationNotifier, UsernameValidationModel>(() {
      return UsernameValidationNotifier();
    });