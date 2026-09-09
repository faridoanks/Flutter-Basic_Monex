import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/core/network/no_connection_provider.dart';

class NoConnectionPage extends ConsumerStatefulWidget {
  const NoConnectionPage({super.key});

  @override
  ConsumerState<NoConnectionPage> createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends ConsumerState<NoConnectionPage> {
  bool isCheckingInternet = false;
  @override
  Widget build(BuildContext context) {
    final noConnectionImage = ref.watch(noConnectionImageProvider);

    return Scaffold(
      backgroundColor: AppColors.neutralsWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(noConnectionImage, width: 250),

                const SizedBox(height: 32),

                Text(
                  "No Internet Connection",
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutralsDark1,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Please check your internet connection and try again.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.neutralsGrey2,
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isCheckingInternet
                        ? null
                        : () async {
                            setState(() {
                              isCheckingInternet = true;
                            });

                            await ref
                                .read(noConnectionProvider.notifier)
                                .checkInternet();

                            if (!mounted) return;

                            setState(() {
                              isCheckingInternet = false;
                            });
                          },
                    child: isCheckingInternet
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Retry"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
