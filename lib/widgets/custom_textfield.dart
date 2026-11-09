import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/features/auth/auth_provider.dart';

class CustomTextfield extends ConsumerStatefulWidget {
  final TextEditingController control;
  final String? hint;
  final IconData? prefix;
  final FocusNode? focus;
  final bool? isPassword;
  final bool hasError;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  CustomTextfield({
    super.key,
    required this.control,
    required this.hint,
    required this.prefix,
    required this.focus,
    required this.isPassword,
    required this.hasError,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  ConsumerState<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends ConsumerState<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    final isVisible = ref.watch(isVisibleProvider);
    return SizedBox(
      width: double.infinity,
      child: Container(
        child: TextField(
      
          
          
          controller: widget.control,
          focusNode: widget.focus,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.neutralsDark1,
          ),
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            
            hintText: widget.hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: AppColors.neutralsGrey2,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primaryBrand, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: widget.hasError
                    ? AppColors.error
                    : AppColors.neutralsSoftGrey1,
                width: 2,
              ),
            ),
            prefixIcon: Icon(widget.prefix, color: AppColors.neutralsDark2),
            suffixIcon: widget.isPassword == true
                ? IconButton(
                    color: AppColors.neutralsGrey3,
                    icon: FaIcon(
                      isVisible == true
                          ? FontAwesomeIcons.eyeSlash
                          : FontAwesomeIcons.eye,
                    ),
                    onPressed: () {
                      ref.read(isVisibleProvider.notifier).state = !isVisible;
                    },
                  )
                : null,
            fillColor: AppColors.neutralsWhite,
            filled: true
          ),
          onChanged: widget.onChanged,
          obscureText: widget.isPassword == true ? !isVisible : false,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
