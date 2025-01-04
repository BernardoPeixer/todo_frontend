import 'package:dartz/dartz.dart';

import '../../domain/repositories/home_page_repository.dart';
import '../datasources/home_page_datasource.dart';
import '../dto/board_dto.dart';

/// Class to implement the contract of get all workspaces repository
class HomePageRepositoryImp implements HomePageRepository {
  final HomePageDatasource _homePageDatasource;

  /// Constructor
  HomePageRepositoryImp(this._homePageDatasource);

  @override
  Future<Either<Exception, List<BoardDto>>> getAllBoards() async {
    final response = await _homePageDatasource.getAllBoards();

    final listWorkspace = <BoardDto>[];

    response.fold(
      (_) => null,
      (r) {
        for (final item in r) {
          listWorkspace.add(
            BoardDto.fromJson(item),
          );
        }
      },
    );
    return Right(listWorkspace);
  }

  @override
  Future<void> addNewBoard(BoardDto board) =>
      _homePageDatasource.addNewBoard(board);
}
