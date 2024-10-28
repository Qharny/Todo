import 'package:hive/hive.dart';
import 'priority.dart';

part 'task.g.dart';

@HiveType(typeId: 3)
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
  dynamic categoryKey;

  @HiveField(7)
  Priority priority;

  @HiveField(8)
  List<String> tags;

  @HiveField(9)
  bool isDeleted;

  Task({
    required this.title,
    this.description,
    required this.dueDate,
    this.isCompleted = false,
    DateTime? createdAt,
    this.completedAt,
    this.categoryKey,
    this.priority = Priority.medium,
    List<String>? tags,
    this.isDeleted = false, required categoryId,
  })  : createdAt = createdAt ?? DateTime.now(),
        tags = tags ?? [];

  void markAsCompleted() {
    isCompleted = true;
    completedAt = DateTime.now();
  }

  void markAsIncomplete() {
    isCompleted = false;
    completedAt = null;
  }

  bool isOverdue() {
    if (isCompleted) return false;
    final now = DateTime.now();
    return now.isAfter(dueDate) &&
        (now.difference(dueDate).inDays > 0 || now.day != dueDate.day);
  }
}
