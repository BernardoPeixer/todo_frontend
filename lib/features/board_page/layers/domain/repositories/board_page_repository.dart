import '../../data/dto/board_dto.dart';
import '../../data/dto/task_dto.dart';
import '../../data/dto/task_list_dto.dart';
import '../../data/dto/task_list_positions_dto.dart';
import '../../data/dto/task_postition_dto.dart';

/// Class to define a board page contracts
abstract class BoardPageRepository {
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

   /// Function to change a task position
  Future<void> changeTaskPosition(TaskPostitionDto task);

  /// Function to get all boards
  Future<List<BoardDto>?> getAllBoards();

  /// Function to get all boards
  Future<void> addNewBoard(String boardTitle);
}