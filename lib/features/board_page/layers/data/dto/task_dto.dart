
import '../../domain/entities/task_entity.dart';

/// Class to extends from task entity to management a JSON data
class TaskDto extends TaskEntity {
  /// Constructor
  TaskDto({
    super.id,
    super.name,
    super.description,
    super.position,
    super.statusCode,
    super.boardId,
    super.listId,
  });

  

  /// Function to convert a json to object
  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      position: json['position'],
      statusCode: json['status_code'],
      boardId: json['board_id'],
      listId: json['task_list_id'],
    );
  }
}
