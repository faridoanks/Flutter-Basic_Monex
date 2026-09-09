import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';

class ContinueLoginButton extends StatelessWidget {
  final String text;
  final String iconAsset;
  final VoidCallback? onPress;

  const ContinueLoginButton({
    super.key,
    required this.text,
    required this.iconAsset,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPress,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.neutralsWhite,
          side: BorderSide(
            color: AppColors.neutralsSoftGrey1,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 18,
              height: 18,
            ),

            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    color: AppColors.neutralsDark1,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            
            const SizedBox(width: 18),
          ],
        ),
      ),
    );
  }
}