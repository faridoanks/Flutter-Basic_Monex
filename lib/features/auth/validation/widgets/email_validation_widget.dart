import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/features/auth/validation/providers/email_validation_provider.dart';
import 'package:monex/features/auth/validation/widgets/validation_widget.dart';

class EmailValidationWidget extends ConsumerStatefulWidget {
  const EmailValidationWidget({super.key});

  @override
  ConsumerState<EmailValidationWidget> createState() =>
      _EmailValidationWidgetState();
}

class _EmailValidationWidgetState
    extends ConsumerState<EmailValidationWidget> {
  @override
  Widget build(BuildContext context) {
    final validation = ref.watch(emailValidationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValidationWidget(
          isValid: validation.hasOneAt,
          text: "Contains exactly one @",
        ),

        const SizedBox(height: 8),

        ValidationWidget(
          isValid: !validation.hasWhitespace,
          text: "Must not contain whitespace",
        ),

        const SizedBox(height: 8),

        ValidationWidget(
          isValid: validation.hasUsername,
          text: "Username is not empty",
        ),

        const SizedBox(height: 8),

        ValidationWidget(
          isValid: validation.hasDomain,
          text: "Domain is not empty",
        ),

        const SizedBox(height: 8),

        ValidationWidget(
          isValid: validation.hasDotAfterDomain,
          text: "Contains domain extension",
        ),

        const SizedBox(height: 8),

        ValidationWidget(
          isValid: validation.hasValidTld,
          text: "Valid top-level domain (e.g. .com, .id)",
        ),
      ],
    );
  }
}