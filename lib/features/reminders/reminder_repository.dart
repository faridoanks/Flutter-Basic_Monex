import 'package:monex/features/reminders/reminder_model.dart';
import 'package:monex/core/data/services/firestore_service.dart';

class ReminderRepository {
  final _firestoreService = FirestoreService();

  static const String _collection = 'reminders';

  Future<String> createReminder(ReminderModel reminder) async {
    return await _firestoreService.createData(
      collection: _collection,
      data: reminder.toMap(),
    );
  }

  Future<ReminderModel> getReminder(String documentId) async {
    final document = await _firestoreService.readOneData(
      collection: _collection,
      documentId: documentId,
    );

    return ReminderModel.fromMap(document.data() as Map<String, dynamic>);
  }

  Future<void> updateReminder({
    required String documentId,
    required ReminderModel reminder,
  }) async {
    await _firestoreService.updateData(
      collection: _collection,
      documentId: documentId,
      data: reminder.toMap(),
    );
  }

  Future<void> deleteReminder(String documentId) async {
    await _firestoreService.deleteData(
      collection: _collection,
      documentId: documentId,
    );
  }

  Future<List<ReminderModel>> getAllReminders() async {
    final result = await _firestoreService.readAllData(collection: _collection);

    List<ReminderModel> reminders = [];

    for (var documents in result.docs) {
      reminders.add(
        ReminderModel.fromMap(documents.data() as Map<String, dynamic>),
      );
    }

    return reminders;
  }
}
