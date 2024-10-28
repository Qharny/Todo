import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String? description;

  @HiveField(2)
  DateTime dueDate;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? completedAt;

  @HiveField(6)
  String? categoryId;

  @HiveField(7)
  Priority priority;

  @HiveField(8)
  List<String> tags;

  @HiveField(9)
  bool isDeleted;
  
  @HiveField(10)
  var id;

  @HiveField(11)
  dynamic categoryKey;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.isCompleted = false,
    DateTime? createdAt,
    this.completedAt,
    this.categoryId,
    this.priority = Priority.medium,
    List<String>? tags,
    this.isDeleted = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        tags = tags ?? [];

  // Helper methods
  void markAsCompleted() {
    isCompleted = true;
    completedAt = DateTime.now();
  }

  void markAsIncomplete() {
    isCompleted = false;
    completedAt = null;
  }

  bool isOverdue() {
    return !isCompleted && DateTime.now().isAfter(dueDate);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'categoryId': categoryId,
      'priority': priority.index,
      'tags': tags,
      'isDeleted': isDeleted,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'],
      createdAt: DateTime.parse(map['createdAt']),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      categoryId: map['categoryId'],
      priority: Priority.values[map['priority']],
      tags: List<String>.from(map['tags']),
      isDeleted: map['isDeleted'], id: null,
    );
  }
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high,

  @HiveField(3)
  urgent
}