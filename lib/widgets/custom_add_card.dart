import 'package:flutter/material.dart';
import 'package:monex/core/theme/app_colors.dart';

class CustomAddCard extends StatelessWidget {
  
  final VoidCallback onTap;
  final bool isAddIconButton;
  final String? title;

  const CustomAddCard({
    super.key,
    
    required this.onTap,
    required this.isAddIconButton,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: isAddIconButton
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 32)
            : const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 33),
        alignment: isAddIconButton ? Alignment.center : Alignment.centerLeft,
        height: 88,
        width: isAddIconButton ? 124 : 48,
        decoration: BoxDecoration(
          color: isAddIconButton
              ? AppColors.neutralsWhite
              : AppColors.neutralsSoftGrey3,
          borderRadius: BorderRadius.circular(16),
          border: isAddIconButton
              ? Border.all(color: AppColors.neutralsGrey1, width: 1)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAddIconButton ? Icons.add : Icons.wallet,
              color: AppColors.neutralsDark1,
            ),

            if (!isAddIconButton && title != null) ...[
              const SizedBox(
                height: 4,
              ),
              Text(
                title!,
                style: const TextStyle(
                  color: AppColors.neutralsDark1,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
