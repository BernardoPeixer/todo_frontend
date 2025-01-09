import '../../domain/repositories/board_page_repository.dart';
import '../datasources/board_page_datasource.dart';
import '../dto/board_dto.dart';
import '../dto/task_dto.dart';
import '../dto/task_list_dto.dart';
import '../dto/task_list_positions_dto.dart';
import '../dto/task_postition_dto.dart';

/// Class to implement the contract of board page repository
class BoardPageRepositoryImp implements BoardPageRepository {
  final BoardPageDatasource _boardPageDatasource;

  /// Constructor
  BoardPageRepositoryImp(this._boardPageDatasource);

  @override
  Future<void> saveNewTaskList(TaskListDto taskList) =>
      _boardPageDatasource.saveNewTaskList(taskList);

  @override
  Future<BoardDto?> getBoardInfo(int? boardId) async {
    final response = await _boardPageDatasource.getBoardInfo(boardId);

    if (response == null) {
      return null;
    }
    final board = BoardDto.fromJson(response);
    return board;
  }

  @override
  Future<void> addNewTask(TaskDto task) =>
      _boardPageDatasource.addNewTask(task);

  @override
  Future<void> editTask(TaskDto task) => _boardPageDatasource.editTask(task);

  @override
  Future<void> changeListTaskPosition(TaskListPositionsDto list) =>
      _boardPageDatasource.changeListTaskPosition(list);

  @override
  Future<void> changeTaskPosition(TaskPostitionDto task) =>
      _boardPageDatasource.changeTaskPosition(task);

  @override
  Future<List<BoardDto>?> getAllBoards() async {
    final response = await _boardPageDatasource.getAllBoards();

    final boardsList = <BoardDto>[];

    if (response == null) {
      return [];
    }

    for (final item in response) {
      boardsList.add(
        BoardDto.fromJson(item),
      );
    }

    return boardsList;
  }

  @override
  Future<void> addNewBoard(String boardTitle) =>
      _boardPageDatasource.addNewBoard(boardTitle);

  @override
  Future<void> deactivateTask(TaskDto task) =>
      _boardPageDatasource.deactivateTask(task);

  @override
  Future<void> deactivateTaskList(TaskListDto? taskList) =>
      _boardPageDatasource.deactivateTaskList(taskList);
}
