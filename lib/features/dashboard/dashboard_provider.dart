import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/features/dashboard/dashboard_model.dart';
import 'package:monex/features/transactions/transaction_model.dart';
import 'package:monex/features/transactions/transaction_provider.dart';

class DashBoardNotifier extends Notifier<DashBoardModel> {
  @override
  DashBoardModel build() {
    final transactions = ref.watch(loadTransactionProvider);

    final income = totalIncome(transactions);
    final expense = totalExpense(transactions);
    final balance = totalBalance(income, expense);

    return DashBoardModel(
      totalBalance: balance,
      totalIncome: income,
      totalExpense: expense,
      recentTransactions: transactions,
      expenseChartData: [],
      period: DateTime.now(),
    );
  }

  int totalIncome(List<TransactionModel> transactions) {
    int total = 0;

    for (final transaction in transactions) {
      if (transaction.type == 'income') {
        total += transaction.amount;
      }
    }

    return total;
  }

  int totalExpense(List<TransactionModel> transactions) {
    int total = 0;

    for (final transaction in transactions) {
      if (transaction.type == 'expense') {
        total += transaction.amount;
      }
    }

    return total;
  }

  int totalBalance(int income, int expense) {
    return income - expense;
  }
}

final dashboardProvider =
    NotifierProvider<DashBoardNotifier, DashBoardModel>(() {
  return DashBoardNotifier();
});