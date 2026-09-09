class ReminderModel {
  String id;
  String title;
  String category;
  int amount;
  DateTime createdAt;
  DateTime dueDate;
  bool isCompleted;

  ReminderModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.createdAt,
    required this.dueDate,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'createdAt': createdAt,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      amount: map['amount'],
      createdAt: map['createdAt'],
      dueDate: map['dueDate'],
      isCompleted: map['isCompleted'],
    );
  }
}
