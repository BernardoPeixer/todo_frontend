/// Class to management a task position
class TaskListPositionsDto {
  /// Dragged item id
  final int? draggedItemId;

  /// Target item id
  final int? targetItemId;

  /// Dragged item position
  final int? draggedItemPosition;

  /// Target item position
  final int? targetItemPosition;

  /// Board id
  final int? boardId;

  /// Constructor
  TaskListPositionsDto({
    this.draggedItemId,
    this.targetItemId,
    this.draggedItemPosition,
    this.targetItemPosition,
    this.boardId,
  });

  /// Function to convert a map to object
  factory TaskListPositionsDto.fromJson(Map<String, dynamic> json) {
    return TaskListPositionsDto(
      draggedItemId: json['dragged_item_id'],
      targetItemId: json['target_item_id'],
      draggedItemPosition: json['dragged_item_pos'],
      targetItemPosition: json['target_item_pos'],
      boardId: json['board_id'],
    );
  }
}
