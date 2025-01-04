import '../../../../home_page/layers/data/dto/board_dto.dart';
import '../../data/dto/task_dto.dart';
import '../../data/dto/task_list_dto.dart';
import '../../data/dto/task_list_positions_dto.dart';

/// Class to define a contract for usecase board page
abstract class BoardPageUsecase {
  /// Function to save a new task list
  Future<void> saveNewTaskList(TaskListDto taskList);

  /// Function to get board info
  Future<BoardDto?> getBoardInfo(int? boardId);

  /// Function to add new task list
  Future<void> addNewTaskList(TaskListDto taskList);

  /// Function to add new task
  Future<void> addNewTask(TaskDto task);

  /// Function to add new task
  Future<void> editTask(TaskDto task);
  
  /// Function to change a list task position
  Future<void> changeListTaskPosition(TaskListPositionsDto list);
}