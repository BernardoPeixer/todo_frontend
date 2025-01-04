import 'package:dartz/dartz.dart';

import '../dto/board_dto.dart';


/// Class responsible for executing the get all workspaces contract
abstract class HomePageDatasource {
  /// Function to get all boards
  Future<Either<Exception, List<dynamic>>> getAllBoards();

  /// Function to add new board
  Future<void> addNewBoard(BoardDto board);
}
