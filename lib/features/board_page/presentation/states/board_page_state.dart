import 'package:fluent_ui/fluent_ui.dart';

import '../../../home_page/layers/data/dto/board_dto.dart';
import '../../layers/data/dto/task_dto.dart';
import '../../layers/data/dto/task_list_dto.dart';
import '../../layers/data/dto/task_list_positions_dto.dart';
import '../../layers/domain/entities/task_list_entity.dart';
import '../../layers/domain/usecases/board_page_usecase.dart';

/// Class to state management board page
class BoardPageState extends ChangeNotifier {
  /// Constructor
  BoardPageState({required int boardId, required boardPageUseCase})
      : _boardPageUsecase = boardPageUseCase,
        _boardId = boardId {
    initScreen();
  }

  final BoardPageUsecase _boardPageUsecase;

  /// ----------------------------- ATTRIBUTES -----------------------------

  /// Actual board instance
  BoardDto? _boardDto;

  /// Board id
  final int _boardId;

  /// Bool is loading
  bool _isLoading = false;

  /// Task list
  final taskList = <TaskListEntity>[];

  /// Bool to describe if is adding a new list
  bool isAddingNewList = false;

  /// Bool to describe if is adding a new card
  bool isAddingNewCard = false;

  /// Add button child
  Widget? child;

  /// Title list controller
  final TextEditingController _listTitleController = TextEditingController();

  /// -------------------------- GETTERS -------------------------------------

  /// Getter for the text controller [_listTitleController]
  TextEditingController get listTitleController => _listTitleController;

  /// Getter for the bool [_isLoading]
  bool get isLoading => _isLoading;

  /// Getter for the board instance [_boardDto]
  BoardDto? get boardDto => _boardDto;

  /// ------------------------- SETTERS -------------------------------------

  /// Setter for the bool [_isLoading]
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// ------------------------------- FUNCTIONS -----------------------------

  /// Function to init a screen
  Future<void> initScreen() async {
    isLoading = true;
    await getBoardDto();
    isLoading = false;
  }

  /// Function to reload a screen
  void reloadScreen() {
    notifyListeners();
  }

  /// Function to get a board instance
  Future<void> getBoardDto() async {
    try {
      _boardDto = await _boardPageUsecase.getBoardInfo(_boardId);
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

  /// Function to add new task list
  void addTaskList() {
    taskList.add(
      TaskListEntity(name: 'Testeee'),
    );
    notifyListeners();
  }

  /// On dragged item task list
  Future<void> onDraggedList(draggedItem, int index) async {
    final dragIndex = boardDto?.taskListDto?.indexOf(draggedItem);
    final targetItem = boardDto?.taskListDto?[index];

    if (dragIndex != null && targetItem != null) {
      boardDto?.taskListDto?[dragIndex] = targetItem;
      boardDto?.taskListDto?[index] = draggedItem;

      notifyListeners();

      final taskListPosition = TaskListPositionsDto(
        draggedItemId: draggedItem.id,
        targetItemId: targetItem.id,
        draggedItemPosition: draggedItem.position,
        targetItemPosition: targetItem.position,
        boardId: boardDto?.id,
      );
      await _boardPageUsecase.changeListTaskPosition(
        taskListPosition,
      );
    }
  }

  /// On dragged item task list
  Future<void> onDraggedTask(
    TaskDto draggedItem,
    TaskListDto sourceList,
    TaskListDto targetList,
    int newPosition,
  ) async {
    sourceList.tasksListDto ??= [];
    targetList.tasksListDto ??= [];

    sourceList.tasksListDto!.remove(draggedItem);

    for (var i = 0; i < sourceList.tasksListDto!.length; i++) {
      sourceList.tasksListDto![i].position = i;
    }

    draggedItem.position = newPosition;
    draggedItem.listId = targetList.id;

    final safePosition = (newPosition < targetList.tasksListDto!.length)
        ? newPosition
        : targetList.tasksListDto!.length;

    targetList.tasksListDto!.insert(safePosition, draggedItem);

    for (var i = 0; i < targetList.tasksListDto!.length; i++) {
      targetList.tasksListDto![i].position = i;
    }

    notifyListeners();
  }

  int calculateNewPosition(TaskDto draggedItem, TaskListDto? targetList) {
    if (targetList == null || targetList.tasksListDto == null) {
      return 0;
    }

    final listHeight = targetList.tasksListDto!.length;
    final itemHeight = 100; 
    
    return (listHeight * itemHeight) ~/ 2;
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

      await _boardPageUsecase.addNewTaskList(list);
      _listTitleController.clear();
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }

  /// Function to save a task
  Future<void> saveNewTask(
      TextEditingController controller, TaskListDto list) async {
    try {
      final task = TaskDto(
        name: controller.text,
        boardId: _boardDto?.id,
        listId: list.id,
        position: list.listTasks?.length,
      );

      if (controller.text.trim().isEmpty) {
        return;
      }

      await _boardPageUsecase.addNewTask(task);
    } on Exception {
      rethrow;
    }
  }
}
