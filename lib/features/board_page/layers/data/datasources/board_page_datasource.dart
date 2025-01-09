import '../dto/task_dto.dart';
import '../dto/task_list_dto.dart';
import '../dto/task_list_positions_dto.dart';
import '../dto/task_postition_dto.dart';

/// Class responsible for executing the get all board page contract
abstract class BoardPageDatasource {
  /// Function to save a new task list
  Future<void> saveNewTaskList(TaskListDto taskList);

  /// Function to get board info
  Future<Map<String, dynamic>?> getBoardInfo(int? boardId);

  /// Function to add new task
  Future<void> addNewTask(TaskDto task);

  /// Function to add new task
  Future<void> editTask(TaskDto task);

  /// Function to change a list task position
  Future<void> changeListTaskPosition(TaskListPositionsDto list);

  /// Function to change a task position
  Future<void> changeTaskPosition(TaskPostitionDto task);

  /// Function to get all boards
  Future<List<dynamic>?> getAllBoards();

  /// Function to add new board
  Future<void> addNewBoard(String boardTitle);

  /// Funtion to deactivate a task
  Future<void> deactivateTask(TaskDto task);

  
  /// Funtion to deactivate a task
  Future<void> deactivateTaskList(TaskListDto? taskList);
}
