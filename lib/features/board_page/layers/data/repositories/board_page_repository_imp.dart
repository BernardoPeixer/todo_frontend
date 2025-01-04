import '../../../../home_page/layers/data/dto/board_dto.dart';
import '../../domain/repositories/board_page_repository.dart';
import '../datasources/board_page_datasource.dart';
import '../dto/task_dto.dart';
import '../dto/task_list_dto.dart';
import '../dto/task_list_positions_dto.dart';

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
  Future<void> addNewTaskList(TaskListDto taskList) =>
      _boardPageDatasource.addNewTaskList(taskList);

  @override
  Future<void> addNewTask(TaskDto task) =>
      _boardPageDatasource.addNewTask(task);

  @override
  Future<void> editTask(TaskDto task) => _boardPageDatasource.editTask(task);

  @override
  Future<void> changeListTaskPosition(TaskListPositionsDto list) =>
      _boardPageDatasource.changeListTaskPosition(list);
}
