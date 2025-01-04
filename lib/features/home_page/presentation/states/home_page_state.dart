import 'dart:async';

import 'package:flutter/material.dart';

import '../../layers/data/dto/board_dto.dart';
import '../../layers/domain/usecases/home_page_usecase.dart';

/// Class to make a state management of home page ui
class HomePageState extends ChangeNotifier {
  /// Constructor
  HomePageState({
    required homePageUseCase,
  }) : _homePageUseCase = homePageUseCase {
    unawaited(loadScreen());
  }

  final HomePageUseCase _homePageUseCase;

  /// ----------------------------- ATTRIBUTES -----------------------------

  final _boardList = <BoardDto>[];

  Color _containerColor = Colors.black12;

  bool _isLoading = true;

  final TextEditingController _titleController = TextEditingController();

  /// ----------------------------- GETTERS --------------------------------

  /// Getter for the list [_boardList]
  List<BoardDto> get boardList => _boardList;

  /// Getter for the container color [_containerColor]
  Color get containerColor => _containerColor;

  /// Getter for the bool [_isLoading]
  bool get isLoading => _isLoading;

  /// Getter for the text editing controller [_titleController]
  TextEditingController get titleController => _titleController;

  /// ------------------------------- SETTERS --------------------------------

  set containerColor(Color value) {
    _containerColor = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// ------------------------------- FUNCTIONS -----------------------------

  /// On mouse enter in container
  void onMouseEnter() {
    containerColor = Colors.black38;
    notifyListeners();
  }

  /// Function to get all frames from db
  Future<void> getAllFrames() async {
    final response = await _homePageUseCase.getAllBoards();

    _boardList.clear();

    response.fold((_) => null, _boardList.addAll);

    notifyListeners();
  }

  /// Function to add a new board
  Future<void> addNewBoard(BuildContext context) async {
    try {
      final board = BoardDto(
        title: _titleController.text,
      );

      if ((_titleController.text).trim().isEmpty) {
        return;
      }

      await _homePageUseCase.addNewBoard(board);
      Navigator.of(context).pop();
      await loadScreen();
    } on Exception {
      rethrow;
    }
  }

  /// Load screen
  Future<void> loadScreen() async {
    isLoading = true;
    await getAllFrames();
    isLoading = false;
  }
}
