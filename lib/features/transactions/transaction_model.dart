import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String id;
  String userId;
  String title;
  String type;
  String category;
  String? note;
  int amount;
  DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.category,
    required this.amount,
    required this.createdAt,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'type': type,
      'category': category,
      'amount': amount,
      'createdAt': createdAt,
      'note': note,
    };
  }

  factory TransactionModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return TransactionModel(
      id: documentId,
      userId: map['userId'],
      title: map['title'],
      type: map['type'],
      category: map['category'],
      amount: map['amount'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      note: map['note'],
    );
  }
}