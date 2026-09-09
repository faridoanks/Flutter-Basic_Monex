import 'package:monex/features/savings/saving_model.dart';
import 'package:monex/core/data/services/firestore_service.dart';

class SavingRepository {
  final _firestoreService = FirestoreService();

  static const String _collection = 'savings';

  Future<String> createSaving(SavingModel saving) async {
    return await _firestoreService.createData(
      collection: _collection,
      data: saving.toMap(),
    );
  }

  Future<SavingModel> getSaving(String documentId) async {
    final document = await _firestoreService.readOneData(
      collection: _collection,
      documentId: documentId,
    );

    return SavingModel.fromMap(document.data() as Map<String, dynamic>);
  }

  Future<void> updateSaving({
    required String documentId,
    required SavingModel saving,
  }) async {
    await _firestoreService.updateData(
      collection: _collection,
      documentId: documentId,
      data: saving.toMap(),
    );
  }

  Future<void> deleteSaving(String documentId) async {
    await _firestoreService.deleteData(
      collection: _collection,
      documentId: documentId,
    );
  }

  Future<List<SavingModel>> getAllSavings() async {
    final result = await _firestoreService.readAllData(collection: _collection);

    return result.docs.map((e) {
      return SavingModel.fromMap(
        result.docs[0].data() as Map<String, dynamic>,
      );
    }).toList();
  }
}
