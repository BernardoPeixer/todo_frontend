import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions/api_response_exception.dart';
import '../../layers/data/dto/board_dto.dart';
import '../../layers/data/dto/task_dto.dart';
import '../../layers/data/dto/task_list_dto.dart';
import '../../layers/data/dto/task_list_positions_dto.dart';
import '../../layers/data/dto/task_postition_dto.dart';
import '../../layers/domain/usecases/board_page_usecase.dart';

/// Class to state management board page
class BoardPageState extends ChangeNotifier {
  /// Constructor
  BoardPageState({required boardPageUseCase})
      : _boardPageUsecase = boardPageUseCase {
    initScreen();
  }

  final BoardPageUsecase _boardPageUsecase;

  /// ----------------------------- ATTRIBUTES -----------------------------

  /// Actual board instance
  BoardDto? _boardDto;

  /// Board id
  int? _boardId;

  /// Bool is loading
  bool _isLoading = false;

  /// Board list
  final _boardsList = <BoardDto>[];

  /// Bool to describe if is adding a new list
  bool isAddingNewList = false;

  /// Bool to describe if is adding a new card
  bool isAddingNewCard = false;

  /// Title list controller
  final TextEditingController _listTitleController = TextEditingController();

  /// Title board controller
  final TextEditingController _boardTitleController = TextEditingController();

  Color _backgroundAddTaskButton = Colors.transparent;

  final ScrollController _scrollController = ScrollController();

  /// -------------------------- GETTERS -------------------------------------

  /// Getter for the text controller [_listTitleController]
  TextEditingController get listTitleController => _listTitleController;

  /// Getter for the text controller [titleController]
  TextEditingController get boardTitleController => _boardTitleController;

  /// Getter for the bool [_isLoading]
  bool get isLoading => _isLoading;

  /// Getter for the board instance [_boardDto]
  BoardDto? get boardDto => _boardDto;

  /// Getter for the color button [_backgroundAddTaskButton]
  Color get backgroundAddTaskButton => _backgroundAddTaskButton;

  /// Getter for the scroll controller [_scrollController]
  ScrollController get scrollController => _scrollController;

  /// Getter for the list [_boardsList]
  List<BoardDto> get boardsList => _boardsList;

  /// Getter for the int [_boardId]
  int? get boardId => _boardId;

  /// ------------------------- SETTERS -------------------------------------

  /// Setter for the bool [_isLoading]
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Setter for the color [_backgroundAddTaskButton]
  set backgroundAddTaskButton(Color value) {
    _backgroundAddTaskButton = value;
    notifyListeners();
  }

  /// Setter for the int [_boardId]
  set boardId(int? value) {
    _boardId = value;
    notifyListeners();
  }

  /// ------------------------------- FUNCTIONS -----------------------------

  /// Function to init a screen
  Future<void> initScreen() async {
    isLoading = true;
    final pref = await SharedPreferences.getInstance();
    await getAllBoards();
    _boardId = pref.getInt('board_id');
    await getBoardDto();
    isLoading = false;
  }

  /// On tap in side bar tile
  Future<void> onTapSideBar(int boardId) async {
    _boardId = boardId;
    await getBoardDto();
    final pref = await SharedPreferences.getInstance();
    pref.setInt('board_id', boardId);
  }

  /// Function to reload a screen
  void reloadScreen() {
    notifyListeners();
  }

  /// Function to get a board instance
  Future<void> getBoardDto() async {
    try {
      _boardDto = await _boardPageUsecase.getBoardInfo(_boardId ?? 0);
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }

  /// Function to set a boolean to is adding list
  void isAddingList() {
    isAddingNewList = !isAddingNewList;
    notifyListeners();
  }

  /// Function to set a boolean to is adding new card
  void isAddingCard() {
    isAddingNewCard = !isAddingNewCard;
    notifyListeners();
  }

  /// On dragged item task list
  Future<void> onDraggedList(TaskListDto draggedItem, int targetIndex) async {
    final dragIndex = boardDto?.taskListDto?.indexOf(draggedItem);

    if (dragIndex != null && dragIndex != targetIndex) {
      final removedItem = boardDto?.taskListDto?.removeAt(dragIndex);

      if (removedItem != null) {
        boardDto?.taskListDto?.insert(targetIndex, removedItem);
        notifyListeners();

        try {
          final taskListPosition = TaskListPositionsDto(
            draggedItemId: draggedItem.id,
            targetItemId: boardDto?.taskListDto?[targetIndex].id ?? 0,
            draggedItemPosition: dragIndex,
            targetItemPosition: targetIndex,
            boardId: boardDto?.id,
          );
          await _boardPageUsecase.changeListTaskPosition(taskListPosition);
        } on Exception {
          rethrow;
        }
      }
    }
  }

  /// On dragged item task list
  Future<void> onDraggedTask(
    TaskDto task,
    int listCardLength,
    int listLength,
  ) async {
    board:
    for (final item in (_boardDto?.taskListDto ?? [])) {
      for (var index = 0; index < item.tasksListDto.length; index++) {
        final it = item.tasksListDto[index];
        if (it.id != task.id) {
          continue;
        }
        item.tasksListDto.removeAt(index);
        notifyListeners();
        break board;
      }
    }

    final list = _boardDto?.taskListDto?[listCardLength].tasksListDto ?? [];

    list.insert(listLength, task);

    notifyListeners();

    try {
      final changedTask = TaskPostitionDto(
        taskId: task.id,
        newListId: _boardDto?.taskListDto?[listCardLength].id,
        newPosition: listLength,
        boardId: task.boardId,
      );

      await _boardPageUsecase.changeTaskPosition(changedTask);
    } on Exception {
      rethrow;
    }
  }

  /// Function to save a new task list
  Future<void> saveNewTaskList() async {
    try {
      final list = TaskListDto(
        name: _listTitleController.text,
        description: '',
        position: _boardDto?.taskListDto?.length,
        statusCode: 1,
        boardId: _boardDto?.id,
      );

      if ((_listTitleController.text).trim().isEmpty) {
        return;
      }

      await _boardPageUsecase.saveNewTaskList(list);
      _listTitleController.clear();
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }

  /// Function to save a task
  Future<String?> saveNewTask(
      TextEditingController controller, TaskListDto list) async {
    try {
      final task = TaskDto(
        name: controller.text,
        boardId: _boardDto?.id,
        listId: list.id,
        position: list.tasksListDto?.length,
      );

      if (controller.text.trim().isEmpty) {
        return 'Insira um nome para criar uma nova tarefa!';
      }

      await _boardPageUsecase.addNewTask(task);
      return null;
    } on ApiResponseException catch (e) {
      return e.response.reasonPhrase;
    } on Exception {
      return 'Erro desconhecido';
    }
  }

  /// Function to get all boards
  Future<void> getAllBoards() async {
    try {
      final response = await _boardPageUsecase.getAllBoards();
      _boardsList
        ..clear()
        ..addAll(
          response ?? [],
        );
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }

  /// Function to add a new board
  Future<void> addNewBoard(BuildContext context) async {
    try {
      if ((_boardTitleController.text).trim().isEmpty) {
        return;
      }
      await _boardPageUsecase.addNewBoard(_boardTitleController.text);
      _boardTitleController.clear();
      Navigator.of(context).pop();
      await initScreen();
    } on Exception {
      rethrow;
    }
  }

  /// Function to deactivate a task
  Future<String?> deactivateTask(TaskDto task) async {
    try {
      await _boardPageUsecase.deactivateTask(task);
      await getBoardDto();
      return null;
    } on ApiResponseException catch (e) {
      return e.response.reasonPhrase;
    } on Exception {
      return 'Erro desconhecido';
    }
  }

  /// Function to deactivate a tasklist
  Future<String?> deactivateTaskList(TaskListDto? taskList) async {
    try {
      await _boardPageUsecase.deactivateTaskList(taskList);
      await getBoardDto();
      return null;
    } on ApiResponseException catch (e) {
      return e.response.reasonPhrase;
    } on Exception {
      return 'Erro inesperado';
    }
  }
}
