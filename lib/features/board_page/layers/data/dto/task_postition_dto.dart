class TaskPostitionDto {
  /// Task id
  final int? taskId;

  /// Task new position
  final int? newPosition;

  /// Task new list id
  final int? newListId;

  /// Task board id
  final int? boardId;

  /// Constructor
  TaskPostitionDto({
    this.taskId,
    this.newPosition,
    this.newListId,
    this.boardId,
  });
}
