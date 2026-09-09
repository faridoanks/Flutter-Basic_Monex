import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/features/auth/auth_provider.dart';
import 'package:monex/widgets/custom_button.dart';
import 'package:monex/widgets/custom_textfield.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  late final TextEditingController _emailController;

  late final FocusNode _emailFocusNode;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();

    _emailFocusNode = FocusNode();

    _emailFocusNode.addListener(() {
      setState(() {});
    });
  }

  void dispose() {
    _emailController.dispose();

    _emailFocusNode.dispose();

    super.dispose();
  }

  void _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ref.read(isForgotPasswordErrorProvider.notifier).state = true;
      ref.read(errorMessageForgotPasswordProvider.notifier).state =
          "Please enter your email";
      return;
    }

    if (!email.contains('@')) {
      ref.read(isForgotPasswordErrorProvider.notifier).state = true;
      ref.read(errorMessageForgotPasswordProvider.notifier).state =
          "Please enter a valid email address";
      return;
    }


    try {
      await ref.read(loadAuthProvider.notifier).sendPasswordResetEmail(email);
      ref.read(isForgotPasswordErrorProvider.notifier).state = false;
      debugPrint("Password reset email sent $email");
    } on FirebaseAuthException catch (e) {
      debugPrint("Error $e");
    }
  }

  Widget build(BuildContext context) {
    final hasError = ref.watch(isForgotPasswordErrorProvider);
    final errorMessage = ref.watch(errorMessageForgotPasswordProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reset your password",
                        style: GoogleFonts.inter(
                          color: AppColors.neutralsDark1,
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Enter your registered email address to receive a password reset link.",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: AppColors.neutralsGrey2,
                        ),
                      ),
                      const SizedBox(height: 48),

                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: hasError
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryRedLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: AppColors.error,
                                    ),

                                    const SizedBox(width: 8),

                                    Expanded(
                                      child: Text(
                                        errorMessage,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      if (hasError) const SizedBox(height: 16),
                      CustomTextfield(
                        control: _emailController,
                        hint: "Email",
                        prefix: FontAwesomeIcons.person,
                        focus: _emailFocusNode,
                        isPassword: false,
                        hasError: hasError,
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPress: _resetPassword,
                  text: "Reset Password",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
