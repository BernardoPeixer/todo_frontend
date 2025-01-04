import '../../../../home_page/layers/data/dto/board_dto.dart';
import '../../data/dto/task_dto.dart';
import '../../data/dto/task_list_dto.dart';
import '../../data/dto/task_list_positions_dto.dart';
import '../repositories/board_page_repository.dart';
import 'board_page_usecase.dart';

/// Class to use a contract by board page usecase
class BoardPageUsecaseImp implements BoardPageUsecase {
  final BoardPageRepository _boardPageRepository;

  /// Constructor
  BoardPageUsecaseImp(this._boardPageRepository);

  @override
  Future<void> saveNewTaskList(TaskListDto taskList) =>
      _boardPageRepository.saveNewTaskList(taskList);

  @override
  Future<BoardDto?> getBoardInfo(int? boardId) =>
      _boardPageRepository.getBoardInfo(boardId);

  @override
  Future<void> addNewTaskList(TaskListDto taskList) =>
      _boardPageRepository.addNewTaskList(taskList);

  @override
  Future<void> addNewTask(TaskDto task) =>
      _boardPageRepository.addNewTask(task);

  @override
  Future<void> editTask(TaskDto task) => _boardPageRepository.editTask(task);

  @override
  Future<void> changeListTaskPosition(TaskListPositionsDto list) =>
      _boardPageRepository.changeListTaskPosition(list);
}
