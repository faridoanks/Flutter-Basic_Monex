import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';

class CustomCalendarPicker extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CustomCalendarPicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  
  void _blurCalendar(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true, 
      barrierLabel: '',
      barrierColor: AppColors.neutralsWhite,
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0), 
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.neutralsDark1,
              elevation: 4,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85, 
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    CalendarDatePicker(
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      
                      onDateChanged: (newDate) {
                        onDateSelected(newDate); 
                        Navigator.pop(context); 
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    String dateText = "Select deadline";
    if (selectedDate != null) {
      dateText = "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}";
    }

    
    return GestureDetector(
      onTap: () => _blurCalendar(context),
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
              dateText,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.neutralsDark1
              ),
            ),
            Icon(Icons.calendar_today_outlined, color: AppColors.neutralsSoftGrey1, size: 20),
          ],
        ),
      ),
    );
  }
}
