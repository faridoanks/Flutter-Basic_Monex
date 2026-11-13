import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/features/transactions/transaction_helper.dart';
import 'package:monex/features/transactions/transaction_provider.dart';
import 'package:monex/widgets/custom_table_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  final String type;
  const AddTransactionPage({super.key, required this.type});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  DateTime focusedDay = DateTime.now();
  late DateTime selectedDay = DateTime.now();
  final DateTime firstDay = DateTime(2020);
  final DateTime lastDay = DateTime(2030);

  CalendarFormat _calendarFormat = CalendarFormat.week;

  late String _currentType;

  @override
  void initState() {
    super.initState();
    _currentType = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    final category = Categories();
    final transaction = ref.watch(loadTransactionProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back, color: AppColors.neutralsDark1),
        ),
        centerTitle: true,
        title: Text(
          _currentType,
          style: GoogleFonts.inter(
            color: AppColors.neutralsDark1,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.neutralsWhite,
                    ),
                    child: CustomTableCalendar(
                      focusedDay: focusedDay,
                      firstDay: firstDay,
                      lastDay: lastDay,
                      calendarFormat: _calendarFormat,
                      selectedDay: selectedDay,
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
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Icon(
                        _calendarFormat == CalendarFormat.week
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: AppColors.neutralsDark1,
                        size: 28,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
