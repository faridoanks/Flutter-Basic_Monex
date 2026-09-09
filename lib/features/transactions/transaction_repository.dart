import 'package:monex/features/transactions/transaction_model.dart';
import 'package:monex/core/data/services/firestore_service.dart';

class TransactionRepository {
  final _firestoreService = FirestoreService();

  Future<String> createTransaction(
    String userId,
    TransactionModel transaction,
  ) async {
    return await _firestoreService.createData(
      collection: 'users/$userId/transactions',
      data: transaction.toMap(),
    );
  }

  Future<TransactionModel> getTransaction(
    String userId,
    String documentId,
  ) async {
    final document = await _firestoreService.readOneData(
      collection: 'users/$userId/transactions',
      documentId: documentId,
    );

    return TransactionModel.fromMap(
      document.data() as Map<String, dynamic>,
      document.id,
    );
  }

  Future<void> updateTransaction({
    required String userId,
    required String documentId,
    required TransactionModel transaction,
  }) async {
    await _firestoreService.updateData(
      collection: 'users/$userId/transactions',
      documentId: documentId,
      data: transaction.toMap(),
    );
  }

  Future<void> deleteTransaction({
    required String userId,
    required String documentId,
  }) async {
    await _firestoreService.deleteData(
      collection: 'users/$userId/transactions',
      documentId: documentId,
    );
  }

  Future<List<TransactionModel>> getAllTransactions(
    String userId,
  ) async {
    final result = await _firestoreService.readAllData(
      collection: 'users/$userId/transactions',
    );

    return result.docs.map((doc) {
      return TransactionModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }
}