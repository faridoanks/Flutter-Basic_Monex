import 'package:flutter/material.dart';
import 'package:monex/core/theme/app_colors.dart';

class ConnectionBanner extends StatelessWidget {
  const ConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.secondaryRedLight,
      elevation: 4,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.wifi_off,
                color: AppColors.secondaryRedDark,
                size: 20,
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  'No internet connection',
                  style: TextStyle(
                    color: AppColors.secondaryRedDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}