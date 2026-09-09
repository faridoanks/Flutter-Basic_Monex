import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';

class ValidationWidget extends StatelessWidget {
  final bool isValid;
  final String text;

  const ValidationWidget({
    super.key,
    required this.isValid,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
          size: 16,
          color: isValid
              ? AppColors.primaryBrand
              : AppColors.neutralsGrey2,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: isValid
                  ? AppColors.primaryBrand
                  : AppColors.neutralsGrey2,
            ),
          ),
        ),
      ],
    );
  }
}