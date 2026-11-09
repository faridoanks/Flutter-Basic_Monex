import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';

class CustomIconPicker extends StatefulWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final List<String> itemsValue;

  const CustomIconPicker({
    super.key,
    required this.value,
    required this.onChanged,
    required this.itemsValue,
  });

  @override
  State<CustomIconPicker> createState() => _CustomIconPickerState();
}

class _CustomIconPickerState extends State<CustomIconPicker> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isOpen = false;

  void _openIconPicker() {
    if (_overlayEntry != null) return; // Mencegah duplikasi overlay

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      isOpen = true;
    });
  }

  void _closeIconPicker() {
    if (_overlayEntry == null) return;

    _overlayEntry?.remove();
    _overlayEntry = null;

    // AMAN: Validasi mounted sebelum setState agar tidak loop saat widget dispose
    if (mounted) {
      setState(() {
        isOpen = false;
      });
    }
  }

  void _toggleIconPicker() {
    if (isOpen) {
      _closeIconPicker();
    } else {
      _openIconPicker();
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _closeIconPicker,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: AppColors.neutralsDark1.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.neutralsWhite,
                elevation: 4, // Tambahkan sedikit bayangan agar melayang cantik
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.neutralsGrey2),
                  ),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: widget.itemsValue.length,
                    itemBuilder: (context, index) {
                      final icon = widget.itemsValue[index];
                      final isSelected = widget.value == icon;

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          widget.onChanged(icon);
                          _closeIconPicker(); // Tutup overlay setelah pilih item
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryBrand.withOpacity(0.1)
                                : AppColors.neutralsSoftGrey2,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryBrand
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            icon,
                            fit: BoxFit.contain,
                            placeholderBuilder: (context) => const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
    // PENTING: Lepas overlay tanpa memanggil setState internal agar tidak terjadi kebocoran siklik
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleIconPicker,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.neutralsSoftGrey1),
            color: AppColors.neutralsWhite,
          ),
          child: Row(
            children: [
              if (widget.value != null)
                SvgPicture.asset(widget.value!, width: 28, height: 28)
              else
                Icon(Icons.image_outlined, color: AppColors.neutralsGrey2),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.value == null ? "Choose icon" : "Change icon",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: widget.value == null
                        ? AppColors.neutralsGrey2
                        : AppColors.neutralsDark1,
                  ),
                ),
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
