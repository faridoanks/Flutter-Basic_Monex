import 'package:flutter/material.dart';


class SavingModel {
  String id;
  String title;
  int currentAmount;
  int targetAmount;
  DateTime createdAt;
  DateTime deadline;
  Widget icon;
  bool isCompleted;

  SavingModel({
    required this.id,
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    required this.createdAt,
    required this.deadline,
    required this.icon,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'currentAmount': currentAmount,
      'targetAmount': targetAmount,
      'createdAt': createdAt,
      'deadline': deadline,
      'icon': icon,
      'isCompleted': isCompleted,
    };
  }

  factory SavingModel.fromMap(Map<String, dynamic> map) {
    return SavingModel(
      id: map['id'],
      title: map['title'],
      currentAmount: map['currentAmount'],
      targetAmount: map['targetAmount'],
      createdAt: map['createdAt'],
      deadline: map['deadline'],
      icon: map['icon'],
      isCompleted: map['isCompleted'],
    );
  }
}
