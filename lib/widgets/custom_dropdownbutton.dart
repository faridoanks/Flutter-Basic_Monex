import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'dart:ui';

class CustomDropdownbutton extends StatefulWidget {
  String? value;
  ValueChanged<String?> onChanged;
  List<dynamic> itemsValue;

  CustomDropdownbutton({
    super.key,
    required this.value,
    required this.onChanged,
    required this.itemsValue,
  });

  @override
  State<CustomDropdownbutton> createState() => _CustomDropdownbuttonState();
}

class _CustomDropdownbuttonState extends State<CustomDropdownbutton> {
  LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;

  bool isOpen = false;

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      isOpen = true;
    });
  }

  void _closeDropDown() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          isOpen = false;
        });
      }
    });
  }

  void _toggleDropdown() {
    if (isOpen) {
      _closeDropDown();
    } else {
      _openDropdown();
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;

    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDropDown,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: AppColors.neutralsDark1.withOpacity(0.15),
                ),
              ),
            ),
          ),
          Center(
            child: Material(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.neutralsWhite,
              child: Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.neutralsGrey2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.itemsValue.map((value) {
                    return InkWell(
                      onTap: () {
                        widget.onChanged(value);
                        _closeDropDown();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 22,
                        ),
                        child: Text(
                          value,
                          style: GoogleFonts.inter(
                            fontWeight: widget.value == value
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: widget.value == value
                                ? AppColors.neutralsDark1
                                : AppColors.neutralsGrey2,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _closeDropDown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.neutralsSoftGrey1),
            color: AppColors.neutralsWhite,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.value.toString(),
                style: TextStyle(fontSize: 16, color: AppColors.neutralsDark1),
              ),
              Icon(
                isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColors.neutralsSoftGrey1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
