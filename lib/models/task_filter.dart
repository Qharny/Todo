import 'package:hive/hive.dart';
import 'priority.dart';
import 'task.dart';

part 'task_filter.g.dart';

@HiveType(typeId: 4)
class TaskFilter extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<dynamic> categoryKeys;

  @HiveField(2)
  List<Priority> priorities;

  @HiveField(3)
  bool showCompleted;

  @HiveField(4)
  DateTime? startDate;

  @HiveField(5)
  DateTime? endDate;

  @HiveField(6)
  List<String> tags;

  TaskFilter({
    required this.name,
    List<dynamic>? categoryKeys,
    List<Priority>? priorities,
    this.showCompleted = true,
    this.startDate,
    this.endDate,
    List<String>? tags,
  })  : categoryKeys = categoryKeys ?? [],
        priorities = priorities ?? [],
        tags = tags ?? [];

  bool matchesTask(Task task) {
    // Don't show deleted tasks
    if (task.isDeleted) return false;

    // Filter by completion status
    if (!showCompleted && task.isCompleted) return false;

    // Filter by category
    if (categoryKeys.isNotEmpty && !categoryKeys.contains(task.categoryKey)) {
      return false;
    }

    // Filter by priority
    if (priorities.isNotEmpty && !priorities.contains(task.priority)) {
      return false;
    }

    // Filter by date range
    if (startDate != null && task.dueDate.isBefore(startDate!)) {
      return false;
    }
    if (endDate != null && task.dueDate.isAfter(endDate!)) {
      return false;
    }

    // Filter by tags
    if (tags.isNotEmpty && !tags.any((tag) => task.tags.contains(tag))) {
      return false;
    }

    return true;
  }
}