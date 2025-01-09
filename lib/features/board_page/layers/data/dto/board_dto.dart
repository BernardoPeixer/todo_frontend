import '../../../../board_page/layers/data/dto/task_list_dto.dart';
import '../../domain/entities/board_entity.dart';

/// Class to board requests
class BoardDto extends BoardEntity {
  /// Board task list DTO
  final List<TaskListDto>? taskListDto;

  /// Constructor
  BoardDto({
    super.id,
    super.title,
    List<TaskListDto>? listTasks,
  }) : taskListDto = listTasks ?? [];

  /// Function to convert a map to object
  factory BoardDto.fromJson(Map<String, dynamic> json) {
    final boardTasks = <TaskListDto>[];

    for (final item in json['task_list'] ?? []) {
      boardTasks.add(
        TaskListDto.fromJson(item),
      );
    }

    return BoardDto(
      id: json['id'],
      title: json['title'],
      listTasks: boardTasks,
    );
  }
}