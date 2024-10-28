import 'package:hive/hive.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/task.dart';

part 'task_filter.g.dart';

@HiveType(typeId: 3)
class TaskFilter extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> categoryIds;

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
    List<String>? categoryIds,
    List<Priority>? priorities,
    this.showCompleted = true,
    this.startDate,
    this.endDate,
    List<String>? tags,
  })  : categoryIds = categoryIds ?? [],
        priorities = priorities ?? [],
        tags = tags ?? [];

  bool matchesTask(Task task) {
    if (!showCompleted && task.isCompleted) return false;
    if (categoryIds.isNotEmpty && !categoryIds.contains(task.categoryId)) {
      return false;
    }
    if (priorities.isNotEmpty && !priorities.contains(task.priority)) {
      return false;
    }
    if (startDate != null && task.dueDate.isBefore(startDate!)) return false;
    if (endDate != null && task.dueDate.isAfter(endDate!)) return false;
    if (tags.isNotEmpty && !tags.any((tag) => task.tags.contains(tag))) {
      return false;
    }
    return true;
  }
}

// repositories/task_repository.dart
class TaskRepository {
  final Box<Task> _taskBox;
  final Box<Category> _categoryBox;

  TaskRepository(this._taskBox, this._categoryBox);

  // CRUD operations
  Future<void> addTask(Task task) async {
    await _taskBox.add(task);
  }

  Future<void> updateTask(Task task) async {
    await task.save();
  }

  Future<void> deleteTask(Task task) async {
    task.isDeleted = true;
    await task.save();
  }

  Future<void> permanentlyDeleteTask(Task task) async {
    await task.delete();
  }

  // Queries
  List<Task> getAllTasks({bool includeDeleted = false}) {
    return _taskBox.values
        .where((task) => includeDeleted || !task.isDeleted)
        .toList();
  }

  List<Task> getTasksByCategory(String categoryId) {
    return _taskBox.values
        .where((task) => !task.isDeleted && task.categoryId == categoryId)
        .toList();
  }

  List<Task> getOverdueTasks() {
    return _taskBox.values
        .where((task) => !task.isDeleted && task.isOverdue())
        .toList();
  }

  List<Task> getTasksByFilter(TaskFilter filter) {
    return _taskBox.values
        .where((task) => !task.isDeleted && filter.matchesTask(task))
        .toList();
  }
}