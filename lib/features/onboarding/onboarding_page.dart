import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/constants/app_strings.dart';
import 'package:monex/core/constants/assets_provider.dart';
import 'package:monex/features/onboarding/onboarding_provider.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/widgets/custom_button.dart';

class OnBoardingPage extends ConsumerStatefulWidget {
  const OnBoardingPage({super.key});

  @override
  ConsumerState<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends ConsumerState<OnBoardingPage> {
  late final PageController _pageController;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoImage = ref.watch(logoProvider);
    final onBoardingItems = ref.watch(onBoardingAboveProvider);

    final onBoardingIndex = ref.watch(onBoardingIndexProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 52, bottom: 52, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(logoImage, width: 40, height: 40),
                  SizedBox(width: 4),
                  Text(
                    AppStrings.appName,
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutralsDark1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 70),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    ref.read(onBoardingIndexProvider.notifier).state = index;
                  },
                  itemCount: onBoardingItems.length,
                  itemBuilder: (context, index) {
                    final items = onBoardingItems[index];
                    return Column(
                      children: [
                        Image.asset(items.image, width: 250, height: 226),
                        SizedBox(height: 70),
                        Text(
                          items.title,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutralsDark1,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          items.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: AppColors.neutralsDark1,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onBoardingItems.length, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == onBoardingIndex
                          ? AppColors.primaryBrand
                          : AppColors.neutralsGrey2,
                    ),
                  );
                }),
              ),
              SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPress: () {
                    if (onBoardingIndex < onBoardingItems.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      
                      context.go('/login');
                    }
                  },
                  text: onBoardingIndex == onBoardingItems.length - 1
                      ? AppStrings.letsGo
                      : AppStrings.next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
