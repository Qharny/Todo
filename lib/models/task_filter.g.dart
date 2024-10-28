// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_filter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskFilterAdapter extends TypeAdapter<TaskFilter> {
  @override
  final int typeId = 4;

  @override
  TaskFilter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskFilter(
      name: fields[0] as String,
      categoryKeys: (fields[1] as List?)?.cast<dynamic>(),
      priorities: (fields[2] as List?)?.cast<Priority>(),
      showCompleted: fields[3] as bool,
      startDate: fields[4] as DateTime?,
      endDate: fields[5] as DateTime?,
      tags: (fields[6] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskFilter obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.categoryKeys)
      ..writeByte(2)
      ..write(obj.priorities)
      ..writeByte(3)
      ..write(obj.showCompleted)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskFilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
