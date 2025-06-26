import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  String id;
  String title;
  String description;
  DateTime? deadline;
  bool isCompleted;
  DateTime createdAt;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    this.deadline,
    required this.isCompleted,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'deadline': deadline?.toIso8601String(),
    'isCompleted': isCompleted,
    'createdAt': createdAt,
  };

  static Goal fromMap(String id, Map<String, dynamic> map) => Goal(
    id: id,
    title: map['title'],
    description: map['description'],
    deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
    isCompleted: map['isCompleted'],
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
