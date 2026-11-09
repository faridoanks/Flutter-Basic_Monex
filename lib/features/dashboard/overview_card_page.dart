import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/features/dashboard/dashboard_provider.dart';
import 'package:monex/features/transactions/transaction_helper.dart';
import 'package:monex/widgets/custom_table_calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class OverviewCardPage extends ConsumerStatefulWidget {
  final String type;
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
  String _activeTab = 'spends';

  late String _currentType;

  void initState() {
    super.initState();
    _currentType = widget.type;
  }

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

    final currentTransactions = selectedTransactions.where((transaction) {
      return transaction.type == _currentType.toLowerCase();
    }).toList();

    int total = 0;
    String description = "";

    if (_currentType == 'Income') {
      total = selectedTransactions
          .where((transaction) => transaction.type == 'income')
          .fold(0, (sum, transaction) => sum + transaction.amount);
      description = "Your total income for the selected period.";
    } else if (_currentType == 'Expense') {
      total = selectedTransactions
          .where((transaction) => transaction.type == 'expense')
          .fold(0, (sum, transaction) => sum + transaction.amount);
      description = "Your total expenses for the selected period.";
    } else if (_currentType == 'Balance') {
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

    final totalChartAmount = currentTransactions.fold<int>(
      0,
      (sum, transaction) => sum + transaction.amount,
    );

    final random = Random();

    final chartColors = List.generate(
      currentTransactions.length,
      (_) => Colors.primaries[random.nextInt(Colors.primaries.length)],
    );
    final pieSections = currentTransactions.asMap().entries.map((entry) {
      final index = entry.key;
      final transaction = entry.value;

      return PieChartSectionData(
        value: transaction.amount.toDouble(),
        color: chartColors[index],
        showTitle: false,
      );
    }).toList();

    if (totalChartAmount > 0) {
      pieSections.add(
        PieChartSectionData(
          value: totalChartAmount.toDouble(),
          color: Colors.transparent,
          showTitle: false,
        ),
      );
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
              "Total ${_currentType}",
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
                  _currentType = value;
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
      body: CustomScrollView(
        slivers: [
          // 1. ELEMEN ATAS: Kalender, Lingkaran Total, dan Deskripsi (Statis)
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Kalender sesuai format awal
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                  child: Container(
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

                const SizedBox(height: 16),

                // Lingkaran Biru Besar Total Saldo/Pengeluaran sesuai Desain
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(
                      0xff1d4ed8,
                    ), // Warna biru solid sesuai desain gambar
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff1d4ed8).withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Rp $total",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Teks Informasi Deskripsi Dinamis di Bawah Lingkaran
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppColors.neutralsDark1.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Komponen Tab Bar (Spends | Categories) Sesuai Gambar Desain
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _activeTab = 'spends';
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "Spends",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: _activeTab == 'spends'
                                      ? AppColors.primaryBrand
                                      : AppColors.neutralsGrey2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 3,
                                color: _activeTab == 'spends'
                                    ? AppColors.primaryBrand
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _activeTab = 'categories';
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "Categories",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: _activeTab == 'categories'
                                      ? AppColors.primaryBrand
                                      : AppColors.neutralsGrey2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 3,
                                color: _activeTab == 'categories'
                                    ? AppColors.primaryBrand
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_activeTab == 'categories')
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      //yehhh
                      PieChartData(
                        sections: pieSections,
                        startDegreeOffset: 180,
                        centerSpaceRadius: 50,
                      ),
                    ),
                  ),

                if (_activeTab == 'categories')
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 8,
                    children: currentTransactions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final transaction = entry.value;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: chartColors[index],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            transaction.category,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.neutralsDark1,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 16),
              ],
            ),
          ),

          // 2. DAFTAR LIST: Menggunakan SliverList agar Pemuatan Malas (Lazy Load) Berjalan Mulus Bebas Lag
          selectedTransactions.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: Text(
                        "No transactions available",
                        style: GoogleFonts.inter(
                          color: AppColors.neutralsGrey2,
                        ),
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final transaction = selectedTransactions[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.neutralsWhite,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.neutralsSoftGrey2,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${typeOptions}",
                              ), // Menggunakan widget ikon asli bawaan dari variable category di atas
                            ),
                            const SizedBox(width: 16),

                            // Judul Transaksi dan Tanggal
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction.title ?? "Transaction",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.neutralsDark1,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${transaction.createdAt.day}/${transaction.createdAt.month}/${transaction.createdAt.year}",
                                    style: GoogleFonts.inter(
                                      color: AppColors.neutralsGrey2,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${transaction.type == 'income' ? '+' : '-'} Rp ${transaction.amount}",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: transaction.type == 'income'
                                        ? const Color(0xff16a34a)
                                        : AppColors.neutralsDark1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  transaction.type == 'income'
                                      ? 'Income'
                                      : 'Expense',
                                  style: GoogleFonts.inter(
                                    color: AppColors.neutralsGrey2,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }, childCount: selectedTransactions.length),
                  ),
                ),
        ],
      ),
    );
  }
}
