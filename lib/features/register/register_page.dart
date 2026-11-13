import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/features/auth/auth_provider.dart';
import 'package:monex/features/auth/validation/providers/username_validation_provider.dart';
import 'package:monex/features/auth/validation/widgets/username_validation_widget.dart';
import 'package:monex/features/auth/validation/widgets/email_validation_widget.dart';
import 'package:monex/features/auth/validation/widgets/password_validation_widget.dart';
import 'package:monex/widgets/custom_button.dart';
import 'package:monex/widgets/custom_textfield.dart';
import 'package:monex/features/auth/validation/providers/email_validation_provider.dart';
import 'package:monex/features/auth/validation/providers/password_validation_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  // controller

  late final TextEditingController _usernameControllerReg;
  late final TextEditingController _emailControllerReg;
  late final TextEditingController _passwordControllerReg;

  //focusnode

  late final FocusNode _usernameFocusNodeReg;
  late final FocusNode _emailFocusNodeReg;
  late final FocusNode _passwordFocusNodeReg;

  bool _isStillRegistering = true;

  @override
  void initState() {
    super.initState();

    _usernameControllerReg = TextEditingController();
    _emailControllerReg = TextEditingController();
    _passwordControllerReg = TextEditingController();

    _usernameFocusNodeReg = FocusNode();
    _emailFocusNodeReg = FocusNode();
    _passwordFocusNodeReg = FocusNode();

    _usernameFocusNodeReg.addListener(() {
      setState(() {});
    });

    _emailFocusNodeReg.addListener(() {
      setState(() {});
    });

    _passwordFocusNodeReg.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameControllerReg.dispose();
    _emailControllerReg.dispose();
    _passwordControllerReg.dispose();

    _usernameFocusNodeReg.dispose();
    _emailFocusNodeReg.dispose();
    _passwordFocusNodeReg.dispose();

    super.dispose();
  }

  // register

  Future<void> _register() async {
    if (!_isStillRegistering) return;

    final username = _usernameControllerReg.text.trim();
    final email = _emailControllerReg.text.trim();
    final password = _passwordControllerReg.text;

    final usernameValidation = ref.read(usernameValidationProvider);
    final emailValidation = ref.read(emailValidationProvider);
    final passwordValidation = ref.read(passwordValidationProvider);

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ref.read(registerErrorProvider.notifier).state = true;
      ref.read(errorMessageRegister.notifier).state =
          "Please fill in all fields";
      return;
    }

    if (!usernameValidation.isValid) {
      ref.read(registerErrorProvider.notifier).state = true;
      ref.read(errorMessageRegister.notifier).state =
          "Please enter a valid username";
      return;
    }

    if (!emailValidation.isValid) {
      ref.read(registerErrorProvider.notifier).state = true;
      ref.read(errorMessageRegister.notifier).state =
          "Please enter a valid email address";
      return;
    }

    if (!passwordValidation.isValid) {
      ref.read(registerErrorProvider.notifier).state = true;
      ref.read(errorMessageRegister.notifier).state =
          "Please enter a valid password";
      return;
    }

    try {
      await ref
          .read(loadAuthProvider.notifier)
          .register(username, email, password);

      ref.read(registerErrorProvider.notifier).state = false;
      ref.read(errorMessageRegister.notifier).state = "";

      if (!mounted) return;
      debugPrint("Register Success");

      context.go('/login');
    } catch (e) {
      debugPrint('Register Error: $e');

      ref.read(registerErrorProvider.notifier).state = true;
      ref.read(errorMessageRegister.notifier).state =
          "Registration failed. Please try again. Error : $e";
    } finally {
      setState(() {
        _isStillRegistering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = ref.watch(registerErrorProvider);
    final errorMessage = ref.watch(errorMessageRegister);

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
            context.pop();
            ref.read(registerErrorProvider.notifier).state = false;
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
                        "Create Your New Account",
                        style: GoogleFonts.inter(
                          color: AppColors.neutralsDark1,
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Enter your details to create account",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: AppColors.neutralsGrey2,
                        ),
                      ),

                      const SizedBox(height: 48),

                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
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
                                    Icon(Icons.error, color: AppColors.error),

                                    const SizedBox(width: 8),

                                    Expanded(
                                      child: Text(
                                        errorMessage,
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

                      if (hasError) const SizedBox(height: 16),

                      CustomTextfield(
                        control: _usernameControllerReg,
                        hint: "Username",
                        prefix: FontAwesomeIcons.user,
                        focus: _usernameFocusNodeReg,
                        isPassword: false,
                        hasError: hasError,
                        isOnlyNumber: false,
                        onChanged: (value) {
                          ref
                              .read(usernameValidationProvider.notifier)
                              .validate(value);
                          if (hasError) {
                            ref.read(registerErrorProvider.notifier).state =
                                false;
                          }
                        },
                      ),
                      SizedBox(height: 4),
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _usernameFocusNodeReg.hasFocus
                            ? UsernameValidationWidget()
                            : SizedBox.shrink(),
                      ),

                      const SizedBox(height: 16),

                      CustomTextfield(
                        control: _emailControllerReg,
                        hint: "Email",
                        prefix: FontAwesomeIcons.envelope,
                        focus: _emailFocusNodeReg,
                        isPassword: false,
                        hasError: hasError,
                        isOnlyNumber: false,
                        onChanged: (value) {
                          ref
                              .read(emailValidationProvider.notifier)
                              .validate(value);
                          if (hasError) {
                            ref.read(registerErrorProvider.notifier).state =
                                false;
                          }
                        },
                      ),

                      SizedBox(height: 4),
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _emailFocusNodeReg.hasFocus
                            ? EmailValidationWidget()
                            : SizedBox.shrink(),
                      ),

                      SizedBox(height: 16),

                      CustomTextfield(
                        control: _passwordControllerReg,
                        hint: "Password",
                        prefix: FontAwesomeIcons.lock,
                        focus: _passwordFocusNodeReg,
                        isPassword: true,
                        hasError: hasError,
                        isOnlyNumber: false,
                        onChanged: (value) {
                          ref
                              .read(passwordValidationProvider.notifier)
                              .validate(value);
                          if (hasError) {
                            ref.read(registerErrorProvider.notifier).state =
                                false;
                          }
                        },
                      ),
                      SizedBox(height: 4),
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _passwordFocusNodeReg.hasFocus
                            ? PasswordValidationWidget()
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: CustomButton(onPress: _register, text: "Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
