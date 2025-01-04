import 'package:get_it/get_it.dart';

import '../../features/board_page/layers/data/datasources/board_page_datasource.dart';
import '../../features/board_page/layers/data/datasources/remote/board_page_remote_datasource_imp.dart';
import '../../features/board_page/layers/data/repositories/board_page_repository_imp.dart';
import '../../features/board_page/layers/domain/repositories/board_page_repository.dart';
import '../../features/board_page/layers/domain/usecases/board_page_usecase.dart';
import '../../features/board_page/layers/domain/usecases/board_page_usecase_imp.dart';
import '../../features/home_page/layers/data/datasources/home_page_datasource.dart';
import '../../features/home_page/layers/data/datasources/remote/home_page_remote_datasource_imp.dart';
import '../../features/home_page/layers/data/repositories/home_page_repository_imp.dart';
import '../../features/home_page/layers/domain/repositories/home_page_repository.dart';
import '../../features/home_page/layers/domain/usecases/home_page_usecase.dart';
import '../../features/home_page/layers/domain/usecases/home_page_usecase_imp.dart';

/// Method to inject dependencies before start app
void init() {
  final getIt = GetIt.instance;

  /// Database
  getIt.registerLazySingleton<HomePageDatasource>(
      HomePageRemoteDatasourceImp.new);

  getIt.registerLazySingleton<BoardPageDatasource>(
      BoardPageRemoteDatasourceImp.new);

  ///Repositories
  getIt.registerLazySingleton<HomePageRepository>(
    () => HomePageRepositoryImp(
      getIt(),
    ),
  );
  getIt.registerLazySingleton<BoardPageRepository>(
    () => BoardPageRepositoryImp(
      getIt(),
    ),
  );

  /// UseCases
  getIt.registerLazySingleton<HomePageUseCase>(
    () => HomePageUseCaseImp(
      getIt(),
    ),
  );
  getIt.registerLazySingleton<BoardPageUsecase>(
    () => BoardPageUsecaseImp(
      getIt(),
    ),
  );
}
