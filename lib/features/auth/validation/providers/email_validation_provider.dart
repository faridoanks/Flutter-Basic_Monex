import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/features/auth/validation/models/email_validation_model.dart';

class EmailValidationNotifier extends Notifier<EmailValidationModel> {
  @override
  EmailValidationModel build() {
    return EmailValidationModel(
      email: "",
      hasOneAt: false,
      hasWhitespace: false,
      hasUsername: false,
      hasDomain: false,
      hasDotAfterDomain: false,
      hasValidTld: false,
      isValid: false,
    );
  }

  void validate(String email) {
    final regex = RegExp(r'^[a-zA-Z]+$');

    String localPart = "";
    String domainName = "";
    String tldName = "";

    int atAmount = "@".allMatches(email).length;

    bool hasOneAt = atAmount == 1;
    bool hasWhiteSpace = email.contains(" ");
    bool hasDomain = false;
    bool hasDotAfterDomain = false;
    bool hasUsername = false;
    bool hasValidTld = false;

    if (hasOneAt) {
      List<String> emailStructure = email.split("@");

      localPart = emailStructure.first;

      hasUsername = localPart.isNotEmpty;

      if (emailStructure.last.isNotEmpty) {
        hasDotAfterDomain = emailStructure.last.contains(".");

        if (hasDotAfterDomain) {
          List<String> domainStructure = emailStructure.last.split(".");

          domainName = domainStructure.first;
          tldName = domainStructure.last;

          hasDomain = domainName.isNotEmpty;

          bool isTldHasAlphabet = regex.hasMatch(tldName);
          hasValidTld = isTldHasAlphabet && tldName.length >= 2;
        }
      }
    }

    bool isValid =
        hasOneAt &&
        !hasWhiteSpace &&
        hasDomain &&
        hasDotAfterDomain &&
        hasUsername &&
        hasValidTld;

    state = state.copyWith(
      email: email,
      hasOneAt: hasOneAt,
      hasWhitespace: hasWhiteSpace,
      hasDomain: hasDomain,
      hasDotAfterDomain: hasDotAfterDomain,
      hasUsername: hasUsername,
      hasValidTld: hasValidTld,
      isValid: isValid,
    );
  }
}

final emailValidationProvider =
    NotifierProvider<EmailValidationNotifier, EmailValidationModel>(() {
      return EmailValidationNotifier();
    });
