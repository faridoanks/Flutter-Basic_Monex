import 'package:monex/features/transactions/transaction_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:monex/features/dashboard/chart_data.dart';

class DashBoardModel {
  int totalBalance;
  int totalIncome;
  int totalExpense;
  List<TransactionModel> recentTransactions;
  List<ChartData> expenseChartData;
  DateTime? period;

  DashBoardModel({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.recentTransactions,
    required this.expenseChartData,
    required this.period,
  });

  DashBoardModel copyWith({
    int? totalBalance,
    int? totalIncome,
    int? totalExpense,
    List<TransactionModel>? recentTransactions,
    List<ChartData>? expenseChartData,
    DateTime? period,
  }) {
    return DashBoardModel(
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      expenseChartData: expenseChartData ?? this.expenseChartData,
      period: period ?? this.period,
    );
  }
  
}
