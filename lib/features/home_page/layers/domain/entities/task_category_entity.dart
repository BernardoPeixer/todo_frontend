import '../../../../board_page/layers/domain/entities/task_entity.dart';

/// Entity Responsible Class of Task Category
class TaskCategoryEntity {
  /// Task category title
  final String? title;

  /// List of tasks
  final List<TaskEntity>? tasks;

  /// Constructor
  TaskCategoryEntity({
    this.title,
    this.tasks,
  });
}
