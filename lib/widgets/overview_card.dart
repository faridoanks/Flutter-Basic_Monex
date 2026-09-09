import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:riverpod/riverpod.dart';
import 'package:intl/intl.dart';

class OverviewCard extends ConsumerStatefulWidget {
  void Function() onTapped;
  
  String category;
  String amount;

  OverviewCard({
    super.key,
    required this.onTapped,
    
    required this.category,
    required this.amount,
  });

  @override
  ConsumerState<OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends ConsumerState<OverviewCard> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    return InkWell(
      onTap: widget.onTapped,
      child: Container(
        height: 140,
        width: 124,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.neutralsWhite,
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.only(
            left: 20,
            top: 20,
            bottom: 20,
            right: 14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Iconsax.wallet, color: AppColors.neutralsDark1),
                  SizedBox(width: 30),
                  Icon(Icons.chevron_left, color: AppColors.primaryBrand),
                ],
              ),
              SizedBox(height: 8),
              Text(
                widget.category,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.neutralsDark1,
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.amount.toString(),
                style: GoogleFonts.inter(
                  color: AppColors.neutralsDark1,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
