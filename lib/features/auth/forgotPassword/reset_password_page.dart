import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/widgets/custom_textfield.dart';
import 'package:monex/widgets/custom_button.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  final String oobCode;

  const ResetPasswordPage({
    super.key,
    required this.oobCode,
  });

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  bool _isLoading = true;
  bool _isValidCode = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();

    _verifyCode();
  }

  Future<void> _verifyCode() async {
    try {
      await FirebaseAuth.instance.verifyPasswordResetCode(
        widget.oobCode,
      );

      if (!mounted) return;

      setState(() {
        _isValidCode = true;
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      debugPrint(
        'Verify reset code error: ${e.code} - ${e.message}',
      );

      setState(() {
        _isValidCode = false;
        _isLoading = false;
        _hasError = true;
        _errorMessage =
            'This password reset link is invalid or has expired.';
      });
    }
  }

  Future<void> _resetPassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Field kosong
    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    // Password tidak sama
    if (password != confirmPassword) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: widget.oobCode,
        newPassword: password,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Password Changed'),
            content: const Text(
              'Your password has been successfully changed.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      context.go('/login');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      debugPrint(
        'Reset password error: ${e.code} - ${e.message}',
      );

      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage =
            'Failed to change password. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isValidCode) {
      return Scaffold(
        backgroundColor: AppColors.neutralsWhite,
        appBar: AppBar(
          backgroundColor: AppColors.neutralsWhite,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.neutralsDark1,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.error,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.neutralsWhite,

      // Sama seperti RegisterPage
      appBar: AppBar(
        backgroundColor: AppColors.neutralsWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.neutralsDark1,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            30,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE
                      Text(
                        'Reset Your Password',
                        style: GoogleFonts.inter(
                          color: AppColors.neutralsDark1,
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // SUBTITLE
                      Text(
                        'Create a new password for your account',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: AppColors.neutralsGrey2,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // ERROR MESSAGE
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: _hasError
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.secondaryRedLight,
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: AppColors.error,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage,
                                        style: GoogleFonts.inter(
                                          color: AppColors.error,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      if (_hasError)
                        const SizedBox(height: 16),

                      // NEW PASSWORD
                      CustomTextfield(
                        control: _passwordController,
                        hint: 'New Password',
                        prefix: FontAwesomeIcons.lock,
                        focus: _passwordFocusNode,
                        isPassword: true,
                        hasError: _hasError,
                        onChanged: (_) {
                          if (_hasError) {
                            setState(() {
                              _hasError = false;
                              _errorMessage = '';
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // CONFIRM PASSWORD
                      CustomTextfield(
                        control: _confirmPasswordController,
                        hint: 'Confirm Password',
                        prefix: FontAwesomeIcons.lock,
                        focus: _confirmPasswordFocusNode,
                        isPassword: true,
                        hasError: _hasError,
                        onChanged: (_) {
                          if (_hasError) {
                            setState(() {
                              _hasError = false;
                              _errorMessage = '';
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // BUTTON
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Reset Password',
                  onPress: _isLoading ? null : _resetPassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}