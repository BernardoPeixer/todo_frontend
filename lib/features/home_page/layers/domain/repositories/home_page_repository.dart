

import 'package:dartz/dartz.dart';

import '../../data/dto/board_dto.dart';

/// Class responsible for executing the get all workspaces contract
abstract class HomePageRepository {
  /// Function to get all workspaces
  Future<Either<Exception, List<BoardDto>>> getAllBoards();

  /// Function to add new board
  Future<void> addNewBoard(BoardDto board);
}