import 'package:monex/features/reminders/reminder_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/features/reminders/reminder_model.dart';

class ReminderProvider extends Notifier<List<ReminderModel>> {
  final _repository = ReminderRepository();

  @override
  List<ReminderModel> build() {
    getAllReminders();
    return [];
  }

  Future<void> getAllReminders() async {
    final result = await _repository.getAllReminders();

    state = result;
  }

  Future<void> getReminder(String documentId) async {
    await _repository.getReminder(documentId);
  }

  Future<void> createReminder(ReminderModel reminder) async {
    await _repository.createReminder(reminder);

    await getAllReminders();
  }

  Future<void> updateReminder(String documentId, ReminderModel reminder) async {
    await _repository.updateReminder(
      documentId: documentId,
      reminder: reminder,
    );

    await getAllReminders();
  }

  Future<void> deleteReminder(String documentId) async {
    await _repository.deleteReminder(documentId);

    await getAllReminders();
  }
}

final loadReminderProvider =
    NotifierProvider<ReminderProvider, List<ReminderModel>>(() {
      return ReminderProvider();
    });
