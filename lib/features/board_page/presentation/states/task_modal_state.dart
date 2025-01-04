import 'package:fluent_ui/fluent_ui.dart';

import '../../layers/data/dto/task_dto.dart';
import '../../layers/domain/usecases/board_page_usecase.dart';

/// Class to state management of modal
class TaskModalState extends ChangeNotifier {
  /// Constructor
  TaskModalState({
    required BoardPageUsecase boardPageUseCase,
    required TaskDto taskDto,
  })  : _boardPageUsecase = boardPageUseCase,
        _taskDto = taskDto {
    init();
  }

  final BoardPageUsecase _boardPageUsecase;

  /// ----------------------------- ATTRIBUTES -----------------------------

  /// Task entity
  final TaskDto _taskDto;

  /// Description task controller
  final TextEditingController _descriptionTaskController =
      TextEditingController();

  /// Title task controller
  final TextEditingController _titleTaskController = TextEditingController();

  /// ----------------------------- GETTERS -----------------------------

  /// Getter for the text controller [_descriptionTaskController]
  TextEditingController get descriptionTaskController =>
      _descriptionTaskController;

  /// Getter for the text controller [_titleTaskController]
  TextEditingController get titleTaskController => _titleTaskController;

  /// ----------------------------- SETTERS -----------------------------

  /// ----------------------------- FUNCTIONS -----------------------------

  /// Function on modal appear
  void init() async {
    _descriptionTaskController.text = _taskDto.description ?? '';
    _titleTaskController.text = _taskDto.name ?? '';
  }

  /// Function to update task description and task name
  Future<void> updateTask() async {
    try {
      final task = TaskDto(
        id: _taskDto.id,
        name: _titleTaskController.text,
        description: _descriptionTaskController.text,
        boardId: _taskDto.boardId,
      );
      await _boardPageUsecase.editTask(task);
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }
}
