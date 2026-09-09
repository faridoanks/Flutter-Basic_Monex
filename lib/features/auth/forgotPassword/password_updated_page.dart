import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:monex/core/constants/assets_provider.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/widgets/custom_button.dart';

class PasswordUpdatedPage extends ConsumerStatefulWidget {
  const PasswordUpdatedPage({super.key});

  @override
  ConsumerState<PasswordUpdatedPage> createState() =>
      _PasswordUpdatedPageState();
}

class _PasswordUpdatedPageState extends ConsumerState<PasswordUpdatedPage> {
  @override
  Widget build(BuildContext context) {
    final passwordUpdateImage = ref.watch(passwordUpdatedImageProvider);

    return Scaffold(
      backgroundColor: AppColors.neutralsWhite,

      appBar: AppBar(
        backgroundColor: AppColors.neutralsWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            context.go('/login');
          },
          icon: Icon(Icons.arrow_back, color: AppColors.neutralsDark1),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    SvgPicture.asset(passwordUpdateImage, width: 150),

                    const SizedBox(height: 24),

                    
                    Text(
                      'Password updated!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.neutralsDark1,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Your password has been setup\nsuccessfully',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.neutralsGrey2,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'BACK TO LOGIN',
                  onPress: () {
                    context.go('/login');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
