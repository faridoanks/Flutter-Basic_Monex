import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:monex/features/savings/saving_model.dart';
import 'package:monex/features/savings/saving_repository.dart';

class SavingProvider extends Notifier<List<SavingModel>> {
  final _repository = SavingRepository();

  @override
  List<SavingModel> build() {
    getAllSavings();
    return [];
  }

  Future<void> getAllSavings() async {
    final result = await _repository.getAllSavings();

    state = result;
  }

  Future<void> getSaving(String documentId) async {
    await _repository.getSaving(documentId);

    getAllSavings();
  }

  Future<void> createSaving(SavingModel saving) async {
    await _repository.createSaving(saving);

    getAllSavings();
  }

  Future<void> updateSaving(String documentId, SavingModel saving) async {
    await _repository.updateSaving(documentId: documentId, saving: saving);

    getAllSavings();
  }

  Future<void> deleteSaving(String documentId) async {
    await _repository.deleteSaving(documentId);

    getAllSavings();
  }
}

final loadSavingProvider = NotifierProvider<SavingProvider, List<SavingModel>>(
  () {
    return SavingProvider();
  },
);

final savingErrorProvider = StateProvider<bool>((ref) {
  return false;
});

final savingErrorMessageProvider = StateProvider<String>((ref) {
  return '';
});

final contributionTypeProvider = StateProvider<String>((ref) {
  return "Yearly";
});
