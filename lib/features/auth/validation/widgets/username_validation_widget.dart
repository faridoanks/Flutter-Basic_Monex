import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/features/auth/validation/providers/username_validation_provider.dart';
import 'package:monex/features/auth/validation/widgets/validation_widget.dart';

class UsernameValidationWidget extends ConsumerWidget {
  const UsernameValidationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validation = ref.watch(usernameValidationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ValidationWidget(
          isValid: validation.isLengthValid,
          text: "4 - 20 characters",
        ),

        const SizedBox(height: 8),

        ValidationWidget(
          isValid: validation.hasLetter,
          text: "Contains at least one letter",
        ),

        const SizedBox(height: 8),

        ValidationWidget(
          isValid: !validation.hasInvalidCharacter,
          text: "Only letters, numbers and underscore (_)",
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