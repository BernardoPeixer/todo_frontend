import 'task_entity.dart';

/// Class to add tasks
class TaskListEntity {
  /// Task list id
  final int? id;

  /// Task list title
  final String? name;

  /// Task list description
  final String? description;

  /// Task list status code
  final int? statusCode;

  /// Task list tasks
  List<TaskEntity>? listTasks;

  /// Task list board id
  final int? boardId;

  /// Constructor
  TaskListEntity({
    this.id,
    this.name,
    this.listTasks,
    this.description,
    this.statusCode,
    this.boardId,
  });
}
