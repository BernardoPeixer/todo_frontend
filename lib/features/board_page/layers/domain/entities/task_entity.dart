/// Class responsible for the task entity
class TaskEntity {
  /// Task id
  final int? id;

  /// Task title
  final String? name;

  /// Task description
  final String? description;

  /// Task position
  int? position;

  /// Task status code
  final int? statusCode;

  /// Task board id
  final int? boardId;

  /// Task list id
  int? listId;

  /// Constructor
  TaskEntity({
    this.id,
    this.name,
    this.description,
    this.position,
    this.statusCode,
    this.boardId,
    this.listId,
  });
}
