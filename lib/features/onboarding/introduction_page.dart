import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:monex/core/constants/assets_provider.dart';
import 'package:monex/core/constants/app_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroductionPage extends ConsumerStatefulWidget {
  const IntroductionPage({super.key});

  @override
  ConsumerState<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends ConsumerState<IntroductionPage> {
  @override
  void initState() {
    super.initState();
    print('intro');

    Future.delayed(Duration(seconds: 3), () {
      print('move');
      context.push('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    final logoImage = ref.watch(logoProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(logoImage, width: 104, height: 104),
      
              SizedBox(height: 20),
      
              Text(
                AppStrings.appName,
                style: GoogleFonts.inter(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
