import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/constants/app_strings.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/core/constants/assets_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monex/features/auth/auth_provider.dart';
import 'package:monex/widgets/continue_login_button.dart';
import 'package:monex/widgets/custom_textfield.dart';
import 'package:monex/widgets/custom_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final TextEditingController _identifierController;
  late final TextEditingController _passwordController;
  late final FocusNode _usernameFocusNode;
  late final FocusNode _passwordFocusNode;
  @override
  void initState() {
    _identifierController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadAuth = ref.watch(loadAuthProvider);
    final logoImage = ref.watch(logoProvider);
    final hasError = ref.watch(loginErrorProvider);

    final appleLogo = ref.watch(appleLogoProvider);
    final googleLogo = ref.watch(googleLogoProvider);

    return Scaffold(
      backgroundColor: AppColors.neutralsWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 24,
              right: 24,
              bottom: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(logoImage, width: 66, height: 66),
                SizedBox(height: 12),
                Text(
                  AppStrings.appName,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutralsDark1,
                  ),
                ),
                SizedBox(height: 56),
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
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Incorrect username or password",
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
                SizedBox(height: 16),
                CustomTextfield(
                  control: _identifierController,
                  focus: _usernameFocusNode,
                  hint: 'Username',
                  prefix: FontAwesomeIcons.user,
                  isPassword: false,
                  hasError: hasError,
                ),
                SizedBox(height: 20),
                CustomTextfield(
                  control: _passwordController,
                  focus: _passwordFocusNode,
                  hint: 'Password',
                  prefix: FontAwesomeIcons.lock,
                  isPassword: true,
                  hasError: hasError,
                ),
                SizedBox(height: 24),
                CustomButton(
                  text: "Login",
                  onPress: () async {
                    if (_identifierController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      ref.read(loginErrorProvider.notifier).state = true;
                      return;
                    }

                    try {
                      await ref
                          .read(loadAuthProvider.notifier)
                          .login(
                            _identifierController.text.trim(),
                            _passwordController.text,
                          );
                      debugPrint('UID : ${loadAuth!.uid}');
                      debugPrint('Email : ${loadAuth.email}');
                      ref.read(loginErrorProvider.notifier).state = false;

                      if (!context.mounted) return;

                      context.go('/dashboard');
                    } catch (e) {
                      ref.read(loginErrorProvider.notifier).state = true;
                    }
                  },
                ),
                SizedBox(height: 8),
                TextButton(
                  child: Text(
                    "Forgot Password",
                    style: GoogleFonts.inter(
                      color: AppColors.neutralsGrey1,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    ref.watch(loginErrorProvider.notifier).state = false;
                    context.push('/forgotpassword');
                  },
                ),
                SizedBox(height: 4),
                Text(
                  'Or',
                  style: GoogleFonts.inter(
                    color: AppColors.neutralsDark2,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 16),
                ContinueLoginButton(
                  text: "CONTINUE WITH GOOGLE",
                  iconAsset: googleLogo,
                  onPress: () async {
                    try {
                      await ref
                          .read(loadAuthProvider.notifier)
                          .signInWithGoogle();
                      

                      if (!context.mounted) return;

                      context.go('/dashboard');
                    } catch (e, stacktrace) {
                      debugPrint("Error $e");
                      debugPrint("Stacktrace $stacktrace");
                    }
                  },
                ),
                SizedBox(height: 20),
                ContinueLoginButton(
                  text: "CONTINUE WITH APPLE (Coming Soon)",
                  iconAsset: appleLogo,
                  onPress: null,
                ),

                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't Have an Account?",
                      style: GoogleFonts.inter(color: AppColors.neutralsDark1),
                    ),
                    SizedBox(width: 4),
                    TextButton(
                      child: Text(
                        "Register Here",
                        style: GoogleFonts.inter(color: AppColors.primaryBrand),
                      ),
                      onPressed: () {
                        ref.watch(loginErrorProvider.notifier).state = false;
                        context.push('/register');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
