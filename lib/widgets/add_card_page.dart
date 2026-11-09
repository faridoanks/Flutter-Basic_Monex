import 'package:flutter/material.dart';
import 'package:monex/core/theme/app_colors.dart';

class AddCardPage extends StatefulWidget {
  Function() onTap;
  bool isAddIconButton;
  String? title;

  AddCardPage({
    super.key,
    required this.onTap,
    required this.isAddIconButton,
    this.title,
  });

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  @override
  Widget build(BuildContext context) {
    bool _isAddIconButton = widget.isAddIconButton;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        alignment: _isAddIconButton == true
            ? Alignment.center
            : Alignment.centerLeft,
        height: 88,
        width: _isAddIconButton == true ? 124 : 48,
        decoration: BoxDecoration(
          color: _isAddIconButton == true
              ? AppColors.neutralsWhite
              : AppColors.neutralsSoftGrey3,
          borderRadius: BorderRadius.circular(16),
          border: _isAddIconButton == true
              ? Border.all(color: AppColors.neutralsGrey1, width: 1)
              : null,
        ),
        child: Column(
          u
        ),
      ),
    );
  }
}
