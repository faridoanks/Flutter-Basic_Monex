import 'package:flutter/material.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomTableCalendar extends StatefulWidget {
  DateTime focusedDay;
  DateTime firstDay;
  DateTime lastDay;
  CalendarFormat calendarFormat;
  DateTime selectedDay;

  CustomTableCalendar({
    super.key,
    required this.focusedDay,
    required this.firstDay,
    required this.lastDay,
    required this.calendarFormat,
    required this.selectedDay,
  });

  @override
  State<CustomTableCalendar> createState() => _CustomTableCalendarState();
}

class _CustomTableCalendarState extends State<CustomTableCalendar> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: widget.focusedDay,
      firstDay: widget.firstDay,
      lastDay: widget.lastDay,
      calendarFormat: widget.calendarFormat,
      selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
      onDaySelected: (selected, focused) {
        setState(() {
          widget.selectedDay = selected;
          widget.focusedDay = focused;
        });
      },
      headerStyle: HeaderStyle(
        titleTextStyle: TextStyle(
          color: AppColors.neutralsDark1,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: AppColors.neutralsDark1,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: AppColors.neutralsDark1,
        ),
        formatButtonVisible: false,
      ),
      calendarStyle: CalendarStyle(
        defaultTextStyle: TextStyle(color: AppColors.neutralsDark1),
        weekendTextStyle: TextStyle(color: AppColors.neutralsDark1),
        outsideTextStyle: TextStyle(color: AppColors.neutralsGrey2),
        todayTextStyle: TextStyle(color: AppColors.neutralsWhite),
        selectedTextStyle: TextStyle(color: AppColors.neutralsWhite),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: AppColors.neutralsDark1),
        weekendStyle: TextStyle(color: AppColors.neutralsDark1),
      ),
      onFormatChanged: (value) {
        setState(() {
          widget.calendarFormat = value;
        });
      },
      availableCalendarFormats: const {
        CalendarFormat.week: '7 days',
        CalendarFormat.month: '1 month',
      },
    );
  }
}
