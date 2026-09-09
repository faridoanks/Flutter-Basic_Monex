import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/features/auth/validation/providers/password_validation_provider.dart';
import 'package:monex/features/auth/validation/widgets/validation_widget.dart';

class PasswordValidationWidget extends ConsumerStatefulWidget {
  const PasswordValidationWidget({super.key});

  @override
  ConsumerState<PasswordValidationWidget> createState() =>
      _PasswordValidationWidgetState();
}

class _PasswordValidationWidgetState
    extends ConsumerState<PasswordValidationWidget> {
  @override
  Widget build(BuildContext context) {
    final validation = ref.watch(passwordValidationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValidationWidget(
          isValid: validation.isLengthValid,
          text: "8 - 20 characters",
        ),

        const SizedBox(height: 8),

        ValidationWidget(
          isValid: validation.hasUppercase,
          text: "Contains at least one uppercase letter",
        ),

        const SizedBox(height: 8),

        ValidationWidget(
          isValid: validation.hasLowercase,
          text: "Contains at least one lowercase letter",
        ),

        const SizedBox(height: 8),

        ValidationWidget(
          isValid: validation.hasNumber,
          text: "Contains at least one number",
        ),

        const SizedBox(height: 8),

        ValidationWidget(
          isValid: validation.hasSpecialCharacter,
          text: "Contains at least one special character",
        ),

        const SizedBox(height: 8),

        ValidationWidget(
          isValid: !validation.hasWhitespace,
          text: "Must not contain whitespace",
        ),
      ],
    );
  }
}