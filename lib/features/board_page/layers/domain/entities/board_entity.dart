import '../../../../board_page/layers/domain/entities/task_list_entity.dart';

/// Class responsible for the workspace entity
class BoardEntity {

  /// Workspace Id
  final int? id;

  /// Workspace title
  final String? title;

  /// Board list tasks
  final List<TaskListEntity>? listTasks;

  /// Constructor
  BoardEntity({
    this.title,
    this.listTasks,
    this.id,
  });
}