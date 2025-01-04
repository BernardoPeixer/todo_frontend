import 'package:dartz/dartz.dart';

import '../../data/dto/board_dto.dart';
import '../repositories/home_page_repository.dart';
import 'home_page_usecase.dart';

/// Class to implement the contract of get all workspaces use case
class HomePageUseCaseImp implements HomePageUseCase {
  final HomePageRepository _homePageRepository;

  /// Constructor
  HomePageUseCaseImp(this._homePageRepository);

  @override
  Future<Either<Exception, List<BoardDto>>> getAllBoards() =>
    _homePageRepository.getAllBoards();

  @override
  Future<void> addNewBoard(BoardDto board) =>
      _homePageRepository.addNewBoard(board);
}
