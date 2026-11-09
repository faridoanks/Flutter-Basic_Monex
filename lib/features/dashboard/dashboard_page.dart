import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/features/auth/auth_provider.dart';
import 'package:monex/features/dashboard/dashboard_provider.dart';
import 'package:monex/features/dashboard/overview_card_page.dart';
import 'package:monex/features/transactions/transaction_provider.dart';
import 'package:monex/widgets/overview_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monex/features/transactions/transaction_helper.dart';
import 'package:monex/widgets/small_feature_card.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  bool isAddMode = false;
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final user = ref.read(loadAuthProvider);

      if (user != null) {
        ref.read(loadTransactionProvider.notifier).getAllTransactions(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = Categories();

    final user = ref.watch(loadAuthProvider);
    final dashboard = ref.watch(dashboardProvider);
    final transactions = ref.watch(loadTransactionProvider);
    final formatCurrency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final totalBalance = formatCurrency.format(dashboard.totalBalance);
    final totalIncome = formatCurrency.format(dashboard.totalIncome);
    final totalExpense = formatCurrency.format(dashboard.totalExpense);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.neutralsWhite,
        title: Text(
          'Hello, ${user!.displayName} !',
          style: GoogleFonts.inter(
            color: AppColors.neutralsDark1,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL ?? ''),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.neutralsSoftGrey2,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
              left: 24,
              bottom: 32,
              right: 24,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  OverviewCard(
                    onTapped: () {
                      context.go('/overview-card-page?type=Balance');
                    },
                    category: 'Total Balance',
                    amount: totalBalance,
                  ),
                  SizedBox(width: 16),
                  OverviewCard(
                    onTapped: () {
                      context.go('/overview-card-page?type=Income');
                    },
                    category: 'Total Income',
                    amount: totalIncome,
                  ),
                  SizedBox(width: 16),
                  OverviewCard(
                    onTapped: () {
                      context.go('/overview-card-page?type=Expense');
                    },
                    category: 'Total Expense',
                    amount: totalExpense,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),
          Expanded(
            child: Container(
              width: double.infinity,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.neutralsWhite,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),

                      child: isAddMode
                          ? Row(
                              key: const ValueKey('add'),
                              children: [
                                Expanded(
                                  child: SmallFeatureCard(
                                    title: 'Add Income',
                                    icon: Icons.add_circle_outline,
                                    onTapped: () {},
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SmallFeatureCard(
                                    title: 'Add Expense',
                                    icon: Icons.remove_circle_outline,
                                    onTapped: () {},
                                  ),
                                ),
                              ],
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                            child: Row(
                                key: const ValueKey('normal'),
                                children: [
                                  SmallFeatureCard(
                                    title: 'Add',
                                    icon: Icons.add,
                                    onTapped: () {},
                                  ),
                                  const SizedBox(width: 12),
                                  SmallFeatureCard(
                                    title: 'Reminders',
                                    icon: Icons.notifications_none,
                                    onTapped: () {},
                                  ),
                                  const SizedBox(width: 12),
                                  SmallFeatureCard(
                                    title: 'Budget',
                                    icon: Icons.bar_chart_outlined,
                                    onTapped: () {},
                                  ),
                                ],
                              ),
                          ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Latest Entries',
                          style: GoogleFonts.inter(
                            color: AppColors.neutralsDark1,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_horiz,
                            color: AppColors.neutralsDark1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dashboard.recentTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction =
                              dashboard.recentTransactions[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,

                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.neutralsSoftGrey2,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                categories.getCategoryIcon(
                                  transaction.category,
                                ),
                              ),
                            ),

                            title: Text(
                              transaction.title,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutralsDark1,
                              ),
                            ),

                            subtitle: Text(
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(transaction.createdAt),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: AppColors.neutralsGrey2,
                              ),
                            ),

                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${transaction.type == 'income' ? '+' : '-'} ${formatCurrency.format(transaction.amount)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: transaction.type == 'income'
                                        ? AppColors.secondaryGreenDark
                                        : AppColors.secondaryRedDark,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  transaction.note ?? '',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: AppColors.neutralsGrey2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
