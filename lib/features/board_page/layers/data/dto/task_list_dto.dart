import 'package:fluent_ui/fluent_ui.dart';

import '../../domain/entities/task_list_entity.dart';
import 'task_dto.dart';

/// Class to extends from task list entity to management a JSON data
class TaskListDto extends TaskListEntity {
  /// Task list position
  int? position;

  /// List of tasks dto
  List<TaskDto>? tasksListDto;

  /// Global key
  final GlobalKey globalKey = GlobalKey();

  /// Constructor
  TaskListDto({
    this.position,
    this.isAddingCard = false,
    super.id,
    super.name,
    super.description,
    super.statusCode,
    List<TaskDto>? listTasks,
    super.boardId,
    TextEditingController? cardTitleController,
  })  : cardTitleController = cardTitleController ?? TextEditingController(),
        tasksListDto = listTasks;

  /// Is adding card boolean
  bool isAddingCard;

  /// Card text controller
  final TextEditingController cardTitleController;

  /// Function to set a boolean to is adding new card
  void isAddingCardSetBoolean() {
    isAddingCard = !isAddingCard;
  }

  /// Function to convert a json to object
  factory TaskListDto.fromJson(Map<String, dynamic> json) {
    final taskList = <TaskDto>[];

    for (final item in json['tasks']) {
      taskList.add(
        TaskDto.fromJson(item),
      );
    }

    return TaskListDto(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      listTasks: taskList,
      position: json['position'],
      statusCode: json['status_code'],
      boardId: json['board_id'],
    );
  }
}
