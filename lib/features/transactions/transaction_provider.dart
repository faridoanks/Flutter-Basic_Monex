import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/features/transactions/transaction_model.dart';
import 'package:monex/features/transactions/transaction_repository.dart';
import 'package:monex/features/auth/auth_provider.dart';

class TransactionProvider extends Notifier<List<TransactionModel>> {
  final _repository = TransactionRepository();

  @override
  List<TransactionModel> build() {
    final user = ref.read(loadAuthProvider);

    if (user != null) {
      getAllTransactions(user.uid);
    }

    return [];
  }

  Future<void> getAllTransactions(String userId) async {
    final result = await _repository.getAllTransactions(userId);

    state = result;
  }

  Future<void> getTransaction(String userId, String documentId) async {
    await _repository.getTransaction(userId, documentId);
  }

  Future<void> createTransaction(
    String userId,
    TransactionModel transaction,
  ) async {
    await _repository.createTransaction(userId, transaction);

    await getAllTransactions(userId);
  }

  Future<void> updateTransaction(
    String userId,
    String documentId,
    TransactionModel transaction,
  ) async {
    await _repository.updateTransaction(
      userId: userId,
      documentId: documentId,
      transaction: transaction,
    );

    await getAllTransactions(userId);
  }

  Future<void> deleteTransaction(String userId, String documentId) async {
    await _repository.deleteTransaction(userId: userId, documentId: documentId);

    await getAllTransactions(userId);
  }
}

final loadTransactionProvider =
    NotifierProvider<TransactionProvider, List<TransactionModel>>(() {
      return TransactionProvider();
    });
