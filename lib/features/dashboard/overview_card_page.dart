import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/features/dashboard/dashboard_provider.dart';
import 'package:monex/features/transactions/transaction_helper.dart';
import 'package:riverpod/riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class OverviewCardPage extends ConsumerStatefulWidget {
  String type;
  OverviewCardPage({super.key, required this.type});

  @override
  ConsumerState<OverviewCardPage> createState() => _OverviewCardPageState();
}

class _OverviewCardPageState extends ConsumerState<OverviewCardPage> {
  DateTime focusedDay = DateTime.now();
  late DateTime selectedDay = DateTime.now();
  final DateTime firstDay = DateTime(2020);
  final DateTime lastDay = DateTime(2030);

  String selectedDayFormat = '7 days';
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    final category = Categories();
    final typeOptions = category.getCategoryIcon(widget.type);
    final dashboard = ref.watch(dashboardProvider);
    final selectedTransactions = dashboard.recentTransactions.where((
      transaction,
    ) {
      return isSameDay(transaction.createdAt, selectedDay);
    }).toList();

    int total = 0;
    String description = "";

    if (widget.type == 'Income') {
      total = selectedTransactions
          .where((transaction) => transaction.type == 'income')
          .fold(0, (sum, transaction) => sum + transaction.amount);
      description = "Your total income for the selected period.";
    } else if (widget.type == 'Expense') {
      total = selectedTransactions
          .where((transaction) => transaction.type == 'expense')
          .fold(0, (sum, transaction) => sum + transaction.amount);
      description = "Your total expenses for the selected period.";
    } else if (widget.type == 'Balance') {
      final income = selectedTransactions
          .where((transaction) => transaction.type == 'income')
          .fold(0, (sum, transaction) => sum + transaction.amount);
      description =
          "Your balance after accounting for all income and expenses.";

      final expense = selectedTransactions
          .where((transaction) => transaction.type == 'expense')
          .fold(0, (sum, transaction) => sum + transaction.amount);

      total = income - expense;
    }

    return Scaffold(
      backgroundColor: AppColors.neutralsSoftGrey2,
      appBar: AppBar(
        backgroundColor: AppColors.neutralsWhite,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.go('/dashboard');
          },
          icon: Icon(Icons.arrow_back, color: AppColors.neutralsDark1),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Total ${widget.type}",
              style: GoogleFonts.inter(
                color: AppColors.neutralsDark1,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            PopupMenuButton<String>(
              icon: Icon(
                Icons.arrow_drop_down,
                size: 28,
                color: AppColors.neutralsDark1,
              ),
              onSelected: (value) {
                setState(() {
                  widget.type = value;
                });
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(value: 'Income', child: Text('Income')),
                  PopupMenuItem(value: 'Expense', child: Text('Expense')),
                ];
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.neutralsWhite,
                    ),

                    child: TableCalendar(
                      focusedDay: focusedDay,
                      firstDay: firstDay,
                      lastDay: lastDay,
                      calendarFormat: _calendarFormat,

                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDay, day);
                      },

                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          this.selectedDay = selectedDay;
                          this.focusedDay = focusedDay;
                        });
                      },

                      headerStyle: HeaderStyle(
                        titleTextStyle: TextStyle(
                          color: AppColors.neutralsDark1,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        formatButtonTextStyle: TextStyle(
                          color: AppColors.neutralsDark1,
                        ),
                        formatButtonDecoration: BoxDecoration(
                          border: Border.all(color: AppColors.neutralsDark1),
                          borderRadius: BorderRadius.circular(12),
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
                        defaultTextStyle: TextStyle(
                          color: AppColors.neutralsDark1,
                        ),
                        weekendTextStyle: TextStyle(
                          color: AppColors.neutralsDark1,
                        ),
                        outsideTextStyle: TextStyle(
                          color: AppColors.neutralsGrey2,
                        ),
                        todayTextStyle: TextStyle(
                          color: AppColors.neutralsWhite,
                        ),
                        selectedTextStyle: TextStyle(
                          color: AppColors.neutralsWhite,
                        ),
                      ),

                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: AppColors.neutralsDark1),
                        weekendStyle: TextStyle(color: AppColors.neutralsDark1),
                      ),
                      onFormatChanged: (value) {
                        setState(() {
                          _calendarFormat =
                              _calendarFormat == CalendarFormat.week
                              ? CalendarFormat.month
                              : CalendarFormat.week;
                        });
                      },
                      availableCalendarFormats: const {
                        CalendarFormat.week: '7 days',
                        CalendarFormat.month: '1 month',
                      },
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _calendarFormat = _calendarFormat == CalendarFormat.week
                            ? CalendarFormat.month
                            : CalendarFormat.week;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _calendarFormat == CalendarFormat.week
                                ? 'Tampilkan selengkapnya'
                                : 'Tampilkan lebih sedikit',
                            style: GoogleFonts.inter(
                              color: AppColors.neutralsDark1,
                            ),
                          ),
                          Icon(
                            _calendarFormat == CalendarFormat.week
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            color: AppColors.neutralsDark1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradient00,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "Rp ${total}",
                        style: GoogleFonts.inter(
                          color: AppColors.neutralsWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "$description",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutralsDark1,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.neutralsWhite,
              ),
              child: Column(children: [SingleChildScrollView()]),
            ),
          ],
        ),
      ),
    );
  }
}
