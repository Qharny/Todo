import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? description;

  @HiveField(2)
  int color;

  @HiveField(3)
  String iconName;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  bool isDeleted;

  Category({
    required this.name,
    this.description,
    required this.color,
    required this.iconName,
    DateTime? createdAt,
    this.isDeleted = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Color get categoryColor => Color(color);

  IconData get icon {
    // Map string names to IconData
    final iconMap = {
      'work': Icons.work,
      'personal': Icons.person,
      'shopping': Icons.shopping_cart,
      'health': Icons.favorite,
      'education': Icons.school,
      'finance': Icons.attach_money,
      'home': Icons.home,
      'other': Icons.category,
    };
    return iconMap[iconName.toLowerCase()] ?? Icons.category;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'color': color,
      'iconName': iconName,
      'createdAt': createdAt.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'],
      description: map['description'],
      color: map['color'],
      iconName: map['iconName'],
      createdAt: DateTime.parse(map['createdAt']),
      isDeleted: map['isDeleted'],
    );
  }
}